//
//  LocationChecker.swift
//  app
//
//  Created by Remi Robert on 13/07/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationChecker {
    var locationAvalaible: Bool { get }
    var currentStatus: CLAuthorizationStatus { get }
    func requestForAuthorization()
}

extension LocationTripTracker: LocationChecker {
    var locationAvalaible: Bool {
        return type(of: locationManager).locationServicesEnabled()
    }

    var currentStatus: CLAuthorizationStatus {
        return type(of: locationManager).authorizationStatus()
    }

    func requestForAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
}
