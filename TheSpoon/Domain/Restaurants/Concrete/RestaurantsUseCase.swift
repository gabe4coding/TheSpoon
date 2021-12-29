//
//  RestaurantsUseCase.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

class RestaurantsUseCase: RestaurantsUseCaseInterface {
    
    @Inject private var repository: RestaurantsRepositoryInterface
    
    private let orderType: BehaviorSubject<ListOrder> = BehaviorSubject(value: .none)
    private let elements: BehaviorSubject<[RestaurantModel]> = BehaviorSubject(value: [])
    private let favourites: ReplaySubject<Void> = ReplaySubject<Void>.createUnbounded()
    private let disposables: DisposeBag = DisposeBag()
    
    func restaurants() -> Observable<[RestaurantModel]> {
        Observable.combineLatest(elements, orderType) { r, order in
            r.sorted { r1, r2 in
                switch order {
                case .name:
                    return r1.name < r2.name
                case .rating:
                    return r1.rating > r2.rating
                case .none:
                    return r1.uuid < r2.uuid
                }
            }
        }
    }
    
    func sort(by type: ListOrder) {
        orderType.onNext(type)
    }
    
    func load() {
        mappedElements()
            .subscribe(onNext: {[weak self] list in
                self?.elements.onNext(list)
            },onError: { _ in })
            .disposed(by: disposables)
    }
    
    private func mappedElements() -> Observable<[RestaurantModel]> {
        repository.getRestaurants().mapToUIModel()
    }
    
    func setFavourite(restaurant: RestaurantModel) -> Observable<Void> {
        repository.setFavourite(uuid: restaurant.uuid)
    }
    
    func removeFavourite(restaurant: RestaurantModel) -> Observable<Void> {
        repository.removeFavourite(uuid: restaurant.uuid)
    }
    
    func isFavourite(restaurant: RestaurantModel) -> Observable<Bool> {
        self.repository.favourites().flatMap {
            Observable.just($0.contains(restaurant.uuid))
        }
    }
}
