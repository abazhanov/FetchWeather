//
//  Weather.swift
//  FetchWeather
//
//  Created by Artem Bazhanov on 30.04.2021.
//

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}
