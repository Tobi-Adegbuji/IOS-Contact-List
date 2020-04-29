//
//  MapPoint.swift
//  My Contact List
//
//  Created by Cistudent on 4/29/20.
//  Copyright © 2020 Cistudent. All rights reserved.
//

import UIKit
import MapKit

class MapPoint: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
