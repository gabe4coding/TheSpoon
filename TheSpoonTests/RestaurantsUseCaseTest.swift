//
//  RestaurantsUseCaseTest.swift
//  TheSpoonTests
//
//  Created by Gabriele Pavanello on 30/12/21.
//

import XCTest
@testable import TheSpoon
import RxBlocking
import Nimble
import RxSwift
import WebKit

class RestaurantsUseCaseTest: XCTestCase {
    
    internal let dip = Dependecies()
    
    internal let key: String = "TestKey"
    
    @Inject var useCase: RestaurantsUseCaseInterface

    override func setUpWithError() throws {
        InjectSettings.resolver = self.dip.container
        dip.registerComponents()
    }

    func testUseCaseRestaurants() throws {
        useCase.load()
        let result = try useCase.restaurants().toBlocking(timeout: 1).first()
        
        expect(result).to(haveCount(10))
    }
    
    func testSortingByName() throws {
        useCase.load()
        useCase.sort(by: .name)
        
        let result = try useCase.restaurants().map({
            $0.first?.uuid
        }).toBlocking(timeout: 1).first()

        expect(result).to(equal("4eg4e2bn-1080-4e1e-8438-6t90ht123456"))
    }
    
    func testSortingByRating() throws {
        useCase.load()
        useCase.sort(by: .rating)
        
        let result = try useCase.restaurants().map({
            $0.first?.uuid
        }).toBlocking(timeout: 1).first()

        expect(result).to(equal("4eg4e2bn-1080-4e1e-8438-6t90ht123428"))
    }

}
