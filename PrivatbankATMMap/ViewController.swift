//
//  ViewController.swift
//  PrivatbankATMMap
//
//  Created by Anvar Azizov on 05.10.17.
//  Copyright © 2017 Anvar Azizov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocation?
    fileprivate var atmsArray = [ATM]()
    
    fileprivate let CityPickerVCIdentifier = "CityPickerViewController"
    fileprivate let placeUaJSONKey = "placeUa"
    fileprivate let cityUAJSONKey = "cityUA"
    fileprivate let fullAddressUaJSONKey = "fullAddressUa"
    fileprivate let latitudeJSONKey = "latitude"
    fileprivate let longitudeJSONKey = "longitude"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Map of ATMs"
        setupRightBarButtonItem(title: "Choose a city")
        
        // locationManager and mapView setup
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
    }
    
    fileprivate func setupRightBarButtonItem(title: String) {
        let rightItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(ViewController.showCityPicker))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    fileprivate func loadData(for city: City) {
        mapView.removeAnnotations(mapView.annotations)
        updateMap(with: city.centralCoordinate())
        NetworkManager.shared.getATMs(for: city) { [unowned self] (atms) in
            for (_, object) in atms {
                let dict = object.dictionaryValue
                if  let place = dict[self.placeUaJSONKey],
                    let city = dict[self.cityUAJSONKey],
                    let address = dict[self.fullAddressUaJSONKey],
                    let latitude = dict[self.latitudeJSONKey],
                    let longitude = dict[self.longitudeJSONKey]
                {
                    let atm: ATM = ATM(name: place.stringValue,
                                       city: city.stringValue,
                                       address: address.stringValue,
                                       latitude: latitude.doubleValue,
                                       longitude: longitude.doubleValue)
                    self.atmsArray.append(atm)
                    DispatchQueue.main.async {
                        let pin = ATMAnnotation(with: atm)
                        self.mapView.addAnnotation(pin)
                    }
                }
            }
        }
    }
    
    fileprivate func updateMap(with coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)
        mapView.setRegion(region, animated: true)
        let pin = ATMAnnotation(title: NSLocalizedString("Start Location", comment: ""),
                                subtitle: NSLocalizedString("Start Location Subtitle", comment: ""),
                                coordinate: coordinate)
        mapView.addAnnotation(pin)
    }
}

extension ViewController: CityPickerViewControllerDelegate {
    func cityDidPicked(city: City) {
        setupRightBarButtonItem(title: city.rawValue)
        loadData(for: city)
    }
    
    @objc fileprivate func showCityPicker() {
        let cityPickerVC = storyboard?.instantiateViewController(withIdentifier: CityPickerVCIdentifier) as! CityPickerViewController
        cityPickerVC.delegate = self
        present(cityPickerVC, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        guard let currentLocation = currentLocation else { return }
        updateMap(with: currentLocation.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        default:
            print("Location manager authorization status is \(status)")
            break
        }
    }
}

