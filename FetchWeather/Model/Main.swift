//
//  Main.swift
//  FetchWeather
//
//  Created by Artem Bazhanov on 30.04.2021.
//

struct Main: Decodable {
    let temp: Float
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Int
    let humidity: Float
}
