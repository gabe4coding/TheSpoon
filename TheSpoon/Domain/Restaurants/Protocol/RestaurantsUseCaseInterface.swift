//
//  RestaurantsUseCaseInterface.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift
import RxRelay

enum ErrorType: Error {
    case offline
    case timeout
    case generic
}

enum ListOrder {
    case name, rating, none
}

///The model which represents the Restaurant.
struct RestaurantModel {
    let uuid, name, cuisine, address,
        avgPrice, discount, rating, numReviews: String
    let img: String?
}

///It's responsible of the retrieve of the restaurants, sorting options and favourites.
protocol RestaurantsUseCaseInterface {
    
    ///Provides the list of restaurants loaded from the Cloud.
    ///- Returns An observable for the restaurants. It is useful to observe for changes in the list (e.g. sorting changes)
    func restaurants() -> Observable<[RestaurantModel]>
    
    ///Sets the specified restaurant as a favourite
    ///- Parameter restaurant The specified restuarant to be added in favourites.
    ///- Returns A Completable which completes after setting.
    func setFavourite(restaurant: RestaurantModel) -> Completable
    
    ///Removes the specified restaurant as a favourite
    ///- Parameter restaurant The specified restuarant to be removed from favourites.
    ///- Returns A Completable which completes after removing.
    func removeFavourite(restaurant: RestaurantModel) -> Completable
    
    ///Observes for changes about the  favourite status of specific restaurant.
    ///- Parameter restaurant The specified restuarant to be checked in favourites.
    ///- Returns An observable which returns the result.
    func observeFavourite(restaurant: RestaurantModel) -> Observable<Bool>
    
    ///Retrieves the latest status for the specified restaurant, then completes.
    ///- Parameter restaurant The specified restuarant to be checked in favourites.
    ///- Returns A Single which returns the result.
    func isFavourite(restaurant: RestaurantModel) -> Single<Bool>

    ///Executes a soring on the list (observed through **restaurants()**), based on a specified type.
    ///- Parameter type The sorting type to be applied on the restaurants list.
    func sort(by type: ListOrder)
    
    ///Fetches an update of the list of restaurants.
    func load()
    
    ///Informs the observers on the ocurence of an error fetching the data.
    func onError() -> Observable<ErrorType>
}


