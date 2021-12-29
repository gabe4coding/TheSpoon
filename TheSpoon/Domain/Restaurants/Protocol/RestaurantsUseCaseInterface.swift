//
//  RestaurantsUseCaseInterface.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift
import RxRelay

enum ListOrder {
    case name, rating, none
}

struct RestaurantModel {
    let uuid, name, cuisine,
        address, avgPrice, discount,
        rating, numReviews: String
    let img: String?
}

protocol RestaurantsUseCaseInterface {
    func restaurants() -> Observable<[RestaurantModel]>
    
    
    func setFavourite(restaurant: RestaurantModel) -> Observable<Void>
    func removeFavourite(restaurant: RestaurantModel) -> Observable<Void>
    func isFavourite(restaurant: RestaurantModel) -> Observable<Bool>

    func sort(by type: ListOrder)
    func load()
}


