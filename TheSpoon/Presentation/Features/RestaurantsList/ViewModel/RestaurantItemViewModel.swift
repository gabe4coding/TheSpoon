//
//  RestaurantItemViewModel.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

class RestaurantItemViewModel: ViewModel {
    
    @Inject private var useCase: RestaurantsUseCaseInterface
    
    private let disposables: DisposeBag = DisposeBag()
    
    let data: RestaurantModel
    
    init(model: RestaurantModel) {
        self.data = model
    }
    
    func isFavourite() -> Observable<Bool> {
        useCase.observeFavourite(id: data.uuid)
    }
    
    func toggleFavourite() {
        useCase
            .isFavourite(id: data.uuid)
            .flatMapCompletable {[weak self] isFav -> Completable in
                guard let self = self else {
                    return Observable.empty().asCompletable()
                }
                
                return isFav ? self.useCase.removeFavourite(id: self.data.uuid) : self.useCase.setFavourite(id: self.data.uuid)
            }
            .subscribe()
            .disposed(by: disposables)
    }
}
