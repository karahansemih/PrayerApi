//
//  ViewController.swift
//  PrayerApiStoryboard
//
//  Created by Semih Karahan on 27.03.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private var locationManager:CLLocationManager!
    var lat = String()
    var lng = String()
    var zamanlar = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        getPrayer()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            self.lat = "\(location.coordinate.latitude)"
            self.lng = "\(location.coordinate.longitude)"
            print(self.lat)
            print(self.lng)
        }
        
    }

    func getPrayer(){
        let datez = Date()
        let sem = "\(datez)"
        let sem2 = sem.components(separatedBy: " ")
        
        let urlString = "https://namaz-vakti.vercel.app/api/timesFromCoordinates?lat=\(self.lat)&lng=\(self.lng)&date=\(sem2[0])&days=3&timezoneOffset=180"
        guard let url = URL(string: urlString) else { return }
            URLSession.shared.dataTask(with: url) { data, response, err in
                guard let data = data, err == nil else { return }
                do {
                    let jsonData = try JSONDecoder().decode(Datas.self, from: data)
                    let ulke = jsonData.place.country
                    let ilce = jsonData.place.city
                    let il = jsonData.place.region
                    let zaman = jsonData.times.keys
                    for pip in zaman{
                        self.zamanlar.append(pip)
                    }
                    let denemee = jsonData.times[self.zamanlar[0]]!
                    print(ulke)
                    print(il)
                    print(ilce)
                    print(denemee)
                    
                } catch let jsonErr {
                    print("failed to decode json:", jsonErr)
                }
            }.resume()
    }
}


struct Datas: Decodable {
    let place: Place
    let times: [String: [String]]
}

struct Place: Codable {
    let countryCode, country, region, city: String
    let latitude, longitude: Double
}




