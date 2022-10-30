//
//  ServerProductTest.swift
//  ProductsDemoTests
//
//  Created by Kris Lin on 2022/10/30.
//

import XCTest
@testable import ProductsDemo

final class ServerProductTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetch() async throws {
        let results = try await ProductsResponse.fetch(start: 20, limit: 20)
        print(results)
        XCTAssert(results.count == 20)
        XCTAssert(results.first?.id == 21)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
