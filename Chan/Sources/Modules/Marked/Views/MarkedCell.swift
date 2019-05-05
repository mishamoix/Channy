//
//  MarkedCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit

class MarkedCell: UITableViewCell {
    @IBOutlet weak var preview: ChanImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTheme()

        self.preview.layer.cornerRadius = DefaultCornerRadius
        self.preview.clipsToBounds = true
        self.preview.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(with model: ThreadModel) {
        self.preview.loadImage(media: model.media.first, full: true)
        
        var text = model.subject
        if let board = model.board {
            text = "\(board.name) • \(text)"
            
            if let imageboard = board.imageboard {
                text = "\(imageboard.name) • \(text)"
            }
        }
        
        text = "\(String.date(from: model.created)) • \(text)"
        
        self.label.text = text
    }
    
    private func setupTheme() {
        self.backgroundColor = .clear
        ThemeManager.shared.append(view: ThemeView(view: self.contentView, type: .cell, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.label, type: .text, subtype: .none))
    }
}
