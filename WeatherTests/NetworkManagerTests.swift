//
//  NetworkManagerTests.swift
//  WeatherTests
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import XCTest
import Combine
@testable import Weather

class NetworkManagerTests: XCTestCase {
    
    private let apiKey = "47d04ec1994d4cfc9ef134954230602"
    private var sut: NetworkManagerProtocol!
    private var cancellable = Set<AnyCancellable>()

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = NetworkManager(apiKey: apiKey)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }
    
    private func openJSONFile(name: String) -> Data? {
        if let path = Bundle(for: type(of: self)).path(forResource: name, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return data
            } catch let error as NSError {
                XCTFail("Open file error: \(error.localizedDescription)")
                return nil
            }
        } else {
            XCTFail("JSON file not found")
            return nil
        }
    }
    
    func testAPINetworkErrorProperties() {
        let sut: APINetworkError! = APINetworkError(code: 404, message: "Page not found")
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.code, 404)
        XCTAssertEqual(sut.message, "Page not found")
        XCTAssertEqual(sut.description, "Error \(sut.code): " + sut.message)
    }
    
    func testAPINetworkErrorDecodeFromJSON() {
        guard let data = openJSONFile(name: "MockErrorResponse") else { XCTFail("File is not found"); return }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let sut = try! decoder.decode(APINetworkError.self, from: data)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.code, 2008)
        XCTAssertEqual(sut.message, "API key has been disabled.")
        XCTAssertEqual(sut.description, "Error \(sut.code): " + sut.message)
    }

    func testMakeRequestAndGetWeatherInResponse() throws {
        let expectation = self.expectation(description: "Network.WeatherResponse")
        
        let _ = sut.getWeather(latitude: 51.52, longitude: -0.11).sink { error in
            XCTFail("Response error: \(error)")
        } receiveValue: { weather in
            XCTAssertEqual(weather.location.name, "London")
            XCTAssertFalse(weather.forecast.isEmpty)
            
            expectation.fulfill()
        }.store(in: &cancellable)

        waitForExpectations(timeout: 20)

    }
    
    func testMakeRequestToGetLocationInResponse() {
        let expectation = self.expectation(description: "Network.LocationResponse")
        
        let _ = sut.getLocation(locationName: "London").sink { error in
            XCTFail("Response error: \(error)")
        } receiveValue: { location in
            XCTAssertFalse(location.isEmpty)
            XCTAssertEqual(location.first!.name, "London")
            XCTAssertNotEqual(location.first!.id, 0)
            
            expectation.fulfill()
        }.store(in: &cancellable)

        waitForExpectations(timeout: 10)
    }
    
    func testMakeRequesGetErrorResponse() {
        let expectation = self.expectation(description: "Network.ErrorResponse")
        
        sut = NetworkManager(apiKey: "12345fdverhr4322")
        
        let _ = sut.getLocation(locationName: "London").sink { error in
            print(error)
            XCTAssert(true)
            expectation.fulfill()
        } receiveValue: { _ in
            XCTFail("Request is sucsessful")
        }.store(in: &cancellable)

        waitForExpectations(timeout: 15)
    }

}
