//
//  googleMapViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 18/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import RealmSwift

class googleMapViewController : UIViewController {
    // 장소 검색 0, 지역 검색 1
    var categoryIndex = 0
    
    let realm = try! Realm()
    var selectPlaceInfo = PlaceInfo()
    var dayRealmDB = dayRealm()
    var arrayMap : Bool?
    var myColor : UIColor?
    var currentSelect = detailRealm()
    var dayDetailRealm = List<detailRealm>()
    
    override func loadView() {
        
        
    }
    override func viewDidLoad() {
        // cell 에서 받은 placeInfo 위치

//        marker.appearAnimation = .pop
        if arrayMap != nil{
            // add save Btn
            let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(self.selectSave))
            
            navigationItem.rightBarButtonItem = rightButton
            if arrayMap == false{
                map()
            }else{
                array_map()
            }
        }
        self.navigationController?.navigationBar.tintColor = Defaull_style.subTitleColor

    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func array_map(){
        self.navigationItem.title = currentSelect.title
        let camera = GMSCameraPosition.camera(withLatitude: currentSelect.latitude, longitude: currentSelect.longitude, zoom: 11.5)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        for i in dayDetailRealm{
            let marker = GMSMarker()
            marker.icon = GMSMarker.markerImage(with: myColor ?? #colorLiteral(red: 0.8544613487, green: 0.4699537418, blue: 0.4763622019, alpha: 1))
            marker.position = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
            marker.title = i.title
            marker.snippet = i.address
            marker.map = mapView
//            mapView.selectedMarker = marker
        }
    }
    func map(){
        //        print(selectPlaceInfo)
        self.navigationItem.title =  selectPlaceInfo.title

        let camera = GMSCameraPosition.camera(withLatitude:selectPlaceInfo.location!.latitude, longitude: selectPlaceInfo.location!.longitude, zoom: 15)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        // set custom color
        marker.icon = GMSMarker.markerImage(with: myColor ?? #colorLiteral(red: 0.8544613487, green: 0.4699537418, blue: 0.4763622019, alpha: 1))
        marker.position = CLLocationCoordinate2D(latitude: (selectPlaceInfo.location?.latitude)! , longitude: (selectPlaceInfo.location?.longitude)!)
        marker.title = selectPlaceInfo.title
        marker.snippet = selectPlaceInfo.address
        marker.map = mapView
        mapView.selectedMarker = marker

    }
    @objc func selectSave(){
        print("select")
        if categoryIndex == 0{
            let detailRealmDB = detailRealm()
            detailRealmDB.title = selectPlaceInfo.title
            detailRealmDB.address = selectPlaceInfo.address
            detailRealmDB.longitude = (selectPlaceInfo.location?.longitude)!
            detailRealmDB.latitude = (selectPlaceInfo.location?.latitude)!
            detailRealmDB.color = "default"
            try! realm.write {
                dayRealmDB.detailList.append(detailRealmDB)
                
            }
        
            
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            print("run")
            let countryRealmDB = countryRealm()
            countryRealmDB.city = selectPlaceInfo.address
            countryRealmDB.country = selectPlaceInfo.title
            countryRealmDB.latitude = (selectPlaceInfo.location?.latitude)!
            countryRealmDB.longitude = (selectPlaceInfo.location?.longitude)!
            let calenderVC = calendarViewController()
            calenderVC.saveCountryRealmData = countryRealmDB
            self.navigationController?.pushViewController( calenderVC, animated: true)
//            self.navigationController?.popToRootViewController(animated: true)
        }
//        try! realm.write {
//
//        }
    }
    
}
