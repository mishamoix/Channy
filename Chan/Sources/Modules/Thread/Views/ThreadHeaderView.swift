//
//  ThreadHeaderView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 28/04/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit

class ThreadHeaderView: UIView {
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    
    private let bgImage = ChanImageView()
    private let title = UILabel()
    
    init(max: CGFloat, min: CGFloat) {
        self.maxHeight = max
        self.minHeight = min
        
        super.init(frame: CGRect(x: 0, y: 0, width: max, height: max))
        
        self.setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(scroll: UIScrollView) {
        
        
        let y = scroll.contentOffset.y + scroll.contentInset.top
        
        let titleAlpha = ValueMapper.map(minRange: self.minHeight, maxRange: self.maxHeight, minDomain: 0.0 , maxDomain: 1.0, value: y)
        let bgAlpha = 1.0 - titleAlpha
        
        self.bgImage.alpha = bgAlpha
        self.title.alpha = titleAlpha
        
    }
    
    func update(model: ThreadModel?) {
        guard let model = model else { return }
        
        self.bgImage.cancelLoad()
        self.bgImage.loadImage(media: model.media.first, full: true)
        
        self.title.text = model.subject
    }
    
    
    // MARK: Private
    
    private func setupUI() {
        
        self.addSubview(self.bgImage)
        self.addSubview(self.title)
        
        self.bgImage.contentMode = .scaleAspectFill
        self.bgImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.title.font = UIFont.postTitleExtra
        self.title.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
            make.left.equalToSuperview().offset(PostTextLeftMargin)
            make.right.equalToSuperview().offset(-PostTextLeftMargin)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        
//        self.backgroundColor = .red
        
        self.setupTheme()
    }
    
    private func setupTheme() {
        ThemeManager.shared.append(view: ThemeView(view: self, type: .background, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.title, type: .text, subtype: .none))
    }
    
}
