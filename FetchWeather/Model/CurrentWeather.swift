//
//  CurrentWeather.swift
//  FetchWeather
//
//  Created by Artem Bazhanov on 30.04.2021.
//


struct CurrentWeather: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
}

