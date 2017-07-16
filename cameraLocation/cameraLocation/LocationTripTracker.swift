//
//  TripRecorder.swift
//  app
//
//  Created by Remi Robert on 13/07/2017.
//  Copyright © 2017 Remi Robert. All rights reserved.
//

import UIKit
import CoreLocation

protocol TripTracker {
    var isRecording: Bool { get }
    func startLocationTracking()
    func stopLocationTracking()
}

class LocationTripTracker: NSObject, TripTracker {
    let locationManager: CLLocationManager
    fileprivate(set) var isRecording: Bool = false
    fileprivate(set) var currentLocation: CLLocation?

    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        setupForTracking()
    }

    private func setupForTracking(accuracy: CLLocationAccuracy = kCLLocationAccuracyBestForNavigation,
                                  distanceFilter: CLLocationDistance = kCLDistanceFilterNone) {
        locationManager.desiredAccuracy = accuracy
        locationManager.distanceFilter = distanceFilter
    }
}

extension LocationTripTracker {
    func startLocationTracking() {
        isRecording = true
        locationManager.startUpdatingLocation()
    }

    func stopLocationTracking() {
        isRecording = false
        locationManager.stopUpdatingLocation()
    }
}

extension LocationTripTracker {
    fileprivate func filterBestLocation(locations: [CLLocation]) -> CLLocation? {
        var bestAccuracy: CLLocationAccuracy = 0
        var bestLocation: CLLocation?
        for location in locations {
            if location.horizontalAccuracy > bestAccuracy {
                bestLocation = location
                bestAccuracy = location.horizontalAccuracy
            }
        }
        return bestLocation
    }
}

extension LocationTripTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        isRecording = false
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        isRecording = true
    }
}
