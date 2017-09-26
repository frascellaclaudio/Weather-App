//
//  WeatherResultStackView.swift
//  Weather App
//
//  Created by Frascella Decano on 26/9/17.
//  Copyright © 2017 Frascella Claudio. All rights reserved.
//

import UIKit

class WeatherResultStackView: UIStackView {

    //MARK: Initialization
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupLabels()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabels()
    }

    private func setupLabels() {
        let city = UILabel()
        let desc = UILabel()
        let iconImage = UIImageView()
        let temp = UILabel()
        let minMaxTemp = UILabel()
        let wind = UILabel()
        let humidity = UILabel()
        let pressure = UILabel()
    
        city.text = (WeatherViewController.weather?.city ?? "") + " " + (WeatherViewController.weather?.country ?? "")
        city.font = UIFont.systemFont(ofSize: 17)
        city.translatesAutoresizingMaskIntoConstraints = false
        
        desc.text = WeatherViewController.weather?.description ?? ""
        desc.font = UIFont.systemFont(ofSize: 12)
        desc.translatesAutoresizingMaskIntoConstraints = false
        
        var imageFromData: UIImage? = nil
        if let icon = WeatherViewController.weather?.icon {
            let url = URL(string: "http://openweathermap.org/img/w/" + icon + ".png")
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                imageFromData = UIImage(data: imageData)
            }
        }
        iconImage.image = imageFromData ?? UIImage(named: "default_icon", in: Bundle(for: (type(of: self))), compatibleWith: nil)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.tag = 3
        
        temp.text = ((WeatherViewController.weather?.temperature != nil) ? "\((WeatherViewController.weather?.temperature)!)" : "-" ) + "°C"
        temp.font = UIFont.systemFont(ofSize: 40)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.textAlignment = .center
        
        minMaxTemp.text = "Min: " + ((WeatherViewController.weather?.tempMin != nil) ? "\((WeatherViewController.weather?.tempMin)!)" : "-" ) + "°C | Max: " +
            ((WeatherViewController.weather?.tempMax != nil) ? "\((WeatherViewController.weather?.tempMax)!)" : "-" ) + "°C"
        minMaxTemp.font = UIFont.systemFont(ofSize: 12)
        minMaxTemp.translatesAutoresizingMaskIntoConstraints = false
        minMaxTemp.textAlignment = .center
        
        wind.text = "Wind: " + ((WeatherViewController.weather?.windSpeed != nil) ? "\((WeatherViewController.weather?.windSpeed)!)" : "-" ) + "m/s"
        wind.font = UIFont.systemFont(ofSize: 12)
        wind.translatesAutoresizingMaskIntoConstraints = false
        
        humidity.text = "Humidity: " + ((WeatherViewController.weather?.humidity != nil) ? "\((WeatherViewController.weather?.humidity)!)" : "-" ) + "%"
        humidity.font = UIFont.systemFont(ofSize: 12)
        humidity.translatesAutoresizingMaskIntoConstraints = false
        
        pressure.text = "Pressure: " + ((WeatherViewController.weather?.pressure != nil) ? "\((WeatherViewController.weather?.pressure)!)" : "-" ) + "hpa"
        pressure.font = UIFont.systemFont(ofSize: 12)
        pressure.translatesAutoresizingMaskIntoConstraints = false
        
        // summary group
        let summaryStack = UIStackView(arrangedSubviews: [city, desc])
        summaryStack.axis = .vertical
        summaryStack.alignment = .fill
        summaryStack.contentMode = .scaleToFill
        summaryStack.distribution = .fillProportionally
        summaryStack.translatesAutoresizingMaskIntoConstraints = false
        
        //top group
        let topStack = UIStackView(arrangedSubviews: [summaryStack, iconImage])
        topStack.axis = .horizontal
        topStack.alignment = .fill
        topStack.contentMode = .scaleToFill
        topStack.distribution = .fill
        topStack.translatesAutoresizingMaskIntoConstraints = false
        
        // temperature
        let tempStack = UIStackView(arrangedSubviews: [temp, minMaxTemp])
        tempStack.axis = .vertical
        tempStack.alignment = .fill
        tempStack.contentMode = .scaleToFill
        tempStack.distribution = .fillProportionally
        tempStack.translatesAutoresizingMaskIntoConstraints = false
        
        //measurements
        let measureStack = UIStackView(arrangedSubviews: [wind, humidity, pressure])
        measureStack.axis = .vertical
        measureStack.alignment = .trailing
        measureStack.contentMode = .scaleToFill
        measureStack.distribution = .fillEqually
        measureStack.translatesAutoresizingMaskIntoConstraints = false
        
        //bottom group
        let bottomStack = UIStackView(arrangedSubviews: [tempStack, measureStack])
        bottomStack.axis = .horizontal
        bottomStack.alignment = .fill
        bottomStack.contentMode = .scaleToFill
        bottomStack.distribution = .fillEqually
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(topStack)
        addArrangedSubview(bottomStack)
        self.axis = .vertical
        self.alignment = .fill
        self.contentMode = .scaleToFill
        self.distribution = .fillEqually
        
        //MARK: Constraints
        NSLayoutConstraint(item: topStack.viewWithTag(3)!, attribute: .width, relatedBy: .equal, toItem: topStack.viewWithTag(3)!, attribute: .height, multiplier: 1, constant: 0).isActive = true
    }
}
