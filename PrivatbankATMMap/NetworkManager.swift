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

enum JSONKeys: String {
    case placeUaJSONKey = "placeUa"
    case cityUAJSONKey = "cityUA"
    case fullAddressUaJSONKey = "fullAddressUa"
    case latitudeJSONKey = "latitude"
    case longitudeJSONKey = "longitude"
}

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    private override init() {
        print("not allowed")
    }
    
    private let host = "https://api.privatbank.ua/p24api/infrastructure"
    private let headers: HTTPHeaders = ["Content-Type": "application/json"]
    
    func getATMs(for city: City, completionHandler: @escaping (JSON) -> Void) {
        
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
