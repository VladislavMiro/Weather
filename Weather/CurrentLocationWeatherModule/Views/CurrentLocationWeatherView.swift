//
//  CurrentLocationWeatherView.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 10.02.2023.
//

import SwiftUI
private let mockLocation = Location(name: "London",
                                    region: "London city",
                                    country: "United Kingdom",
                                    latitude: 10, longitude: 12)
private let mockWeather = WeatherData(tempC: 15,
                                      tempF: 25,
                                      condition: Condition(text: "Sunny",
                                                           icon: "113",
                                                           code: 1000),
                                      feelslikeC: 17,
                                      feelslikeF: 27,
                                      isDay: true,
                                      humidity: 0,
                                      cloud: 0,
                                      windKph: 0,
                                      windMph: 0,
                                      uv: 0)

private var mockWeathers = [mockWeather,mockWeather,mockWeather,mockWeather,mockWeather,mockWeather,mockWeather]

struct CurrentLocationWeatherView: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 15),
                                count: 2)

    var body: some View {
        
        VStack(spacing: 2) {
            HeaderView(isMetricSystem: true, location: mockLocation, weather: mockWeather)
            List {
                
                Section(header: Text("Today").fontWeight(.light).font(.title3).background(Color.clear)) {
                    LazyVGrid(columns: columns, spacing: 15, content: {
                        cell(name: "Humidity", data: "\(mockWeather.humidity) %", image: Image(systemName: "drop"))
                        cell(name: "Cloud",data: "\(mockWeather.cloud)", image: Image(systemName: "cloud"))
                        cell(name: "UV",data: "\(Int(mockWeather.uv))", image: Image(systemName:"sun.max"))
                        cell(name: "Wind",data: "\(Int(mockWeather.windKph))", image: Image(systemName: "wind"))
                    })
                }
                Section(header: Text("On Week").fontWeight(.light).font(.title3)) {
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        LazyHStack {
                            ForEach(0..<7) {_ in 
                                cell(name: mockWeather.condition.text, data: String(mockWeather.tempC), image: Image("Day\(mockWeather.condition.icon)"))
                            }
                        }
                    })
                }
                Section(header: Text("Forecast").fontWeight(.light).font(.title3)) {
                    LazyVGrid(columns: columns, spacing: 15, content: {
                        cell(name: "Humidity", data: "\(mockWeather.humidity) %", image: Image(systemName: "drop"))
                        cell(name: "Cloud",data: "\(mockWeather.cloud)", image: Image(systemName: "cloud"))
                        cell(name: "UV",data: "\(Int(mockWeather.uv))", image: Image(systemName:"sun.max"))
                        cell(name: "Wind",data: "\(Int(mockWeather.windKph))", image: Image(systemName: "wind"))
                    })
                }
            }
        }
        
    }
    
    private func cell(name: String, data: String, image: Image) -> some View {
        HStack(spacing: 20) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
            VStack {
                Text(data)
                    .fontWeight(.light)
                Text(name.capitalized)
                    .fontWeight(.light)
                    .font(.caption)
            }
        }
        .frame(width: 100, height: 50)
        .foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(15.0)
    }
}

struct CurrentLocationWeatherView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            CurrentLocationWeatherView()
        }
    }
}
