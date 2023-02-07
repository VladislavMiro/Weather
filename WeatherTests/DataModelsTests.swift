//
//  DataModelsTests.swift
//  WeatherTests
//
//  Created by Vladislav Miroshnichenko on 07.02.2023.
//

import XCTest
@testable import Weather

class DataModelsTests: XCTestCase {
    
    private let decoder = JSONDecoder()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        decoder.keyDecodingStrategy = .convertFromSnakeCase
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
    
    //MARK: Day model tests
    
    func testCreateDayModelAndGetProperties() {
        let mockCondtion = Condition(text: "test", icon: "234", code: 123)
        let sut: DayProtocol! = Day(avgTempC: 10, avgTempF: 20,
                                   dailyWillItSnow: false, dailyChanceOfSnow: 0,
                                   dailyWillItRain: true, dailyChanceOfRain: 15,
                                   condition: mockCondtion, uv: 0)
        
        XCTAssertNotNil(sut, "Day model is nil")
        XCTAssertEqual(sut.avgTempC, 10)
        XCTAssertEqual(sut.avgTempF, 20)
        XCTAssertFalse(sut.dailyWillItSnow)
        XCTAssertEqual(sut.dailyChanceOfSnow, 0)
        XCTAssertTrue(sut.dailyWillItRain)
        XCTAssertEqual(sut.dailyChanceOfRain, 15)
        XCTAssertEqual(sut.condition.text, "test")
        XCTAssertEqual(sut.condition.icon, "234")
        XCTAssertEqual(sut.condition.code, 123)
        XCTAssertEqual(sut.uv, 0)
    }
    
    func testGetDayModelFromJson() {
        guard let mockData = openJSONFile(name: "MockDay") else { XCTFail("Problems with guard"); return }
        
        let sut = try! decoder.decode(Day.self, from: mockData)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.avgTempC, 5.9)
        XCTAssertEqual(sut.condition.code, 1000)
    }
    
    //MARK: Condition model tests
    
    func testConditionProperties() {
        let sut: ConditionProtocol = Condition(text: "Sunny", icon: "203", code: 1000)
        
        XCTAssertEqual(sut.text, "Sunny")
        XCTAssertEqual(sut.icon, "203")
        XCTAssertEqual(sut.code, 1000)
    }
    
    func testGetConditionFromJson() {
        guard let mockData = openJSONFile(name: "MockCondition") else { XCTFail("Problems with guard"); return }
        
        let sut = try! decoder.decode(Condition.self, from: mockData)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.icon.count, 3)
        XCTAssertNotNil(Int(sut.icon))
    }
    
    //MARK: Weather data model tests
    
    func testCurrentWeatherProperties() {
        let mockCondtion = Condition(text: "test", icon: "234", code: 123)
        let sut: WeatherDataProtocol! = WeatherData(tempC: 1.0,
                                                          tempF: 50.0,
                                                          condition: mockCondtion,
                                                          feelslikeC: 1.2,
                                                          feelslikeF: 50.2,
                                                          isDay: true,
                                                          humidity: 20,
                                                          cloud: 10,
                                                          windKph: 5.0,
                                                          windMph: 10.0,
                                                          uv: 0.0)
        XCTAssertNotNil(sut, "Current weather model is nil")
        XCTAssertEqual(sut.tempC, 1.0)
        XCTAssertEqual(sut.tempF, 50.0)
        XCTAssertEqual(sut.condition.text, "test")
        XCTAssertEqual(sut.condition.icon, "234")
        XCTAssertEqual(sut.condition.code, 123)
        XCTAssertEqual(sut.feelslikeC, 1.2)
        XCTAssertEqual(sut.feelslikeF, 50.2)
        XCTAssertTrue(sut.isDay)
        XCTAssertEqual(sut.humidity, 20)
        XCTAssertEqual(sut.cloud, 10)
        XCTAssertEqual(sut.windKph, 5.0)
        XCTAssertEqual(sut.windMph, 10.0)
        XCTAssertEqual(sut.uv, 0.0)
    }
    
    func testGetCurrentWeatherFromJSON() {
        guard let mockData = openJSONFile(name: "MockCurrentWeather") else { XCTFail("Problems with guard"); return }
        
        let sut = try! decoder.decode(WeatherData.self, from: mockData)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.tempC, 1.0)
    }
    
    //MARK: Forecast model tests
    
    func testGetForecastModelFromJson() {
        guard let mockData = openJSONFile(name: "MockForecast") else { XCTFail("Problems with guard"); return }
        
        let sut = try! decoder.decode(Forecast.self, from: mockData)
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.date, "2023-02-07")
        XCTAssertEqual(sut.day.avgTempC, 5.9)
        XCTAssertFalse(sut.hour.isEmpty)
        XCTAssertEqual(sut.hour.count, 2)
        XCTAssertEqual(sut.hour.first!.tempC,  4.3)
    }
    
    //MARK: Location model tests
    
    func testLocationProprties() {
        let sut = Location(id: 123,
                       name: "London",
                       region: "City of London, Greater London",
                       country: "United Kingdom",
                       latitude: 51.52,
                       longitude: -0.11)
        let sut1: LocationProtocol = Location(name: "Hackney",
                        region: "Hackney, Greater London",
                        country: "United Kingdom",
                        latitude: 51.54,
                        longitude: -0.06)
        
        XCTAssertEqual(sut.id, 123)
        XCTAssertEqual(sut.name, "London")
        XCTAssertEqual(sut.region, "City of London, Greater London")
        XCTAssertEqual(sut.country, "United Kingdom")
        XCTAssertEqual(sut.lat, 51.52)
        XCTAssertEqual(sut.lon, -0.11)
        
        XCTAssertEqual(sut1.id, 0)
    }
    
    func testCreateLocationFromJSONFile() {
        guard let mockLocations = openJSONFile(name: "MockLocations") else { XCTFail("Problems with guard"); return }
        var locations: [LocationProtocol]?
        
        locations = try! decoder.decode([Location].self, from: mockLocations)
        
        XCTAssertNotNil(locations, "Locations is nil")
        XCTAssertNotEqual(locations?.count, 0, "Locations is empty")
        
        locations?.forEach({ location in
            XCTAssertNotEqual(location.id, 0)
        })

    }
    
    //MARK: Weather model tests
    
    func testGetWeatgerFromJSON() {
        guard let mockData = openJSONFile(name: "MockWeather") else { XCTFail("mockData is nil"); return }
        var sut: WeatherProtocol!
        
        sut = try! decoder.decode(Weather.self, from: mockData)
        
        XCTAssertNotNil(sut, "Sut is nil")
        XCTAssertEqual(sut.location.name, "London")
        XCTAssertEqual(sut.location.id, 0)
        XCTAssertEqual(sut.current.tempC, 1.0)
        XCTAssertFalse(sut.forecast.isEmpty)
    }

}
