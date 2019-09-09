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
    let marker = GMSMarker()
    var circle = GMSCircle()
    var minlat = Double()
    var minlon = Double()
    var maxlat = Double()
    var maxlon = Double()
    var mapMainView: GMSMapView!
    var addressString = String()
    var addressTitle = String()
    var currlat = Double()
    var currlon = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
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
                    
                    if pm.thoroughfare != nil {
                        self.addressString = self.addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        self.addressString = self.addressString + pm.subLocality! + ", "
                    }
                    if pm.locality != nil {
                        self.addressString = self.addressString + pm.locality! + ", "
                    }
                    if pm.administrativeArea != nil {
                        self.addressString = self.addressString + pm.administrativeArea! + ", "
                    }
                    if pm.country != nil {
                        self.addressString = self.addressString + pm.country! + ", "
                        self.addressTitle = pm.country!
                    }
                    if pm.postalCode != nil {
                        self.addressString = self.addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(self.addressString)
                    self.setCamera(dbLat: pdblLatitude, dbLong: pdblLongitude)
                }
        })
        
    }
    func setMapView(){
        mapMainView = GMSMapView.init(frame: CGRect.zero)
        view = mapMainView
    }
    
    func setCamera(dbLat : Double,dbLong : Double){
        let camera = GMSCameraPosition.camera(withLatitude: dbLat, longitude: dbLong, zoom: 15.0)
        mapMainView.camera = camera
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: dbLat, longitude: dbLong)
        marker.title = addressTitle
        marker.snippet = addressString
        marker.map = mapMainView
    }
    
    func readFile(){
        if let path = Bundle.main.path(forResource: "hub", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>,
                    let person = jsonResult["results"] as? NSDictionary {
                    let Type = person.object(forKey: "type") as! String
                    var LatArray:[Double] = []
                    var LongArray:[Double] = []
                    
                    let bounds = person.object(forKey: "bounds") as! NSDictionary
                    self.minlon = bounds.object(forKey: "minlon") as! Double
                    self.minlat = bounds.object(forKey: "minlat") as! Double
                    self.maxlon = bounds.object(forKey: "maxlon") as! Double
                    self.maxlat = bounds.object(forKey: "maxlat") as! Double
                    print("minlon,------",self.minlon)
                    print("minlat,------",self.minlat)
                    print("maxlon,------",self.maxlon)
                    print("maxlat,------",self.maxlat)
                    
                    
                    self.getAddressFromLatLon(pdblLatitude: minlat, withLongitude: minlon)
                    let checkBounds = GMSMutablePath()
                    checkBounds.add(CLLocationCoordinate2D(latitude: self.minlat, longitude: self.minlon))
                    checkBounds.add(CLLocationCoordinate2D(latitude: self.maxlat, longitude: self.maxlon))
                    
                    
                    
                    let geometry = person.object(forKey: "geometry") as! [[NSDictionary]]
                    let jsonObject = geometry[0]
                    for dic in jsonObject{
                        guard let lat = dic["lat"] as? Double else { return }
                        guard let long = dic["lon"] as? Double else { return }
                        LatArray.append(lat)
                        LongArray.append(long)
                    }
                    
                    let path = GMSMutablePath()
                    for i in 0..<LatArray.count{
                    path.add(CLLocationCoordinate2D(latitude: LatArray[i], longitude: LongArray[i]))

                    }
                    let polygon = GMSPolygon(path : path)
                    polygon.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
                    polygon.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
                    polygon.strokeWidth = 10
                    polygon.geodesic = true
                    polygon.map = self.mapMainView
                    
                    let circleCenter : CLLocationCoordinate2D  = CLLocationCoordinate2DMake(self.minlat, self.minlon);
                    self.circle = GMSCircle(position: circleCenter, radius: 1000)
                    self.circle.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
                    self.circle.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
                    self.circle.strokeWidth = 10.0;
                    self.circle.map = self.mapMainView;
                    
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
        currlat = userLocation.coordinate.latitude
        currlon = userLocation.coordinate.longitude
        self.setCamera(dbLat: currlat, dbLong: currlon)
        readFile()
        //print("Latitude----\(userLocation.coordinate.latitude)")
        //print("Longitude----\(userLocation.coordinate.longitude)")
        //self.getAddressFromLatLon(pdblLatitude: userLocation.coordinate.latitude, withLongitude: userLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location fail error---\(error)")
    }
}
