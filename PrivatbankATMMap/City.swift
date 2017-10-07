//
//  City.swift
//  PrivatbankATMMap
//
//  Created by Anvar Azizov on 07.10.17.
//  Copyright © 2017 Anvar Azizov. All rights reserved.
//

import Foundation
import CoreLocation

enum City: String {
    case Kyiv = "Kyiv"
    case Lviv = "Lviv"
    case Kharkiv = "Kharkiv"
    case Odesa = "Odesa"
    case Dnipro = "Dnipropetrovsk"
    case Zhytomyr = "Zhytomyr"
    case Poltava = "Poltava"
    case Zhashkiv = "Zhashkiv"
    case Reni = "Reni"
    case Chernihiv = "Chernihiv"
    case Boyarka = "Boiarka"
    
    func centralCoordinate() -> CLLocationCoordinate2D {
        switch self {
        case .Kyiv:
            return CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234)
        case .Lviv:
            return CLLocationCoordinate2D(latitude: 49.8397, longitude: 24.0297)
        case .Kharkiv:
            return CLLocationCoordinate2D(latitude: 49.9935, longitude: 36.2304)
        case .Odesa:
            return CLLocationCoordinate2D(latitude: 46.4825, longitude: 30.7233)
        case .Dnipro:
            return CLLocationCoordinate2D(latitude: 48.4647, longitude: 35.0462)
        case .Zhytomyr:
            return CLLocationCoordinate2D(latitude: 50.2547, longitude: 28.6587)
        case .Poltava:
            return CLLocationCoordinate2D(latitude: 49.5883, longitude: 34.5514)
        case .Zhashkiv:
            return CLLocationCoordinate2D(latitude: 49.2412, longitude: 30.0990)
        case .Reni:
            return CLLocationCoordinate2D(latitude: 45.4571, longitude: 28.2889)
        case .Chernihiv:
            return CLLocationCoordinate2D(latitude: 51.4982, longitude: 31.2893)
        case .Boyarka:
            return CLLocationCoordinate2D(latitude: 50.3171, longitude: 30.2982)
        }
    }
    
    func radius() -> CLLocationDistance {
        switch self {
        case .Kyiv:
            return 50000.0
        case .Lviv:
            return 30000.0
        case .Kharkiv:
            return 50000.0
        case .Odesa:
            return 40000.0
        case .Dnipro:
            return 40000.0
        case .Zhytomyr:
            return 40000.0
        case .Poltava:
            return 40000.0
        case .Zhashkiv:
            return 10000.0
        case .Reni:
            return 10000.0
        case .Chernihiv:
            return 30000.0
        case .Boyarka:
            return 10.0
        }
    }
    
    func distance(from location: CLLocation) -> CLLocationDistance {
        return location.distance(from: CLLocation(latitude: self.centralCoordinate().latitude, longitude: self.centralCoordinate().longitude))
    }
}
