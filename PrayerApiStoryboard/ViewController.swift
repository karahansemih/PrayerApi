//
//  ViewController.swift
//  PrayerApiStoryboard
//
//  Created by Semih Karahan on 27.03.2023.
//

import UIKit

class ViewController: UIViewController {

    var zamanlar = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

            getPrayer()

        
    }

    func getPrayer(){
        let datez = Date()
        let sem = "\(datez)"
        let sem2 = sem.components(separatedBy: " ")
        
        let urlString = "https://namaz-vakti.vercel.app/api/timesFromCoordinates?lat=39.91987&lng=32.85427&date=\(sem2[0])&days=3&timezoneOffset=180"
        guard let url = URL(string: urlString) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, err in
                guard let data = data, err == nil else { return }
                
                do {
                    let jsonData = try JSONDecoder().decode(Datas.self, from: data)
                    let ulke = jsonData.place.country
                    let sehir = jsonData.place.city
                    let zaman = jsonData.times.keys
                    for pip in zaman{
                        self.zamanlar.append(pip)
                    }
                    //print(self.zamanlar[0])
                    let denemee = jsonData.times[self.zamanlar[0]]!
                    print(denemee)
                    /*
                    print(ulke)
                    print(sehir)
                    print(type(of: zaman))
                    */

                     
                } catch let jsonErr {
                    print("failed to decode json:", jsonErr)
                }
                
            }.resume() // don't forget
        
        

    }
    
    
}

struct Datas: Decodable {
    let place: Place
    let times: [String: [String]]
}

// MARK: - Place
struct Place: Codable {
    let countryCode, country, region, city: String
    let latitude, longitude: Double
}




