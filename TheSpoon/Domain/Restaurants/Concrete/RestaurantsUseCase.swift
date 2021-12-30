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
    private let elements: BehaviorSubject<[Restaurant]> = BehaviorSubject(value: [])
    private let error: PublishSubject<ErrorType> = PublishSubject()
    private let disposables: DisposeBag = DisposeBag()
    
    func restaurants() -> Observable<[Restaurant]> {
        Observable.combineLatest(elements, orderType) { r, order in
            r.sorted { r1, r2 in
                switch order {
                case .name:
                    return r1.name < r2.name
                case .rating:
                    return r1.aggregateRatings.thefork.ratingValue > r2.aggregateRatings.thefork.ratingValue
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
        repository
            .getRestaurants()
            .subscribe(onSuccess: {[weak self] result in
                self?.elements.onNext(result.data)
            }, onFailure: {[weak self] error in
                self?.error.onNext(error.mapNetworkError())
            })
            .disposed(by: disposables)
    }
    
    func onError() -> Observable<ErrorType> { error }
    
    func setFavourite(id: String) -> Completable {
        repository.setFavourite(uuid: id)
    }
    
    func removeFavourite(id: String) -> Completable {
        repository.removeFavourite(uuid: id)
    }
    
    func observeFavourite(id: String) -> Observable<Bool> {
        self.repository
            .favourites()
            .flatMap { Observable.just($0.contains(id)) }
    }
    
    func isFavourite(id: String) -> Single<Bool> {
        self.repository.getFavouritesUuids().map {
            $0.contains(id)
        }
    }
}
