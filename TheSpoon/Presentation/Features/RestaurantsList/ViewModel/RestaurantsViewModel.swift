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
        useCase
            .restaurants()
            .mapToUIModel()
            .observe(on: MainScheduler.instance)
    }
    
    func sort(by type: ListOrder) {
        useCase.sort(by: type)
    }
    
    func errorOccured() -> Observable<ErrorType> {
        useCase
            .onError()
            .observe(on: MainScheduler.instance)
    }
    
    func reload() {
        useCase.load()
    }
}



