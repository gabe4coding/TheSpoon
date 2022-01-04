//
//  Extensions+Sequence.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 04/01/22.
//

import UIKit

extension Sequence where Element == Restaurant {
    func map<T>() -> [T]? {
        switch T.self {
        case is RestaurantModel.Type:
            return compactMap { element in
                restaurantsListModel(restaurant: element) as? T
            }
        default: return nil
        }
    }
    
    private func restaurantsListModel(restaurant: Restaurant) -> RestaurantModel {
        RestaurantModel(uuid: restaurant.uuid,
                        name: restaurant.name,
                        cuisine: restaurant.servesCuisine,
                        address: "\(restaurant.address.street), \(restaurant.address.postalCode), \(restaurant.address.locality)",
                        avgPrice: "\(restaurant.priceRange)",
                        discount: restaurant.bestOffer.label,
                        rating: "\(restaurant.aggregateRatings.thefork.ratingValue)",
                        numReviews: "\(restaurant.aggregateRatings.thefork.reviewCount)",
                        img: restaurant.mainPhoto?.the664X374)
    }
}
