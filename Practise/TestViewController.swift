//
//  ViewController.swift
//  Test
//
//  Created by gadgetzone on 12/19/18.
//  Copyright © 2018 Javed. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class TestViewController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    
    let locationManager = CLLocationManager()
    var lat = CLLocationDegrees()
    var lng = CLLocationDegrees()
    var currentAddress = String()
    
    var minlat = Double()
    var minlon = Double()
    var maxlat = Double()
    var maxlon = Double()
    
    @IBOutlet weak var mapMainView: GMSMapView!
    let marker = GMSMarker()
    var circle = GMSCircle()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocation()
        readFile()
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func readFile(){
        if let path = Bundle.main.path(forResource: "hub", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>,
                    let person = jsonResult["results"] as? NSDictionary {
                    let Type = person.object(forKey: "type") as! String
                    var finalArray:[Double] = []
                    
                    
                    let bounds = person.object(forKey: "bounds") as! NSDictionary
                    self.minlon = bounds.object(forKey: "minlon") as! Double
                    self.minlat = bounds.object(forKey: "minlat") as! Double
                    self.maxlon = bounds.object(forKey: "maxlon") as! Double
                    self.maxlat = bounds.object(forKey: "maxlat") as! Double
                    print("minlon,------",self.minlon)
                    print("minlat,------",self.minlat)
                    print("maxlon,------",self.maxlon)
                    print("maxlat,------",self.maxlat)
                    
                    
                    
                    let geometry = person.object(forKey: "geometry") as! [[NSDictionary]]
                    let jsonObject = geometry[0]
                    for dic in jsonObject{
                        guard let lat = dic["lat"] as? Double else { return }
                        finalArray.append(lat)
                    }
                    
                    //  }
                    // do stuff
                    let path = GMSMutablePath()
                    path.add(CLLocationCoordinate2D(latitude: self.minlat, longitude: self.minlon))
                    path.add(CLLocationCoordinate2D(latitude: self.maxlat, longitude: self.maxlon))
                    /*let polyline = GMSPolyline(path: path)
                     polyline.strokeWidth = 10.0
                     polyline.strokeColor = .red
                     polyline.geodesic = true
                     let rectangle = GMSPolyline(path: path)
                     rectangle.map = self.mapMainView*/
                    
                    
                    
                    let polygon = GMSPolygon(path : path)
                    
                    polygon.fillColor = UIColor.red
                    polygon.strokeColor = .black
                    polygon.strokeWidth = 2
                    
                    polygon.map = self.mapMainView
                    
                    let circleCenter : CLLocationCoordinate2D  = CLLocationCoordinate2DMake(self.minlat, self.minlon);
                    self.circle = GMSCircle(position: circleCenter, radius: 1609.34)
                    self.circle.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
                    self.circle.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
                    self.circle.strokeWidth = 2.5;
                    self.circle.map = self.mapMainView;
                }
            } catch {
                // handle error
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadLocation(){
        let status  = CLLocationManager.authorizationStatus()
        // 2
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        // 3
        if status == .denied || status == .restricted {
            showAlert(strTitle: "Location Services Disabled", strMessage: "In order to be notified, please open this app's settings and set location access to 'Always'.")
            
            return
        }
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else{
            print("Location service disabled");
        }
    }
    func showAlert(strTitle : String,strMessage : String){
        var uiAlert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if let url = NSURL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url as URL)
            }
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locationManager.location != nil {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            lat = locValue.latitude
            lng = locValue.longitude
            locationManager.stopUpdatingLocation()
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 13.0)
            self.mapMainView.camera = camera
            let location = CLLocation(latitude: lat, longitude: lng) //changed!!!
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                //if let p0 = placemarks?.first
                //{
                //let p = CLPlacemark(placemark:p0)
                
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    /* if pm.name != nil {
                     addressString = addressString + pm.name! + ", "
                     }*/
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.subAdministrativeArea != nil {
                        addressString = addressString + pm.subAdministrativeArea! + ", "
                    }
                    if pm.administrativeArea != nil {
                        addressString = addressString + pm.administrativeArea! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country!
                    }
                    
                    print("Address------",addressString)
                    self.currentAddress = addressString
                }
                DispatchQueue.main.async {
                    
                    self.marker.position = CLLocationCoordinate2D(latitude: self.minlat, longitude: self.minlon)
                    //self.marker.title = String(describing: GlobalVariables.currentAddres)
                    self.marker.snippet = "Address : \(self.currentAddress)"
                    self.marker.map = self.mapMainView
                    
                    
                    
                }
                /* }
                 else {
                 print("Problem with the data received from geocoder")
                 }*/
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error"+error.localizedDescription)
    }
    
    /* func isLocationWithinArea(longitude: Double, latitude: Double, accuray: Double) -> Bool{
     
     }*/
    
    
    
    
}

