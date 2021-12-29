//
//  RestaurantsRepositoryInterface.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

protocol RestaurantsRepositoryInterface {
    func getRestaurants() -> Single<Restaurants>
    func setFavourite(uuid: String) -> Completable
    func removeFavourite(uuid: String) -> Completable
    func favourites() -> Observable<[String]>
    func getFavouritesUuids() -> Single<[String]>
}


