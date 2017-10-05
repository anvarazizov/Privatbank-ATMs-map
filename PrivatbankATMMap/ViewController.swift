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
import DropDown

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    fileprivate var currentLocation: CLLocation?
    fileprivate let drowdownList = DropDown()
    
    let allCities = [City.Kyiv, City.Chernihiv, City.Dnipro, City.Kharkiv, City.Odesa, City.Lviv, City.Poltava, City.Reni, City.Zhytomyr, City.Zhashkiv]
    
    var atmsArray = [ATM]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Map of ATMs"
        let rightItem = UIBarButtonItem(title: "Choose a city", style: .plain, target: self, action: #selector(ViewController.presentDropDownList))
        navigationItem.rightBarButtonItem = rightItem
        
        drowdownList.anchorView = view
        drowdownList.cellHeight = 40.0
        drowdownList.direction = .top
        drowdownList.textFont = UIFont.systemFont(ofSize: 13.0)
        drowdownList.dataSource = allCities.map({ $0.rawValue })
        drowdownList.cellConfiguration = { [unowned self] (index, item) in
            return self.allCities[index].rawValue
        }
        
        drowdownList.selectionAction = { [unowned self] (index, item) in
            self.loadData(for: self.allCities[index])
        }
        
        // locationManager and mapView setup
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
    }
    
    @objc func presentDropDownList() {
        drowdownList.show()
    }
    
    func loadData(for city: City) {
        mapView.removeAnnotations(mapView.annotations)
        updateMap(with: city.centralCoordinate())
        NetworkManager.shared.getATMs(for: city) { (atms) in
            for (_, object) in atms {
                let dict = object.dictionaryValue
                if  let place = dict["placeUa"],
                    let city = dict["cityUA"],
                    let address = dict["fullAddressUa"],
                    let latitude = dict["latitude"],
                    let longitude = dict["longitude"]
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
        let pin = ATMAnnotation(title: "Start Location", subtitle: "Start Location Subtitle", coordinate: coordinate)
        mapView.addAnnotation(pin)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        updateMap(with: currentLocation!.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        default:
            print("status is \(status)")
            break
        }
    }
}
