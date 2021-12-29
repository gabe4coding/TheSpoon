//
//  RestaurantsViewModel.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

class RestaurantsViewModel: ViewModel {
    @Inject private var useCase: RestaurantsUseCaseInterface
    
    init() {
        useCase.load()
    }
    
    func objects() -> Observable<[RestaurantModel]> {
        useCase.restaurants()
    }
    
    func sort(by type: ListOrder) {
        useCase.sort(by: type)
    }
}

class RestaurantItemViewModel: ViewModel {
    
    @Inject private var useCase: RestaurantsUseCaseInterface
    
    private let disposables: DisposeBag = DisposeBag()
    
    let data: RestaurantModel
    
    init(model: RestaurantModel) {
        self.data = model
    }
    
    func isFavourite() -> Observable<Bool> {
        useCase.isFavourite(restaurant: data)
    }
    
    func toggleFavourite() {
        isFavourite()
            .observe(on:MainScheduler.asyncInstance)
            .flatMapFirst {[weak self] isFav -> Observable<Void> in
            guard let self = self else { return Observable.empty() }
            return isFav ? self.useCase.removeFavourite(restaurant: self.data) : self.useCase.setFavourite(restaurant: self.data)
        }
        .subscribe()
        .disposed(by: disposables)
    }
    
    func setFavourite() {
        useCase.setFavourite(restaurant: data)
            .subscribe()
            .disposed(by: disposables)
    }
    
    func removeFromFavourites() {
        useCase.removeFavourite(restaurant: data)
            .subscribe()
            .disposed(by: disposables)
    }
}



