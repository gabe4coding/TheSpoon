//
//  Extensions+ObservableType.swift
//  TheSpoon
//
//  Created by Gabriele Pavanello on 28/12/21.
//

import Foundation
import RxSwift

extension ObservableType where Element == [Restaurant] {
    func mapToUIModel() -> Observable<[RestaurantModel]> {
        map { restaurants in
            restaurants.map { restuarant in
                RestaurantModel(uuid: restuarant.uuid,
                                name: restuarant.name,
                                cuisine: restuarant.servesCuisine,
                                address: "\(restuarant.address.street), \(restuarant.address.postalCode), \(restuarant.address.locality)",
                                avgPrice: "\(restuarant.priceRange)",
                                discount: restuarant.bestOffer.label,
                                rating: "\(restuarant.aggregateRatings.thefork.ratingValue)",
                                numReviews: "\(restuarant.aggregateRatings.thefork.reviewCount)",
                                img: restuarant.mainPhoto?.the664X374)
            }
        }
    }
}

extension ObservableType where Element == RequestAPI {
    
    func buildRequest() -> Observable<URLRequest> {
        flatMap { request -> Observable<URLRequest> in
            let urlBasePath: String = request.fullPath

            var components = URLComponents(string: urlBasePath)
            let pathParameters: [String: String] = request.queryParameters
            if !pathParameters.isEmpty {
                components?.queryItems = pathParameters.map { element in URLQueryItem(name: element.key, value: element.value) }
            }

            guard let url = components?.url else {
                return Observable<URLRequest>.error(APIError.invalidUrl)
            }

            var requestURL = URLRequest(url: url)
            requestURL.httpMethod = request.method.rawValue

            var headers: [String: String] = [:]

            if let jsonModel = request.bodyParameters,
               let jsonData = try? JSONSerialization.data(withJSONObject: jsonModel) {
                requestURL.httpBody = jsonData
                headers["Content-Type"] = "application/json"
            }
            
            headers.merge(request.customHeaders, uniquingKeysWith: { _, new in new })
            requestURL.allHTTPHeaderFields = headers
            requestURL.cachePolicy = .reloadIgnoringCacheData
            
            return Observable<URLRequest>.just(requestURL)
        }
    }
}

