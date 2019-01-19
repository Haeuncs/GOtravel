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
    let realm = try! Realm()
    var selectPlaceInfo = PlaceInfo()
    var dayRealmDB = dayRealm()
    var arrayMap = false
    var myColor : UIColor?
    var currentSelect = detailRealm()
    var dayDetailRealm = List<detailRealm>()
    override func loadView() {
        
        
    }
    override func viewDidLoad() {
        // cell 에서 받은 placeInfo 위치

//        marker.appearAnimation = .pop
        // add save Btn
        let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(self.selectSave))

        navigationItem.rightBarButtonItem = rightButton
        if arrayMap == false{
            map()
        }else{
            array_map()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    func array_map(){
        let camera = GMSCameraPosition.camera(withLatitude: currentSelect.latitude, longitude: currentSelect.longitude, zoom: 25)
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
        let detailRealmDB = detailRealm()
        detailRealmDB.title = selectPlaceInfo.title
        detailRealmDB.address = selectPlaceInfo.address
        detailRealmDB.longitude = (selectPlaceInfo.location?.longitude)!
        detailRealmDB.latitude = (selectPlaceInfo.location?.latitude)!
        try! realm.write {
            dayRealmDB.detailList.append(detailRealmDB)

        }
        self.navigationController?.popToRootViewController(animated: true)
//        try! realm.write {
//
//        }
    }
    
}
