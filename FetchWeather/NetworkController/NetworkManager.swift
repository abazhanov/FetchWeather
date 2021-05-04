//
//  NetworkManager.swift
//  FetchWeather
//
//  Created by Artem Bazhanov on 30.04.2021.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var delegate: NetworkManagerDelegate?
    
    private init() {}
    
    func fetchData(longitude: Double, latitude:Double, completion: @escaping(CurrentWeather)->()) -> String {
        var errorData = ""
        
        let urlString = "https://api1.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=a6c40d5ab6bb6b87ea73272d831fe569&units=metric&lang=ru"
        guard let url=URL(string: urlString) else {
            errorData = "URL is wrong"
            delegate?.showErrorAlert(with: "Ошибка!", and: errorData)
            return errorData
        }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data else {
                print("Create data error: ", error?.localizedDescription ?? "No error description")
                errorData = error?.localizedDescription ?? "Что-то не то"
                self.delegate?.showErrorAlert(with: "Ошибка!", and: errorData)
                print("aaaa")
                return
            }
            do {
                let currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                completion(currentWeather)
            } catch let error {
                print("Decode error: ",error.localizedDescription)
                errorData = error.localizedDescription
            }
        }.resume()
        return errorData
    }
    
    func fetchIconWeather(partURL: String, completion: @escaping(UIImage)->()) {
        
        guard let url = URL(string: "http://openweathermap.org/img/wn/\(partURL)@2x.png") else {return}
        print("URL = \(url)")
        let session = URLSession.shared
    
        session.dataTask(with: url) { (data, response, error) in
            if let date = data, let image = UIImage(data: date) {
                completion(image)
            }
        }.resume()
    }
    
    func fetchDataWithAF(longitude: Double, latitude:Double) {
        
    }
}
