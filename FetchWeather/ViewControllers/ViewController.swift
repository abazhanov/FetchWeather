//
//  ViewController.swift
//  FetchWeather
//
//  Created by Artem Bazhanov on 30.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherView: UIView!
    
    @IBOutlet weak var latitudeLabel: UITextField!
    @IBOutlet weak var longitudeLabel: UITextField!
    
    @IBOutlet weak var iconWeatherImageView: UIImageView!
    
    var currentWeather: CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherView.layer.cornerRadius = 10
        iconWeatherImageView.layer.cornerRadius = 10
        
        weatherLabel.textAlignment = .center
        weatherLabel.text = "Для получения погоды введите координаты и нажмите кнопку \"Получить погоду\"."
        
    }
    
    @IBAction func getWeatherPressed() {
        if latitudeLabel.text != "" && longitudeLabel.text != "" {
            guard let lon = Double(longitudeLabel.text ?? "44.005986") else { return }
            guard let lat = Double(latitudeLabel.text ?? "56.326887") else {return }
            
            getWeather(longitude: lon, latitude: lat)
 
        } else {
            print("Нет данных в textfield")
        }
    }
    
    @IBAction func getCityCoordinatePressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case "Нижний Новгород":
            latitudeLabel.text = "56.326887"
            longitudeLabel.text = "44.005986"
        default:
            latitudeLabel.text = "54.735069"
            longitudeLabel.text = "55.958658"
        }
    }
    
    private func getWeather(longitude: Double, latitude:Double) {
        NetworkManager.shared.fetchData(longitude: longitude, latitude: latitude) { (weather) in
            print(weather)
            print("Температура:" + String(weather.main.temp))
            self.currentWeather = weather
            NetworkManager.shared.fetchIconWeather(partURL: weather.weather[0].icon) { (image) in
                DispatchQueue.main.async {
                    self.iconWeatherImageView.image = image
                }
            }
            DispatchQueue.main.async {
                self.weatherLabel.textAlignment = .left
                self.weatherLabel.text =
                    """
                    Ваш город: \(String(weather.name))

                    За окном \(String(weather.weather[0].description))

                    Температура: \(String(Int(weather.main.temp))) ºC
                    """
            }
        }
        
     
    }
    
}

