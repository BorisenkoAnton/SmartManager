//
//  MapManager.swift
//  SmartManager
//
//  Created by Anton Borisenko on 7/7/20.
//  Copyright © 2020 Anton Borisenko. All rights reserved.
//

import UIKit
import MapKit

class MapManager {
    
    let locationManager = CLLocationManager()
    
    private let regionInMeters = 1000.00
    private var directionsArray = [MKDirections]()
    private var taskCoordinate: CLLocationCoordinate2D?
    
    // task placemark
    func setupPlacemark(task: Task, mapView: MKMapView) {
        
        guard let location = task.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = task.name
            annotation.subtitle = task.date
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.taskCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    // Checking availability of geolocation services
    func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> ()) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
            closure()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Location Services are Disabled",
                               message: "To enable it go: Settings -> Privacy -> Location Services and turn On"
                )
            }
        }
    }
    
    // Checking app authorization for using geolocation services
    func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if segueIdentifier == "getAddress" { showUserLocation(mapView: mapView) }
        case .denied:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showAlert(title: "Your Location is not available",
                               message: "To give permission go: Settings -> SmartManager -> Location"
                )
            }
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case.restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("new case is available")
        }
    }
    
    // Focusing map on the users location
    func showUserLocation(mapView: MKMapView) {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters ,
                                            longitudinalMeters: regionInMeters
            )
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Building route from user location to task location
    func getDirections(for mapView: MKMapView, previousLocation: (CLLocation) -> ()) {
            
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions, mapView: mapView)
        directions.calculate { (response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response else {
                self.showAlert(title: "Error", message: "Direction is not available")
                return
            }
            
            for route in response.routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
//              let distance = String(format: "%.1f", route.distance / 1000)
//              let timeInterval = route.expectedTravelTime / 60
            }
        }
    }
    
    // Settings for request for calculating route
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        guard let destinationCoordinate =  taskCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    // Changing viewed map area according to users moving
    func startTrackingUserLocation(for mapView: MKMapView, and location: CLLocation?, closure: (_ currentLocation: CLLocation) -> ()) {
        
        guard let location = location else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: location) > 50 else { return }
        
        closure(center)
    }
    
    // Reset all previously bilded routes before building new route
    func resetMapView(withNew directions: MKDirections, mapView: MKMapView) {
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    // Calculating center of viewing map area
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true)
    }
}
