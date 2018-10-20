//
//  PostMediaView.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19/10/2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit

class PostMediaView: UIView {
    
    let image = ChanImageView()
    private let playIcon = UIImageView()
    private let playCanvas = UIView()

    init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func update(with file: FileModel) {
        
        self.isHidden = false
        self.playCanvas.isHidden = file.type == .image
        self.cancelLoad()
        if let thumb = URL(string: MakeFullPath(path: file.thumbnail)) {
            self.load(url: thumb)
        }
        
    }
    
    private func load(url: URL) {
        self.image.load(url: url)
    }
    
    func cancelLoad() {
        self.image.cancelLoad()
    }
    
    private func setupUI() {
        self.addSubview(self.image)
        self.addSubview(self.playCanvas)
        self.playCanvas.addSubview(self.playIcon)
        
        self.image.contentMode = .scaleAspectFill
        
        self.playIcon.image = .play
        self.playIcon.tintColor = .white
        
        self.image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.playCanvas.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.playIcon.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
        }
        
        self.playCanvas.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.playCanvas.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playCanvas.layer.cornerRadius = self.playCanvas.frame.size.width / 2.0
    }
    
    
    
}
