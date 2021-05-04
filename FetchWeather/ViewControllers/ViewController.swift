//
//  ViewController.swift
//  FetchWeather
//
//  Created by Artem Bazhanov on 30.04.2021.
//

import UIKit

protocol NetworkManagerDelegate {
    func showErrorAlert(with: String, and: String)
}

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
            showAlert(with: "Вы не указали координаты", and: "Пожалуйста, укажите долготу и широту места, для которого хотите получить погоду")
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
        let result = NetworkManager.shared.fetchData(longitude: longitude, latitude: latitude) { (weather) in
            
             
            
            
            NetworkManager.shared.delegate = self
            
            //print(weather)
            //print("Температура:" + String(weather.main.temp))
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
        if result != "" {
            showAlert(with: result, and: "Упс...")
        }
    }
    
}

extension ViewController {
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

extension ViewController: NetworkManagerDelegate {
    func showErrorAlert(with: String, and: String) {
        showAlert(with: with, and: and)
    }
}
