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
        mapView.delegate = self
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
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 3000, 3000)
        mapView.setRegion(region, animated: true)
        let pin = ATMAnnotation(title: NSLocalizedString("Start Location", comment: ""),
                                subtitle: NSLocalizedString("City Center", comment: ""),
                                coordinate: coordinate)
        mapView.addAnnotation(pin)
    }
}

extension ViewController: CityPickerViewControllerDelegate {
    func cityDidPicked(city: City) {
        setupRightBarButtonItem(title: city.rawValue)
        loadData(for: city)
        var coordinate = city.centralCoordinate()
        if let currentLocation = currentLocation {
            if city.distance(from: currentLocation) < city.radius() {
                coordinate = currentLocation.coordinate
            }
        }
        updateMap(with: coordinate)
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
        
        let nearestCities = Shared.cities.filter({ $0.distance(from: currentLocation) < $0.radius() })
        if nearestCities.count > 0 {
            loadData(for: nearestCities[0])
        }
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
            
            let alertVC = UIAlertController(title: NSLocalizedString("Hello", comment: ""),
                                            message: NSLocalizedString("Please, turn on location or choose a city in a top right corner", comment: ""),
                                            preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: ""),
                                         style: .default,
                                         handler: nil)
            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
            
            break
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKPinAnnotationView
        guard let annotation = annotation as? ATMAnnotation else { return nil }
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "ATMAnnotationIdentifier") as? MKPinAnnotationView {
            view = dequeuedView
            view.canShowCallout = false
            view.isEnabled = true
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ATMAnnotationIdentifier")
            view.canShowCallout = false
            view.isEnabled = true
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }

        if let annotation = view.annotation as? ATMAnnotation {
            let calloutView = CustomAnnotationPopUpView(frame: CGRect(x: 0.0, y: 0.0, width: 140.0, height: 80.0))
            calloutView.placeLabel.text = annotation.title
            calloutView.addressLabel.text = annotation.subtitle
            calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height * 0.52)
            view.addSubview(calloutView)
            mapView.setCenter(annotation.coordinate, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: MKPinAnnotationView.self) {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
}

