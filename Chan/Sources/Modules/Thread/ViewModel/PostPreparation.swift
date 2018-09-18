//
//  PostPreparation.swift
//  Chan
//
//  Created by Mikhail Malyshev on 16.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation

private let AvailableParseTags = ["a", "span", "strong"]

class PostPreparation {
    
    private let text: String
    private(set) var attributedText: NSMutableAttributedString
    
    private let thread: String
    private let post: String
    
    private(set) var replyedPosts: [ChanLinkModel] = []
    
    private var attributedTextString: String {
        return self.attributedText.string
    }
    
    private var regexOption: NSRegularExpression.Options {
        return NSRegularExpression.Options.caseInsensitive
    }
    
    private var regexMatchingOption: NSRegularExpression.MatchingOptions {
        return NSRegularExpression.MatchingOptions.init(rawValue: 0)
    }
    
    private var regexStrong: String {
        return "<strong[^>]*>(.*?)</strong>"
    }
    
    init(text: String, thread: String, post: String) {
        self.text = TextStripper.htmlToNormal(in: text)
        
        self.thread = thread
        self.post = post
        
        let attr = Style.post(text: self.text)
        self.attributedText = attr

        
        self.process()
    }
    
    
    private func process() {
        
        let range = NSRange(location: 0, length: self.attributedTextString.count)
        
        self.emAndStrongProcess(in: range)
        self.underlineProcess(in: range)
        self.strikeProcess(in: range)
        self.spoilerProcess(in: range)
        self.quote(in: range)
        self.linkPost(in: range)
        self.removeTags(in: range)
        
        var resultRange = NSRange(location: 0, length: self.attributedTextString.count)
        self.regexDelete(regex: "^\\s\\s*", range: resultRange)
        
        resultRange = NSRange(location: 0, length: self.attributedTextString.count)
        self.regexDelete(regex: "\\s\\s*$", range: resultRange)
        
        resultRange = NSRange(location: 0, length: self.attributedTextString.count)
        self.regexDelete(regex: "^[\\t\\f\\p{Z}]+", range: resultRange)
        
        TextStripper.finishHtmlToNormal(in: self.attributedText.mutableString)
    }
    
    private func regexFind(regex regexString: String, range fullRange: NSRange, result: (NSRange) -> ()) {
        if let regex = self.prepareRegex(regexString) {
            regex.enumerateMatches(in: self.attributedTextString, options: self.regexMatchingOption, range: fullRange) { (res, flags, stop) in
                if let rng = res?.range {
                    result(rng)
                }
            }
        }
    }
    
    private func prepareRegex(_ string: String) -> NSRegularExpression? {
        return try? NSRegularExpression(pattern: string, options: NSRegularExpression.Options.caseInsensitive)
    }
    
    private func regexDelete(regex regexString: String, range fullRange: NSRange) {
        self.regexFind(regex: regexString, range: fullRange) { range in
            if range.length != 0 {
                self.attributedText.deleteCharacters(in: range)
            }
        }
    }

    

    private func emAndStrongProcess(in range: NSRange) {
        var ems: [NSRange] = []
        var strongs: [NSRange] = []

        self.regexFind(regex: "<em[^>]*>(.*?)</em>", range: range) { range in
            Style.em(text: self.attributedText, range: range)
            ems.append(range)

        }
        
        self.regexFind(regex: self.regexStrong, range: range) { range in
            Style.strong(text: self.attributedText, range: range)
            strongs.append(range)
        }
        
        for em in ems {
            for strong in strongs {
                let emStrongRange = NSIntersectionRange(em, strong)
                if emStrongRange.length != 0 {
                    Style.emStrong(text: self.attributedText, range: emStrongRange)
                }
            }
        }
    }
    
    

    private func underlineProcess(in range: NSRange) {
        self.regexFind(regex: "<span class=\"u\">(.*?)</span>", range: range) { range in
            Style.underline(text: self.attributedText, range: range)
        }
    }
    
    private func strikeProcess(in range: NSRange) {
        
    }
    
    private func spoilerProcess(in range: NSRange) {
        self.regexFind(regex: "<span class=\"spoiler\">(.*?)</span>", range: range) { range in
            Style.spoiler(text: self.attributedText, range: range)
        }
    }
    
    private func quote(in range: NSRange) {
        self.regexFind(regex: "<span class=\"unkfunc\">(.*?)</span>", range: range) { range in
            Style.quote(text: self.attributedText, range: range)
        }
    }
    
    private func linkPost(in fullRange: NSRange) {
        if let linkFirstFormat = self.prepareRegex("href=\"(.*?)\""), let linkSecondFormat = self.prepareRegex("href='(.*?)'") {
            self.regexFind(regex: "<a[^>]*>(.*?)</a>", range: fullRange) { range in
                let fullLink = self.attributedTextString.substring(in: range)
                let fullLinkRange = NSRange(location: 0, length: fullLink.count)
                
                var urlRange = NSRange(location: 0, length: 0)
                if let linkResult = linkFirstFormat.firstMatch(in: fullLink, options: regexMatchingOption, range: fullLinkRange) {
                    if linkResult.numberOfRanges != 0 {
                        urlRange = NSMakeRange(linkResult.range.location+6, linkResult.range.length-7);
                    }
                } else if let linkResult = linkSecondFormat.firstMatch(in: fullLink, options: self.regexMatchingOption, range: fullLinkRange) {
                    if linkResult.numberOfRanges != 0 {
                        urlRange = NSMakeRange(linkResult.range.location+6, linkResult.range.length-7);
                    }
                }
                
                if urlRange.length != 0 {
                    let urlString = TextStripper.ampToNormal(in: fullLink.substring(in: urlRange))
                    
                    let parser = LinkParser(path: urlString)
                    let linkType = parser.type
                    
                    switch linkType {
                    case .boardLink(let chanLink): do {
                        self.replyedPosts.append(chanLink)
                        }
                    case .externalLink:
                        break
                    }
                }
                
                Style.linkPost(text: self.attributedText, range: range)
            }
        }
    }
    
    private func removeTags(in fullRange: NSRange) {
        var ranges: [NSRange] = []
        self.regexFind(regex: "<[^>]*>", range: fullRange) { range in
            ranges.append(range)
        }
        
        var shift: Int = 0
        for range in ranges {
            let newRange = NSRange(location: range.location - shift, length: range.length)
            self.attributedText.deleteCharacters(in: newRange)
            shift += range.length
        }
        
    }
    
}
