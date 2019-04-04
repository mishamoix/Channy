//
//  BoardSelectionInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 31/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol BoardSelectionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol BoardSelectionPresentable: Presentable {
    var listener: BoardSelectionPresentableListener? { get set }
    var uiLoaded: Observable<Bool> { get }
    
    func update(data: [BoardSelectionViewModel])
    func close()
    
}

protocol BoardSelectionListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class BoardSelectionInteractor: PresentableInteractor<BoardSelectionPresentable>, BoardSelectionInteractable, BoardSelectionPresentableListener {

    weak var router: BoardSelectionRouting?
    weak var listener: BoardSelectionListener?
    
    private let service: BoardlistSelectionProtocol
    private let disposeBag = DisposeBag()
    
    private var data: [BoardSelectionViewModel] = []
    private var filtredData: [BoardSelectionViewModel] = []
    private var models: [BoardModel] = []
    private var currentSearchString: String? = nil
    
    init(presenter: BoardSelectionPresentable, service: BoardlistSelectionProtocol) {
        self.service = service
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        self.setup()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    // MARK:  BoardSelectionPresentableListener
    func select(model: BoardSelectionViewModel) {
        model.selected = !model.selected
        self.presenter.update(data: self.filtredData)
    }
    
    func save() {
        let selectedIds = self.data.filter({ $0.selected }).map({ $0.id })
        let modelsForSave = self.models.map({ model -> BoardModel in
            model.selected = selectedIds.contains(model.id)
            return model
        })
        
        self.service.save(boards: modelsForSave)
        self.presenter.close()
        
    }
    
    func update(search string: String?) {
        self.currentSearchString = string
        self.makeSearch()
    }

    
    // MARK: Private
    
    func setup() {
        self.setupRx()
    }
    
    func setupRx() {
        self.service
            .currentImageboard()
            .flatMap({ [weak self] model -> Observable<ImageboardModel?> in
                guard let self = self else { return Observable<ImageboardModel?>.just(model) }
                
                return self.presenter
                    .uiLoaded
                    .filter({ $0 })
                    .flatMap({ [weak model] loaded -> Observable<ImageboardModel?> in
                        return Observable<ImageboardModel?>.just(model)
                    })
            })
            .subscribe(onNext: { [weak self] model in
                if let boards = model?.boards {
                    self?.models = boards
                    let newBoards = boards.map({ BoardSelectionViewModel(model: $0) })
                    self?.data = newBoards
                    self?.makeSearch()
                }
            })
            .disposed(by: self.disposeBag)
        
    }
    
    func makeSearch() {
//        Helper.performOnBGThread {
            var result: [BoardSelectionViewModel] = []
            
            if let search = self.currentSearchString {
                if search.count == 0 {
                    result = self.data
                } else {
                    let searchText = search.lowercased() // UCCTransliteration.shared.transliterate(s: search).lowercased()
                    for model in self.data {
                        let name = model.name.lowercased() // UCCTransliteration.shared.transliterate(s: model.name).lowercased()
                        let substring = model.substring.lowercased() // UCCTransliteration.shared.transliterate(s: model.substring).lowercased()
                        
                        if name.contains(searchText) || substring.contains(searchText) {
                            result.append(model)
                        }
                    }
                }
            } else {
                result = self.data
            }
            
            Helper.performOnMainThread {
                self.filtredData = result
                self.presenter.update(data: self.filtredData)
            }
//        }
    }
}
