//
//  TheSpoonTests.swift
//  TheSpoonTests
//
//  Created by Gabriele Pavanello on 30/12/21.
//

import XCTest
@testable import TheSpoon
import Nimble
import RxNimble
import RxSwift

class LocalStorageTests: XCTestCase {
    internal let dip = Dependecies()
    internal let disposables = DisposeBag()
    internal let key: String = "TestKey"

    @Inject var dataSource: LocalStorageDataSourceInterface
    
    override func setUpWithError() throws {
        InjectSettings.resolver = self.dip.container
        dip.registerComponents()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetValue() throws {
        
        let value: [String] = ["TestKey"]
        _ = try dataSource.set(value: value, forKey: key).toBlocking().first()
        let single: Single<[String]?> = dataSource.object(forKey: key)
        
        expect(single).first.to(equal(value))
    }
    
    func testRemoveValue() throws {
                
        _ = try dataSource.removeObject(forKey: key).toBlocking().first()
        let single: Single<[String]?> = dataSource.object(forKey: key).map {
            $0 == nil ? [] : $0
        }
        
        expect(single).first.to(equal([]))
    }
}
