//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Frascella Decano on 20/9/17.
//  Copyright © 2017 Frascella Claudio. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    static public var weather: Weather?
    
    private let background = UIImageView()
    private let cityNameTextField = UITextField()
    private let submitButton = UIButton()
    private let locationButton = UIButton()
    private let inputFieldsStack = UIStackView()
    private let pageLabel = UILabel()
    private let resultsLabel = UILabel()
    private var resultStack = UIStackView()
    
    var location = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameTextField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func setup() {
        //setup background
        background.image = UIImage(named: "bg_seasky", in: Bundle(for: (type(of: self))), compatibleWith: nil)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.contentMode = .scaleAspectFill
        background.alpha = 0.2

        // page label
        pageLabel.text = "Weather News"
        pageLabel.font = UIFont.systemFont(ofSize: 28)
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // input stack
        inputFieldsStack.frame = CGRect(x: 20, y: self.view.layoutMargins.top + 100, width: self.view.frame.width - 50, height: 30)
        inputFieldsStack.axis = .horizontal
        inputFieldsStack.translatesAutoresizingMaskIntoConstraints = true
        inputFieldsStack.contentMode = .scaleToFill
        
        // textfield
        cityNameTextField.placeholder = "Enter name of city (e.g. London, New York)"
        cityNameTextField.font = UIFont.systemFont(ofSize: 12)
        cityNameTextField.borderStyle = UITextBorderStyle.roundedRect
        cityNameTextField.autocorrectionType = UITextAutocorrectionType.no
        cityNameTextField.keyboardType = UIKeyboardType.default
        cityNameTextField.returnKeyType = UIReturnKeyType.done
        cityNameTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        cityNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        // location button
        locationButton.setImage(UIImage(named: "location_marker", in: Bundle(for: (type(of: self))), compatibleWith: nil), for: .normal)
        locationButton.contentMode = .scaleToFill
        locationButton.contentHorizontalAlignment = .center
        locationButton.contentVerticalAlignment = .center
        locationButton.addTarget(self, action: #selector(findUserLocation), for: .touchUpInside)
        locationButton.tag = 2
        
        // submit button
        submitButton.frame = CGRect(x: 20, y: inputFieldsStack.frame.maxY + 8, width: 100, height: 25)
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.setTitleColor(UIColor.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        submitButton.backgroundColor = UIColor(red:0.94, green:0.76, blue:0.76, alpha:1.0)
        submitButton.layer.cornerRadius = 3.0
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(background)
        self.view.sendSubview(toBack: background)
        inputFieldsStack.addArrangedSubview(cityNameTextField)
        inputFieldsStack.addArrangedSubview(locationButton)
        self.view.addSubview(inputFieldsStack)
        self.view.addSubview(submitButton)
        self.view.addSubview(pageLabel)
        
        
        // set constraints
        background.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        background.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        background.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        background.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        // button aspect ratio
        NSLayoutConstraint(item: inputFieldsStack.viewWithTag(2)!, attribute: .width, relatedBy: .equal, toItem: inputFieldsStack.viewWithTag(2)!, attribute: .height, multiplier: 1, constant: 0).isActive = true
        locationButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        locationButton.widthAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        
        pageLabel.bottomAnchor.constraint(equalTo: inputFieldsStack.topAnchor, constant: -20).isActive = true
        pageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        pageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 20).isActive = true
    }
    
    private func setupResult(_ error: String?) {

        if let error = error {
            resultsLabel.text = error
            resultsLabel.numberOfLines = 0
            resultsLabel.sizeToFit()
            resultsLabel.font = UIFont.systemFont(ofSize: 12)
            resultsLabel.textColor = UIColor.red
            resultsLabel.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(resultsLabel)
            
            resultsLabel.heightAnchor.constraint(lessThanOrEqualToConstant: self.view.frame.height / 2).isActive = true
            resultsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            resultsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            resultsLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 50).isActive = true
            return
        }
        
        resultStack = WeatherResultStackView(frame: CGRect(x: 20, y: submitButton.layoutMargins.bottom + 200, width: self.view.frame.width - 50, height: 120))
        resultStack.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(resultStack)
    }
    
    @objc func submitButtonPressed() {
        resultsLabel.removeFromSuperview()
        resultStack.removeFromSuperview()
        
        Weather.currentConditionInCity(name: cityNameTextField.text!) { (weather: Weather?, error: String?) in
            DispatchQueue.main.async(execute: {
                if let weather = weather {
                    WeatherViewController.weather = weather
                }
                self.setupResult(error)
            })
        }
    }
    
    let locationManager = CLLocationManager()

    @objc func findUserLocation() {
        DispatchQueue.main.async(execute: { self.cityNameTextField.text = self.location })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        CLGeocoder().reverseGeocodeLocation(userLocation) {
            (placemarks, error) in
            
            if error == nil {
                if let placemark = placemarks?[0] {
                    if let locality = placemark.locality {
                        self.location = locality
                    }
                }
            }
        }
    }
}

