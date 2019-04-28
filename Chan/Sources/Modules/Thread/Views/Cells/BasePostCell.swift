//
//  BasePostCell.swift
//  Chan
//
//  Created by Mikhail Malyshev on 17.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift


protocol BasePostCellProtocol {
    func update(with model: PostViewModel)
    func update(action: PublishSubject<PostCellAction>?)
}

class BasePostCell: UICollectionViewCell, BasePostCellProtocol {
    
//    private let titleLabel = TGReusableLabel()
//    private let replyedButton = UIButton()
//    private let replyButton = UIButton()
    let disposeBag = DisposeBag()
    
    let number = UILabel()
    let uid = UILabel()
    let date = UILabel()
    let reply = UIButton()
    let headerDelimeter = UIView()
    
    private var highlightDisposeBag = DisposeBag()
    
    var canPerformAction: Bool = true
        
    weak var action: PublishSubject<PostCellAction>?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupRx()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.canPerformAction = true
    }
    
    func setupUI() {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = ThreadCornerRadius
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.contentView.addSubview(self.number)
        self.contentView.addSubview(self.uid)
        self.contentView.addSubview(self.date)
        self.contentView.addSubview(self.reply)
        self.contentView.addSubview(self.headerDelimeter)
        
        self.number.font = .postTitle
        
        self.uid.font = .secondaryText
        
        self.date.font = .secondaryText
        self.date.textAlignment = .right
        
        self.reply.backgroundColor = .clear
        self.reply.setTitle("Ответить", for: .normal)
        self.reply.titleLabel?.font = .secondaryText
        self.reply.contentHorizontalAlignment = .right
//        self.reply.titleLabel?.textAlignment = .left
        
//        self.layer.borderColor = UIColor.groupTableViewBackground.cgColor
//        self.layer.borderWidth = 1
//
//        self.clipsToBounds = true
//        self.layer.cornerRadius = DefaultCornerRadius
//
//        self.contentView.addSubview(self.titleLabel)
//        self.titleLabel.backgroundColor = .clear
//
//        self.contentView.addSubview(self.replyedButton)
//        self.replyedButton.layer.cornerRadius = DefaultCornerRadius
//        self.replyedButton.layer.borderColor = ThemeManager.shared.theme.accnt.cgColor
//        self.replyedButton.layer.borderWidth = 1
//        self.replyedButton.setTitleColor(ThemeManager.shared.theme.accnt, for: .normal)
//        self.replyedButton.titleLabel?.font = UIFont.postTitle
//
//        self.replyedButton.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-PostButtonRightMargin)
//            make.bottom.equalToSuperview().offset(-PostButtonBottomMargin)
//            make.size.equalTo(PostButtonSize)
//        }
//
//        self.contentView.addSubview(self.replyButton)
//        self.replyButton.layer.cornerRadius = DefaultCornerRadius
//        self.replyButton.layer.borderColor = ThemeManager.shared.theme.accnt.cgColor
//        self.replyButton.layer.borderWidth = 1
//        self.replyButton.setTitleColor(ThemeManager.shared.theme.accnt, for: .normal)
//        self.replyButton.titleLabel?.font = UIFont.postTitle
////        self.replyButton.setBackgroundImage(.reply, for: .normal)
//        self.replyButton.setImage(.reply, for: .normal)
//
//        let inset: CGFloat = 4
//        self.replyButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: 2 * inset, bottom: inset, right: 2 * inset)
//        self.replyButton.tintColor = ThemeManager.shared.theme.accnt
//
//
//        self.replyButton.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(PostButtonRightMargin)
//            make.bottom.equalToSuperview().offset(-PostButtonBottomMargin)
//            make.size.equalTo(PostButtonSize)
//        }
//
        self.setupTheme()
//
    }
    
    private func setupRx() {
//        self.replyedButton
//            .rx
//            .tap
//            .asDriver()
//            .drive(onNext: { [weak self] in
//                if let strongSelf = self {
//                    self?.action?.on(.next(.openReplys(cell: strongSelf)))
//                }
//            }).disposed(by: self.disposeBag)
//
//        self.replyButton
//            .rx
//            .tap
//            .asDriver()
//            .drive(onNext: { [weak self] in
//                if let strongSelf = self {
//                    self?.action?.on(.next(.reply(cell: strongSelf)))
//                }
//            }).disposed(by: self.disposeBag)

    }
    
    func update(with model: PostViewModel) {
        
        self.updateHeader(with: model)
        
        if model.isFirst {
            self.backgroundColor = .clear
        } else {
            self.backgroundColor = ThemeManager.shared.theme.cell
        }
        
//        self.titleLabel.attributedText = model.title
//        self.titleLabel.frame = model.titleFrame
//        self.titleLabel.setNeedsDisplay()
//
//        self.replyedButton.isHidden = model.shoudHideReplyedButton
//        self.replyedButton.setTitle(model.replyedButtonText, for: .normal)
//
//        self.highlightIfNeeded(model: model)

    }
    
    func update(action: PublishSubject<PostCellAction>?) {
        self.action = action
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
//    self.themeManager.append(view: ThemeView(view: self.collectionView, type: .collection, subtype: .none))

    func setupTheme() {
//        ThemeManager.shared.append(view: ThemeView(view: self, type: .cell, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.number, type: .text, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.uid, type: .text, subtype: .third))
        ThemeManager.shared.append(view: ThemeView(view: self.date, type: .text, subtype: .third))
        ThemeManager.shared.append(view: ThemeView(view: self.headerDelimeter, type: .separator, subtype: .none))
        ThemeManager.shared.append(view: ThemeView(view: self.reply.titleLabel, type: .text, subtype: .primary))
//        ThemeManager.shared.append(view: ThemeView(view: self, type: .cell, subtype: .border))
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return self.canPerformAction && ThreadAvailableContextMenu.contains(action.description) 
    }
    
    
    @objc public func copyText() {
        self.action?.on(.next(.copyText(cell: self)))
    }
    
    @objc public func copyOrigianlText() {
        self.action?.on(.next(.copyOriginalText(cell: self)))
    }
    
    @objc public func copyLink() {
        self.action?.on(.next(.copyPostLink(cell: self)))
    }
    
    @objc public func screenshot() {
//        if let image = self.snapshot() {
//            CameraPermissionManager.request {
//                UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
//            }
//        }
    }
    
    
    private func highlightIfNeeded(model: PostViewModel) {
        self.layer.removeAllAnimations()
        self.highlightDisposeBag = DisposeBag()
        if model.needHighlight {
//            let scale: CGFloat = 1.05
            model.needHighlight = false
            
            Observable<Void>.just(Void())
                .flatMap { [weak self] _ -> Observable<Void> in
                    return Observable<Void>
                        .just(Void())
                        .map({ [weak self] val -> Void in
                            UIView.animate(withDuration: AnimationDuration, animations: {
                                self?.backgroundColor = UIColor.gray
                            })
                            return val
                        })
                        .delay(AnimationDuration, scheduler: Helper.rxMainThread)
                }
                .delay(LongAnimationDuration, scheduler: Helper.rxMainThread)
                .subscribe(onNext: {  [weak self] val in
                    UIView.animate(withDuration: AnimationDuration, animations: {
                        self?.backgroundColor = ThemeManager.shared.theme.cell
                    })

                }, onError: { err in
                    
                }, onCompleted: {
                    
                }, onDisposed: { [weak self] in
                    self?.backgroundColor = ThemeManager.shared.theme.cell

                })
//                .subscribe(onNext: { [weak self] _ in
//                    UIView.animate(withDuration: AnimationDuration, animations: {
//                        self?.backgroundColor = ThemeManager.shared.theme.cell
//                    }
//                }, onError: { _ in
//
//                }, onCompleted: {
//
//                }, onDisposed: { [weak self] in
//                    self?.backgroundColor = ThemeManager.shared.theme.cell
//
//                })
                .disposed(by: self.highlightDisposeBag)
            
//            UIView.animate(withDuration: LongAnimationDuration, animations: {
////                self.transform = CGAffineTransform(scaleX: scale, y: scale)
//                self.backgroundColor = ThemeManager.shared.theme.cell.withAlphaComponent(0.2)
//            }) { finished in
////                self.transform = CGAffineTransform.identity
//                self.backgroundColor = ThemeManager.shared.theme.cell
//            }
        }
    }
    
    
//    private func updateNumber()
    
    private func updateHeader(with model: PostViewModel) {
        
        let leftOffset: CGFloat = PostTextLeftMargin
        let rightOffset: CGFloat = PostTextRightMargin
        
        let sideOffset = leftOffset + rightOffset
        
        let topOffset: CGFloat = 11
        
        let smallTextHeight: CGFloat = 15
        
        self.number.frame = CGRect(x: leftOffset, y: topOffset, width: self.contentView.frame.width / 3 - sideOffset, height: 22)
        self.uid.frame = CGRect(x: self.number.frame.minX, y: self.number.frame.maxY + 2, width: self.number.frame.width, height: smallTextHeight)
        self.date.frame = CGRect(x: self.number.frame.maxX + rightOffset, y: self.number.frame.minY + 2, width: 2 * self.contentView.frame.width / 3 - rightOffset, height: smallTextHeight)
        self.reply.frame = CGRect(x: self.date.frame.minX, y: self.date.frame.maxY + 5, width: self.date.frame.width, height: self.date.frame.height)
        
        self.headerDelimeter.frame = CGRect(x: leftOffset, y: self.uid.frame.maxY + topOffset, width: self.contentView.frame.width - leftOffset, height: 0.5)
        
        self.number.text = model.numberDisplay
        self.uid.text = model.uidDisplay
        self.date.text = model.dateDisplay
        
        
//        self.date
    }
}
