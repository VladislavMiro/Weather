//
//  HeaderView.swift
//  Weather
//
//  Created by Vladislav Miroshnichenko on 10.02.2023.
//

import SwiftUI

struct HeaderView: View {
    private var location: LocationProtocol
    private var weather: WeatherDataProtocol
    @State private var isMetricSystem: Bool = true
    
    var body: some View {
        VStack(alignment: .center, spacing: 1) {
            VStack {
                Text(location.name)
                    .font(.largeTitle)
                    .fontWeight(.light)
                Text("\(location.region), \(location.country)")
                    .font(.subheadline)
                    .fontWeight(.light)
            }
            HStack(alignment: .top, spacing: 2) {
                Image((weather.isDay ? "Day" : "Night") + weather.condition.icon)
                    .resizable()
                    .frame(width: 96.0, height: 96)
                    .scaledToFit()
                Spacer()
                VStack(alignment: .leading,spacing: 2) {
                    Text(weather.condition.text)
                        .fontWeight(.light)
                        .font(.title)
                    Text(isMetricSystem ?
                        "\(Int(weather.tempC)) °C" :
                        "\(Int(weather.tempC)) F"
                    ).fontWeight(.light).font(.largeTitle)
                    Text("Feels like: " + (isMetricSystem ?
                            "\(Int(weather.feelslikeC)) °C" :
                            "\(Int(weather.feelslikeF)) F"
                    )).fontWeight(.light).font(.caption)
                }.padding(.trailing, 15)
                
            }.padding()
            .frame(maxWidth: .infinity)
        }
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .foregroundColor(.white)
        
    }
    
    init(isMetricSystem: Bool, location: LocationProtocol, weather: WeatherDataProtocol) {
        self.location = location
        self.weather = weather
        self.isMetricSystem = isMetricSystem
    }
}

struct HeaderView_Previews: PreviewProvider {
    private static let mockLocation = Location(name: "London",
                                        region: "London city",
                                        country: "United Kingdom",
                                        latitude: 10, longitude: 12)
    private static let mockWeather = WeatherData(tempC: 15,
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
    static var previews: some View {
        HeaderView(isMetricSystem: false, location: mockLocation, weather: mockWeather)
            
    }
}
