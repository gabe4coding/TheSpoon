//
//  RestaurantsRepositoryTest.swift
//  TheSpoonTests
//
//  Created by Gabriele Pavanello on 30/12/21.
//

import XCTest
@testable import TheSpoon
import RxBlocking
import Nimble
import RxSwift

class RestaurantsRepositoryTest: XCTestCase {
    internal let dip = Dependecies()
    
    @Inject var repository: RestaurantsRepositoryInterface
    
    internal let key: String = "TestKey"

    override func setUpWithError() throws {
        InjectSettings.resolver = self.dip.container
        dip.registerComponents()
        
    }

    func testGetRestaurants() throws {
        let result = try repository.getRestaurants()
            .map { $0.data }
            .toBlocking()
            .first()
        
        expect(result).to(haveCount(10))
    }
    
    func testGetFavourites() throws {
        _ = try repository.setFavourite(uuid: key).toBlocking().first()
        
        let result = try repository.getFavouritesUuids()
            .toBlocking()
            .first()
        
        expect(result).to(contain(key))
    }
    
    func testRemoveFavourites() throws {
        _ = try repository.setFavourite(uuid: key).toBlocking().first()
        
        let result = try repository.getFavouritesUuids()
            .toBlocking()
            .first()
        
        expect(result).to(contain(key))
        
        _ = try repository.removeFavourite(uuid: key).toBlocking().first()
        
        let removeResult = try repository.getFavouritesUuids()
            .toBlocking()
            .first()
        
        expect(removeResult).to(beEmpty())

    }
    
    func testObserveFavourites() throws {
        _ = try repository.setFavourite(uuid: key).toBlocking().first()
        
        let result = try repository.favourites()
            .toBlocking()
            .first()
        
        expect(result).to(contain(key))
    }
}
