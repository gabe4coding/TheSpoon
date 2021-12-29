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
        useCase.observeFavourite(restaurant: data)
    }
    
    func toggleFavourite() {
        useCase
            .isFavourite(restaurant: data)
            .flatMapCompletable {[weak self] isFav -> Completable in
                guard let self = self else {
                    return Observable.empty().asCompletable()
                }
                
                return isFav ? self.useCase.removeFavourite(restaurant: self.data) : self.useCase.setFavourite(restaurant: self.data)
            }
            .subscribe()
            .disposed(by: disposables)
    }
}
