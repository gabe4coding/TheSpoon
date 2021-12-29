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
    private let error: PublishSubject<ErrorType> = PublishSubject()
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
            .subscribe(onSuccess: {[weak self] list in
                self?.elements.onNext(list)
            }, onFailure: {[weak self] error in
                self?.error.onNext(error.mapNetworkError())
            })
            .disposed(by: disposables)
    }
    
    func onError() -> Observable<ErrorType> { error }
    
    func setFavourite(restaurant: RestaurantModel) -> Completable {
        repository.setFavourite(uuid: restaurant.uuid)
    }
    
    func removeFavourite(restaurant: RestaurantModel) -> Completable {
        repository.removeFavourite(uuid: restaurant.uuid)
    }
    
    func observeFavourite(restaurant: RestaurantModel) -> Observable<Bool> {
        self.repository
            .favourites()
            .flatMap { Observable.just($0.contains(restaurant.uuid)) }
    }
    
    func isFavourite(restaurant: RestaurantModel) -> Single<Bool> {
        self.repository.getFavouritesUuids().map {
            $0.contains(restaurant.uuid)
        }
    }
    
    private func mappedElements() -> Single<[RestaurantModel]> {
        repository
            .getRestaurants()
            .mapToUIModel()
    }
}
