//
//  NetworkManager.swift
//  FetchWeather
//
//  Created by Artem Bazhanov on 30.04.2021.
//

import UIKit
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var delegate: NetworkManagerDelegate?
    
    private init() {}
    
    func fetchData(longitude: Double, latitude:Double, completion: @escaping(CurrentWeather)->()) -> String {
        var errorData = ""
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=a6c40d5ab6bb6b87ea73272d831fe569&units=metric&lang=ru"
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
    
    func fetchDataWithAF(longitude: Double, latitude:Double,completion: @escaping(CurrentWeather)->()) -> String {
        var errorData = ""
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=a6c40d5ab6bb6b87ea73272d831fe569&units=metric&lang=ru"
        AF.request(urlString)
            .validate()
            .responseJSON { (dataResponce) in
            
            switch dataResponce.result {
            case .success(let value):
                guard let currentWeatherData = value as? [String : Any] else { return }
                
                let weatherData = currentWeatherData["weather"] as? [Dictionary<String, Any>]
                var weather = [Weather]()
                weather.append(Weather(
                    main: weatherData?[0]["main"] as? String ?? "",
                    description: weatherData?[0]["description"] as? String ?? "",
                    icon: weatherData?[0]["icon"] as? String ?? ""
                ))
                
                let mainData = currentWeatherData["main"] as? [String : Any]
                let main = Main(
                    temp: mainData?["temp"] as? Float ?? 0,
                    feels_like: mainData?["feels_like"] as? Float ?? 0,
                    temp_min: mainData?["temp_min"] as? Float ?? 0,
                    temp_max: mainData?["temp_max"] as? Float ?? 0,
                    pressure: mainData?["pressure"] as? Int ?? 0,
                    humidity: mainData?["humidity"] as? Float ?? 0
                )
                
                let currentWeather = CurrentWeather(
                    weather: weather,
                    main: main,
                    name: currentWeatherData["name"] as? String ?? ""
                )
                completion(currentWeather)
              
            case .failure(let error):
                print("Error: ", error)
                errorData = error.localizedDescription
            }
        }
        return errorData
    }
}
