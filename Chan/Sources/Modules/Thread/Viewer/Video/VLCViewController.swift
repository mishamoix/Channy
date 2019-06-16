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

enum VLCCurrentState {
    case playing
    case paused
}

class VLCViewController: UIViewController {

    
    @IBOutlet weak var movieView: UIView!
    //    private let movieView = UIView()
    @IBOutlet weak var closeButton: UIButton!
    private let mediaPlayer = VLCMediaPlayer()
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var remaingTime: UILabel!
    @IBOutlet weak var controlCanvas: UIView!
    @IBOutlet weak var closeCanvas: UIView!
    
    private var fullTime: Float = 0
    private var state: VLCCurrentState = .paused
    private var canChangeSlider = true
    private var canvasDiaplayed = true
    
//    private let closeButton = UIButton()
    private let disposeBag = DisposeBag()
    
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.mediaPlayer.delegate = self
        RotationManager.apply(orientation: .all)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.mediaPlayer.play()
        self.changePlay()
        
        self.mediaPlayer.time = VLCTime(int: 3)
    }
    
    private func setup() {
        if let url = self.url {
            self.mediaPlayer.drawable = self.movieView
            self.mediaPlayer.media = VLCMedia(url: url)
        }
        
        self.setupUI()
        self.setupRx()
        self.setupGesture()
        
    }
    
    
    
    private func setupUI() {
//        let theme = ThemeManager.shared.theme
        self.closeButton.tintColor = .white
        self.currentTime.textColor = .white
        self.remaingTime.textColor = .white
        self.timeSlider.tintColor = .white
        self.playPauseButton.tintColor = .white
        
        let corenrRadius: CGFloat = 8
        self.controlCanvas.clipsToBounds = true
        self.controlCanvas.layer.cornerRadius = corenrRadius
        self.controlCanvas.backgroundColor = .black
        
        self.closeCanvas.clipsToBounds = true
        self.closeCanvas.layer.cornerRadius = corenrRadius
        self.closeCanvas.backgroundColor = .black
        
        self.movieView.backgroundColor = .black
        
        self.timeSlider.maximumValue = 1.0
        self.timeSlider.minimumValue = 0.0
        self.timeSlider.value = 0.0
        self.timeSlider.setThumbImage(.playerCircle, for: .normal)
    }

    private func setupRx() {
        self.closeButton
            .rx
            .tap
            .subscribe(onNext: {[weak self] _ in
                RotationManager.makeDefault()
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
        
        
        self.timeSlider
            .rx
            .value
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.canChangeSlider = true
                self.mediaPlayer.time = VLCTime(int: self.sliderToTime())
            })
            .disposed(by: self.disposeBag)
        
        
//        self.timeSlider
//            .rx
//            .controlEvent(.editingDidBegin)
//            .asObservable()
//            .subscribe(onNext: { [weak self] _ in
//                self?.canChangeSlider = false
////                guard let self = self else { return }
//
//                //                print("Full time \(self.mediaPlayer.remainingTime.value)")
//            })
//            .disposed(by: self.disposeBag)

        
        self.playPauseButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] _  in
                self?.changePlay()
            })
            .disposed(by: self.disposeBag)

    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer()
        self.movieView.addGestureRecognizer(tapGesture)
        self.movieView.isUserInteractionEnabled = true
        
        tapGesture
            .rx
            .event
            .subscribe(onNext: { [weak self] _ in
                self?.changeDisplay()
            })
            .disposed(by: self.disposeBag)
    }
    
    
    private func changePlay() {
        if self.state == .paused {
            self.state = .playing
            self.mediaPlayer.play()
            self.playPauseButton.setImage(.pauseVideo, for: .normal)
        } else {
            self.state = .paused
            self.mediaPlayer.pause()
            self.playPauseButton.setImage(.playVideo, for: .normal)
        }
    }
    
    private func changeDisplay() {
        self.closeCanvas.layer.removeAllAnimations()
        self.controlCanvas.layer.removeAllAnimations()
        
        if self.canvasDiaplayed {
            self.canvasDiaplayed = false
            self.closeCanvas.layer.opacity = 1
            self.controlCanvas.layer.opacity = 1
            UIView.animate(withDuration: AnimationDuration, animations: {
                self.closeCanvas.layer.opacity = 0
                self.controlCanvas.layer.opacity = 0
            }) { finished in
                if finished {
                    self.closeCanvas.isHidden = true
                    self.controlCanvas.isHidden = true
                }
            }
        } else {
            self.canvasDiaplayed = true
            self.closeCanvas.isHidden = false
            self.controlCanvas.isHidden = false

            self.closeCanvas.layer.opacity = 0
            self.controlCanvas.layer.opacity = 0
            UIView.animate(withDuration: AnimationDuration, animations: {
                self.closeCanvas.layer.opacity = 1
                self.controlCanvas.layer.opacity = 1
            }) { finished in
                if finished {
                }
            }

        }
    }
    

    private func timeToSlider(time: Float) -> Float {
        if self.fullTime == 0 {
            return 0
        }
        return min(1, time / self.fullTime)
    }
    
    private func sliderToTime() -> Int32 {
        return Int32(self.timeSlider.value * self.fullTime)
    }


}


extension VLCViewController: VLCMediaPlayerDelegate {
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        
        if let remainingTime = self.mediaPlayer.remainingTime.value, self.fullTime == 0 {
            self.fullTime = self.mediaPlayer.time.value.floatValue + abs(remainingTime.floatValue)
        }
        
        if self.canChangeSlider {
            self.timeSlider.value = self.timeToSlider(time: self.mediaPlayer.time.value.floatValue)
        }
        
        self.currentTime.text = self.mediaPlayer.time.stringValue
        self.remaingTime.text = self.mediaPlayer.remainingTime.stringValue
    }
    
    
}
