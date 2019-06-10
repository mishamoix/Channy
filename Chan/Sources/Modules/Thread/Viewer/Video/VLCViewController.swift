//
//  VLCViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class VLCViewController: UIViewController {

    
    private let movieView = UIView()
    private let mediaPlayer = VLCMediaPlayer()
    private let closeButton = UIButton()
    private let disposeBag = DisposeBag()
    
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    private func setup() {
        self.view.addSubview(self.movieView)
        self.movieView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let url = self.url {
            self.mediaPlayer.drawable = self.movieView
            self.mediaPlayer.media = VLCMedia(url: url)
        }
        
        
        self.view.addSubview(self.closeButton)
        self.closeButton.setTitle("Закрыть", for: .normal)
        self.closeButton.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.closeButton
            .rx
            .tap
            .subscribe(onNext: {[weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mediaPlayer.play()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
