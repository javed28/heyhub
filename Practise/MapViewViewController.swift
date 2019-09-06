//
//  MapViewViewController.swift
//  Practise
//
//  Created by Javed Siddique on 06/09/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class MapViewViewController: UIViewController {
    var locationManager : CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
            determineMyCurrentLocation()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func determineMyCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        //let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        // let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.administrativeArea)
                    print(pm.subAdministrativeArea)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.administrativeArea != nil {
                        addressString = addressString + pm.administrativeArea! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(addressString)
                }
        })
        
    }
    func setMapView(dbLat : Double,dbLong : Double){
        
        let camera = GMSCameraPosition.camera(withLatitude: dbLat, longitude: dbLong, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: dbLat, longitude: dbLong)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    func readJsonFile(){
        if let path = Bundle.main.path(forResource: "location", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? NSDictionary,
                    let person = jsonResult["results"] as? [Any] {
                    // do stuff
                    print("Json00----",person)
                }
            } catch {
                // handle error
            }
        }
    }
}
extension MapViewViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation : CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        manager.delegate = nil
        print("Latitude----\(userLocation.coordinate.latitude)")
        print("Longitude----\(userLocation.coordinate.longitude)")
        self.getAddressFromLatLon(pdblLatitude: userLocation.coordinate.latitude, withLongitude: userLocation.coordinate.longitude)
        setMapView(dbLat: userLocation.coordinate.latitude, dbLong: userLocation.coordinate.longitude)
        readJsonFile()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location fail error---\(error)")
    }
}
