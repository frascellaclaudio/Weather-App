//
//  Weather.swift
//  Weather App
//
//  Created by Frascella Decano on 21/9/17.
//  Copyright © 2017 Frascella Claudio. All rights reserved.
//

import Foundation

struct Weather {
    let city: String?
    let country: String?
    let description: String
    let icon: String?
    let temperature: Double?
    let tempMin: Double?
    let tempMax: Double?
    let humidity: Double?
    let windSpeed: Double?
    let pressure: Double?
    
    // error protocol
    enum SerializationError:Error {
        case missing(String)
        //data is not correct
        case invalid(String)
    }
    
    init(json: [String: Any] ) throws {
        if let message = json["message"] as? String {
            throw SerializationError.invalid(message)
        }
        
        guard let weather = json["weather"] as? [[String:Any]], let description = weather[0]["description"] as? String else {
            throw SerializationError.missing("description is missing")
        }
        
        let sys = json["sys"] as? [String:Any] ?? nil
        let main = json["main"] as? [String:Any] ?? nil
        let wind = json["wind"] as? [String:Any] ?? nil

        self.description = description
        self.city = json["name"] as? String
        self.country = sys?["country"] as? String
        self.temperature = main?["temp"] as? Double
        self.icon = weather[0]["icon"] as? String
        self.tempMin = main?["temp_min"] as? Double
        self.tempMax = main?["temp_max"] as? Double
        self.humidity = main?["humidity"] as? Double
        self.windSpeed = wind?["speed"] as? Double
        self.pressure = main?["pressure"] as? Double
    }
    
    
    static func currentConditionInCity(name: String, completion: @escaping (Weather?, String?) -> ())  {
        let apiKey = "da1b32ee0e40eb229df52775b318ab69"
        let cityName = name
        
        var jsonUrlString = "http://api.openweathermap.org/data/2.5/weather?q=" + cityName + "&appid=" + apiKey + "&units=metric"
        jsonUrlString = jsonUrlString.replacingOccurrences(of: " ", with:  "")
        
        guard let url = URL(string: jsonUrlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            var weather: Weather?
            
            guard let data = data else {
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                    return
                }

                do {
                    weather = try Weather(json: json)
                    completion(weather!, nil)
                } catch let jsonError{
                    completion(nil, "Error serializing JSON \(jsonError)")
                }
                
            } catch let jsonError{
                completion(nil, "Error serializing JSON \(jsonError)")
            }
            
        }.resume()
    }
}
