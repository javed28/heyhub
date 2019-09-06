//
//  ViewController.swift
//  Practise
//
//  Created by Javed Siddique on 08/08/19.
//  Copyright © 2019 Alpha Plus Technologies. All rights reserved.
//

import UIKit
import CoreLocation

class MyCol : UICollectionViewCell{
    
    weak var textLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
            ])
        self.textLabel = textLabel
        self.contentView.backgroundColor = .white
        self.textLabel.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel.text = nil
    }
}

class MyColHeaderView : UICollectionViewCell{
   // weak var backView : UIView!
    weak var btnAdd : UIButton!
    weak var btnRemove : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        let btnAdd = UIButton(frame: CGRect(x:8,y:8,width: self.contentView.frame.width/2-12,height:50))
        btnAdd.setTitle("Add", for: .normal)
        btnAdd.backgroundColor = UIColor.red
        btnAdd.addTarget(self, action: #selector(addClicked(_:)), for: .touchUpInside)
        self.contentView.addSubview(btnAdd)
        let btnRemove = UIButton(frame: CGRect(x:self.contentView.frame.width/2+4,y:8,width: self.contentView.frame.width/2-10,height:50))
        btnRemove.setTitle("Remove", for: .normal)
        btnRemove.backgroundColor = UIColor.red
        self.contentView.addSubview(btnRemove)
        //self.backView = backView
        self.btnAdd = btnAdd
        self.btnRemove = btnRemove
        self.btnAdd.gradientBackground(from: UIColor.blue, to: UIColor.black, direction: .topToBottom)
        self.btnRemove.gradientBackground(from: UIColor.blue, to: UIColor.black, direction: .rightToLeft)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.backView = nil
        self.btnAdd = nil
        self.btnRemove = nil
    }
    @objc func addClicked(_ sender : UIButton){
        print("Add Clicked----")
    }
}


class ViewController: UIViewController {
    var locationManager : CLLocationManager!
    weak var uiCol : UICollectionView!
    weak var topView : UIView!
    var lastContentOffset: CGFloat = 0
    var dummyData : [String] = ["1111","22222","33333","1111","22222","33333","1111","22222","33333","1111","22222","33333","1111","22222","33333","1111","22222","33333","1111","22222","33333","1111","22222","33333","1111","22222","33333","1111","22222","33333","1111","22222","33333","1111","22222","33333"]
    private let spacing:CGFloat = 8.0
    
    override func loadView() {
        super.loadView()
        
        let layoutScrollDirection = UICollectionViewFlowLayout()
        layoutScrollDirection.scrollDirection = .vertical
        layoutScrollDirection.sectionHeadersPinToVisibleBounds = true
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layoutScrollDirection)
        collection.frame = .zero
        collection.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collection)
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200),
            collection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        self.uiCol = collection
        uiCol.register(MyCol.self, forCellWithReuseIdentifier: "MyCell")
        uiCol.register(MyColHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyHeaderCell")
        navigationController?.navigationBar.isTranslucent = false
        let view = UIView(frame: CGRect(x: 8, y: 0, width: self.view.frame.width-16, height: 200))
        view.gradientBackground(from: UIColor.blue, to: UIColor.black, direction: .bottomToTop)
        //view.backgroundColor = UIColor.blue
        
        
        self.view.addSubview(view)
        self.topView = view
        self.determineMyCurrentLocation()
    }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiCol.backgroundColor = .white
        self.uiCol.dataSource = self
        self.uiCol.delegate = self
        // Do any additional setup after loading the view.
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            // did move up
            
            let offset = scrollView.contentOffset.y
            if(offset > 200){
                self.topView.frame.size.height=0
            }else{
                self.topView.frame.size.height = 200 - offset
            }
            self.uiCol?.frame.size.height = self.view.bounds.height
            self.uiCol?.frame.origin.y = self.topView.frame.maxY
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            // did move down
            
            UIView.animate(withDuration: 0.5, animations: {
            
            self.topView.frame.size.height = 200
            self.uiCol?.frame.origin.y = self.topView.frame.maxY
                })
        } else {
            // didn't move
        }
    }
}
extension ViewController:UICollectionViewDelegate{
    
}
extension ViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.uiCol.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCol
        cell.textLabel.text = dummyData[indexPath.row]
        cell.contentView.layer.shadowOpacity = 0.325
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.contentView.layer.shadowRadius = 10
        cell.contentView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 10
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MyHeaderCell", for: indexPath)
            headerView.backgroundColor = UIColor.white
            return headerView
    }
    
}
extension ViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.uiCol.bounds.size.width/2-12, height: self.uiCol.bounds.size.width/2-12)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.uiCol.frame.width, height: 68)
    }
}
extension ViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation : CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        manager.delegate = nil
        print("Latitude----\(userLocation.coordinate.latitude)")
        print("Longitude----\(userLocation.coordinate.longitude)")
        self.getAddressFromLatLon(pdblLatitude: userLocation.coordinate.latitude, withLongitude: userLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location fail error---\(error)")
    }
}

