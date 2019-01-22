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
    var arrayMap : Bool?

    let realm = try! Realm()
    // 장소 검색에서 VC에게 전달받는 변수들
    var selectPlaceInfo = PlaceInfo()
    var dayRealmDB = dayRealm()
    
    var myColor : UIColor?
    
    // path 버튼 선택 시 VC에게 전달받는 변수들
    var currentSelect = detailRealm()
    var dayDetailRealm = List<detailRealm>()
    
    // path 의 전체를 표한하기 위해서 사용된 변수들
    var  mapView : GMSMapView?
    // path loc 둘 중 하나 사용하여..
    var pathArr = [GMSPath]()
    var location_coordi = [CLLocationCoordinate2D]()

    // path의 VC에서 받는 city 네임
    var navTitle = ""
    
    // my google api key
    let myRouteAPIKey = "AIzaSyDUhQXgVb4vwoWwxGqRqTBqd-9DWZgElGo"
    override func loadView() {
        
        
    }
    override func viewDidLoad() {
        // cell 에서 받은 placeInfo 위치

//        marker.appearAnimation = .pop
        view = mapView
    }
    override func viewWillAppear(_ animated: Bool) {
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
    func draw_marker(i : detailRealm ){
        let marker = GMSMarker()
        marker.icon = GMSMarker.markerImage(with: myColor ?? #colorLiteral(red: 0.8544613487, green: 0.4699537418, blue: 0.4763622019, alpha: 1))
        marker.position = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
        marker.title = i.title
        marker.snippet = i.address
        marker.map = self.mapView
        location_coordi.append(marker.position)
    }
    // path 선택 시
    func array_map(){
        self.navigationItem.title = navTitle
        let camera = GMSCameraPosition.camera(withLatitude: currentSelect.latitude, longitude: currentSelect.longitude, zoom: 11.5)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        if dayDetailRealm.count == 1 {
            draw_marker(i: dayDetailRealm.first!)
        }else{
            // 데이터 다 계산한 후에 화면 업데이트 하도록 디스패치 그룹 만들어줌
            let dispatchGroup = DispatchGroup()
            
            for i in 0 ..< dayDetailRealm.count-1{
                dispatchGroup.enter()
                //0,1,2
                let origin = "\(dayDetailRealm[i].latitude),\(dayDetailRealm[i].longitude)"
                draw_marker(i: dayDetailRealm[i])
                let destination = "\(dayDetailRealm[i+1].latitude),\(dayDetailRealm[i+1].longitude)"
                draw_marker(i: dayDetailRealm[i+1])
                let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=" + myRouteAPIKey
                
                print(urlString)
                let url = URL(string: urlString)
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        print("error")
                        dispatchGroup.leave()
                    }else{
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                            let routes = json["routes"] as! NSArray
                            //                        self.mapView!.clear()
                            
                            OperationQueue.main.addOperation({
                                for route in routes
                                {
                                    let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                                    let points = routeOverviewPolyline.object(forKey: "points")
                                    let path = GMSPath.init(fromEncodedPath: points! as! String)
                                    self.pathArr.append(path!)
                                    let polyline = GMSPolyline.init(path: path)
                                    polyline.strokeWidth = 4
                                    polyline.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                                    polyline.map = self.mapView
                                    print("끝")
                                    dispatchGroup.leave()
                                }
                            })
                        }catch let error as NSError{
                            print("error:\(error)")
                            dispatchGroup.leave()
                        }
                    }
                }).resume()
            }
            
            dispatchGroup.notify(queue:.main) {
                print("실행")
                var bounds = GMSCoordinateBounds()
                for loc in self.location_coordi{
                    bounds = bounds.includingCoordinate(loc)
                }
                self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
            }
        }
    }
    func map(){
        //        print(selectPlaceInfo)
        self.navigationItem.title =  selectPlaceInfo.title

        let camera = GMSCameraPosition.camera(withLatitude:selectPlaceInfo.location!.latitude, longitude: selectPlaceInfo.location!.longitude, zoom: 15)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        // set custom color
        marker.icon = GMSMarker.markerImage(with: myColor ?? #colorLiteral(red: 0.8544613487, green: 0.4699537418, blue: 0.4763622019, alpha: 1))
        marker.position = CLLocationCoordinate2D(latitude: (selectPlaceInfo.location?.latitude)! , longitude: (selectPlaceInfo.location?.longitude)!)
        marker.title = selectPlaceInfo.title
        marker.snippet = selectPlaceInfo.address
        marker.map = mapView
        mapView!.selectedMarker = marker

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
