//
//  ReposioryUseCase.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

class RestaurantsRepository: RestaurantsRepositoryInterface {
    
    private struct Constants {
        static let favouritesKey = "favourites"
    }
    
    @Inject var networking: NetworkingDataSourceInterface
    @Inject var storage: LocalStorageDataSourceInterface
    
    private var disposables = DisposeBag()
    private var subject: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    
    init() {
        getFavouritesUuids()
            .subscribe {[weak self] favs in
                self?.subject.onNext(favs)
            }
            .disposed(by: disposables)
    }
    
    func getRestaurants() -> Single<Restaurants> {
        networking.perform(request: RestaurantsRequest())
    }
    
    func setFavourite(uuid: String) -> Completable {
        getFavouritesUuids()
            .flatMapCompletable {[weak self] uuids in
                guard let self = self else {
                    return Completable.empty()
                }
                var newUuids = Set(uuids)
                newUuids.insert(uuid)
                
                return self.storage
                    .set(value: Array(newUuids), forKey: Constants.favouritesKey)
                    .do(onCompleted:  {
                        self.subject.onNext(Array(newUuids))
                    })
            }
    }
    
    func removeFavourite(uuid: String) -> Completable {
        getFavouritesUuids()
            .flatMapCompletable {[weak self] uuids in
                guard let self = self else {
                    return Completable.empty()
                }
                var newUuids = Set(uuids)
                newUuids.remove(uuid)
                
                return self.storage
                    .set(value: Array(newUuids), forKey: Constants.favouritesKey)
                    .do(onCompleted:  {
                        self.subject.onNext(Array(newUuids))
                    })
            }
    }
    
    func favourites() -> Observable<[String]> { subject }
    
    func getFavouritesUuids() -> Single<[String]> {
        retrieveUUids()
            .map { result -> [String] in
                guard let result = result else {
                    return []
                }
                return result
            }
            .catchAndReturn([])
    }
    
    private func retrieveUUids() -> Single<[String]?> {
        storage.object(forKey: Constants.favouritesKey)
    }
}
