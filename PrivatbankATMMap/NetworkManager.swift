//
//  NetworkManager.swift
//  PrivatbankATMMap
//
//  Created by Anvar Azizov on 05.10.17.
//  Copyright © 2017 Anvar Azizov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

enum City: String {
    case Kyiv = "Киев"
    case Lviv = "Львов"
    case Kharkiv = "Харьков"
    case Odesa = "Одесса"
    case Dnipro = "Днепропетровск"
    case Zhytomyr = "Житомир"
    case Poltava = "Полтава"
    case Zhashkiv = "Жашков"
    case Reni = "Рени"
    case Chernihiv = "Чернигов"
    
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
        }
    }
}

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    private override init() {
        print("not allowed")
    }
    
    private let host = "https://api.privatbank.ua/p24api/infrastructure"
    
    func getATMs(for city: City, completionHandler: @escaping (JSON) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters: Parameters = [
            "json" : "",
            "atm" : "",
            "address" : "",
            "city" : city.rawValue
        ]
        
        do {
            let url = try host.asURL()
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default , headers: headers).responseJSON { response in
                if let d = response.data {
                    let atms = JSON(data: d)["devices"]
                    completionHandler(atms)
                }
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
}
