//
//  ATMAnnotation.swift
//  PrivatbankATMMap
//
//  Created by Anvar Azizov on 05.10.17.
//  Copyright © 2017 Anvar Azizov. All rights reserved.
//

import UIKit
import MapKit

class ATMAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    init(with atm: ATM) {
        self.title = atm.name
        self.subtitle = atm.address
        self.coordinate = CLLocationCoordinate2D(latitude: atm.latitude, longitude: atm.longitude)
    }
}
