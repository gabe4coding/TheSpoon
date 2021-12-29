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
    
    private var disposables = DisposeBag()
    private var subject: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    
    init() {
        getFavouritesUuids().subscribe {
            self.subject.onNext($0)
        }.disposed(by: disposables)
    }
    
    func getRestaurants() -> Observable<Restaurants> {
        networking.perform(request: RestaurantsRequest())
    }
    
    func setFavourite(uuid: String) -> Observable<Void> {
        getFavouritesUuids().flatMapFirst { uuids -> Observable<Void> in
            var newUuids = Set(uuids)
            newUuids.insert(uuid)
            
            self.subject.onNext(Array(newUuids))
            
            let storage = UserDefaults.standard
            storage.set(Array(newUuids), forKey: Constants.favouritesKey)
            storage.synchronize()
            
            return Observable.just(())
        }
    }
    
    func removeFavourite(uuid: String) -> Observable<Void> {
        getFavouritesUuids().flatMapFirst { uuids -> Observable<Void> in
            var newUuids = Set(uuids)
            newUuids.remove(uuid)
            
            self.subject.onNext(Array(newUuids))
            
            let storage = UserDefaults.standard
            storage.set(Array(newUuids), forKey: Constants.favouritesKey)
            storage.synchronize()
            
            return Observable.just(())
        }
    }
    
    func favourites() -> Observable<[String]> {
        subject
    }
    
    private func getFavouritesUuids() -> Observable<[String]> {
        return Observable.create { single in
                let storage = UserDefaults.standard
                let storedData = storage.object(forKey: "favourites") as? [String] ?? []
                single.onNext(storedData)

                return Disposables.create()
        }
    }
}
