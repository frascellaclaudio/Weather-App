//
//  Weather.swift
//  Weather App
//
//  Created by Frascella Decano on 21/9/17.
//  Copyright © 2017 Frascella Claudio. All rights reserved.
//

import Foundation

struct Weather: Decodable {
//Swift 3 struct Weather {
    let city: String?
    let country: String?
    let description: String?
    let icon: String?
    let temperature: Double?
    let tempMin: Double?
    let tempMax: Double?
    let humidity: Double?
    let windSpeed: Double?
    let pressure: Double?
    
    private enum CodingKeys : String, CodingKey {
        case weather, main, wind, sys, name, message
        
        enum Weather: String, CodingKey {
            case description, icon
        }
        
        enum Main : String, CodingKey {
            case temp, pressure, humidity, tempMin = "temp_min", tempMax = "temp_max"
        }
        
        enum Wind : String, CodingKey {
            case speed
        }
        
        enum Sys : String , CodingKey {
            case country
        }

    }
    // error protocol
    enum SerializationError:Error {
        case missing(String)
        //data is not correct
        case invalid(String)
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var message : String? = nil
        message = try? container.decode(String.self, forKey: .message)
        if message != nil {
                throw SerializationError.invalid(message!)
        }
        
        //get weather array and its first element
        guard var weatherContainer = try? container.nestedUnkeyedContainer(forKey: .weather),
            let firstWeatherContainer = try? weatherContainer.nestedContainer(keyedBy: CodingKeys.Weather.self)
            else { throw SerializationError.missing("description is missing") }

        let sysContainer = try container.nestedContainer(keyedBy: CodingKeys.Sys.self, forKey: .sys)
        let mainContainer = try container.nestedContainer(keyedBy: CodingKeys.Main.self, forKey: .main)
        let windContainer = try container.nestedContainer(keyedBy: CodingKeys.Wind.self, forKey: .wind)
        
        self.description = try? firstWeatherContainer.decode(String.self, forKey: .description)
        self.city = try? container.decode(String.self, forKey: .name)
        self.country = try? sysContainer.decode(String.self, forKey: .country)
        self.temperature = try? mainContainer.decode(Double.self, forKey: .temp)
        self.icon = try? firstWeatherContainer.decode(String.self, forKey: .icon)
        self.tempMin = try? mainContainer.decode(Double.self, forKey: .tempMin)
        self.tempMax = try? mainContainer.decode(Double.self, forKey: .tempMax)
        self.humidity = try? mainContainer.decode(Double.self, forKey: .humidity)
        self.windSpeed = try? windContainer.decode(Double.self, forKey: .speed)
        self.pressure = try? mainContainer.decode(Double.self, forKey: .pressure)
    }
    
    /* Swift 3
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
    }*/
    
    
    static func currentConditionInCity(name: String, completion: @escaping (Weather?, String?) -> ())  {
        let apiKey = "da1b32ee0e40eb229df52775b318ab69"
        let cityName = name
        
        var jsonUrlString = "http://api.openweathermap.org/data/2.5/weather?q=" + cityName + "&appid=" + apiKey + "&units=metric"
        jsonUrlString = jsonUrlString.replacingOccurrences(of: " ", with:  "")

        guard let url = URL(string: jsonUrlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(weather, nil)
                
                /*Swift3
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                    return
                }

                do {
                    let weather = try Weather(json: json)
                    completion(weather, nil)
                     
                } catch let jsonError{
                    completion(nil, "Error serializing JSON \(jsonError)")
                }*/
                
            } catch let jsonError{
                completion(nil, "Error serializing JSON \(jsonError)")
            }
            
        }.resume()
    }
}
