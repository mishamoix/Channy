//
//  BoardsTableHeader.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import AlamofireImage

class BoardsTableHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var boardTitle: UILabel!
    @IBOutlet weak var addBoards: UIButton!
    
    static var instance: BoardsTableHeader {
        return Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as! BoardsTableHeader
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.boardImage.layer.cornerRadius = DefaultCornerRadius
        self.setupTheme()
    }

    func update(with model: ImageboardModel) {
        
        self.boardTitle.text = model.name
        if let logo = model.logo {
            self.boardImage.af_setImage(withURL: logo)
        }
    }
    
    
    private func setupTheme() {
        self.backgroundColor = .clear
        self.canvasView.backgroundColor = .clear
        ThemeManager.shared.append(view: ThemeView(view: self, type: .background, subtype: .none))

        ThemeManager.shared.append(view: ThemeView(view: self.boardTitle, type: .text, subtype: .none))
    }
    
}
