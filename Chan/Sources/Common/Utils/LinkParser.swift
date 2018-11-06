//
//  LinkParser.swift
//  Chan
//
//  Created by Mikhail Malyshev on 18.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

enum LinkType {
    case externalLink
    case boardLink(link: ChanLinkModel)
}

class LinkParser {
    
    private let path: String
    private var board: String? = nil
    private var thread: String? = nil
    private var post: String? = nil
    
    private(set) var type: LinkType = .externalLink
    
    private var baseUrl: [String] {
        return [Enviroment.default.basePathWithoutScheme]
    }
    
    
    init(path: String) {
        self.path = path
        self.type = .externalLink
        
        self.processType()
        
    }
    
    func processType() {
        
        guard let url = URL(string: self.path) else {
            return
        }
        
        if let host = url.host {
            // may be external link
            let wwwBaseHosts = self.baseUrl.map({ "www." + $0 }) + self.baseUrl
            if let url2ch = URL(string: self.preprocess(link: self.path)), wwwBaseHosts.contains(host) {
                self.parse2ch(link: url2ch)
            } else {
                self.type = .externalLink
            }
        } else {
            // it's 2ch link
            if let url2ch = URL(string: self.preprocess(link: self.path)) {
                self.parse2ch(link: url2ch)
            }
        }
    }
    
    
    private func parse2ch(link: URL) {
        let components = link.pathComponents.filter { $0 != "/" }
        
        if components.count > 0 {
            self.board = components[0]
        }
        
        if components.count > 2 {
            self.thread = components[2]
        }
        
        if let fragment = link.fragment {
            self.post = fragment
        }
        
        if !RegexChecker.check(regex: "[a-z, A-Z]+", value: self.board) || (!RegexChecker.check(regex: "[0-9]+.html", value: self.thread) && !RegexChecker.check(regex: "[0-9]+", value: self.thread)) || !RegexChecker.check(regex: "[0-9]+", value: self.post) {
            self.type = .externalLink
        } else {
            self.thread = self.thread?.replacingOccurrences(of: ".html", with: "")
            let chanLink = ChanLinkModel(board: self.board, thread: self.thread, post: self.post)
            self.type = .boardLink(link: chanLink)
        }
        
    }
    
    private func preprocess(link: String) -> String {
        var result = link
        if !(link.hasPrefix("https://") || link.hasPrefix("http://")) && !link.hasPrefix("/") {
            result = "https://" + link
        }
        
        return result
    }
}


