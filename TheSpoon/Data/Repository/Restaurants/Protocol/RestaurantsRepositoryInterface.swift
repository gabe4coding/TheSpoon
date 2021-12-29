//
//  RestaurantsRepositoryInterface.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

protocol RestaurantsRepositoryInterface {
    func getRestaurants() -> Observable<Restaurants>
    func setFavourite(uuid: String) -> Observable<Void>
    func removeFavourite(uuid: String) -> Observable<Void>
    func favourites() -> Observable<[String]>
}


