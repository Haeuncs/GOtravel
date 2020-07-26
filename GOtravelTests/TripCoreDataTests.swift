//
//  TripCoreDataTests.swift
//  GOtravelTests
//
//  Created by LEE HAEUN on 2020/07/25.
//  Copyright © 2020 haeun. All rights reserved.
//

import XCTest
import CoreData
@testable import GOtravel

// 🔥 NOTICE
// if you want to run this test code then change TripCoreDataManager's performBackgroundTask to performBackgroundTaskAndWait
// 🔥

class TripCoreDataTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        TripCoreDataManager.shared.reset()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_reset() {
        TripCoreDataManager.shared.reset()
    }

    func test_add_trip() {
        XCTAssertEqual(TripCoreDataManager.shared.fetchAllTrip()?.count, 0)

        let data = Trip(
            city: "대한민국",
            country: "대한민국",
            date: Date(),
            period: 3,
            coordinate: Coordinate(latitude: 10, longitude: 10),
            payByDays: [PayByDays(
                day: 0,
                pays: [Pay(krWon: 100, name: "")])],
            planByDays: [PlanByDays(day: 0, plans: [Plan(address: "", title: "", coordinate: Coordinate(latitude: 10, longitude: 10))])]
        )
        TripCoreDataManager.shared.add(newData: data)

        XCTAssertEqual(TripCoreDataManager.shared.fetchAllTrip()?.count, 1)

        let fetchTripByIdentifier = TripCoreDataManager.shared.fetchTrip(identifier: data.identifier)
        
        XCTAssertEqual(fetchTripByIdentifier?.country, data.country)

//        return data.identifier
    }

//    func test_delete_trip() {
//        let uuid = test_add_trip()
//        XCTAssertEqual(TripCoreDataManager.shared.fetchAllTrip()?.count, 1)
//        XCTAssertTrue(TripCoreDataManager.shared.deleteTrip(identifier: uuid))
//        XCTAssertEqual(TripCoreDataManager.shared.fetchAllTrip()?.count, 0)
//    }

//    func test_update_trip() {
//        var data = Trip(city: "대한민국", country: "대한민국", date: Date(), period: 3, coordinate: Coordinate(latitude: 10, longitude: 10), payByDays: [], planByDays: [])
//        TripCoreDataManager.shared.add(newData: data)
//
//        data.city = "용인"
//        data.country = "한국"
//        data.payByDays = [Pay(krWon: 10000, name: "name")]
//
//        _ = TripCoreDataManager.shared.updateTrip(updateTrip: data)
//
//        guard let trip = TripCoreDataManager.shared.fetchTrip(identifier: data.identifier) else {
//            return
//        }
//
//        XCTAssertEqual(trip.city, data.city)
//        XCTAssertEqual(trip.country, data.country)
//        XCTAssertEqual(trip.payByDays?.count, 1)
//
//    }
}
