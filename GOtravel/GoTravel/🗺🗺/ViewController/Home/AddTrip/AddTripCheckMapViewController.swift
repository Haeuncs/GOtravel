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
import SnapKit

class AddTripCheckMapViewController : UIViewController {
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
  lazy var  mapView : GMSMapView = {
    let map = GMSMapView()
    map.translatesAutoresizingMaskIntoConstraints = false
    return map
  }()
  // path loc 둘 중 하나 사용하여..
  var pathArr = [GMSPath]()
  var location_coordi = [CLLocationCoordinate2D]()
  
  // path의 VC에서 받는 city 네임
  var navTitle = ""
  
  override func viewDidLoad() {
    view.backgroundColor = .white
    // cell 에서 받은 placeInfo 위치
      view.addSubview(mapView)
    view.addSubview(navView)
    navView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(44)
    }
    mapView.snp.makeConstraints{ make in
      make.top.equalTo(navView.snp.bottom)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.bottom.equalTo(view.snp.bottom)
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    if let customTabBarController = self.tabBarController as? TabbarViewController {
      customTabBarController.hideTabBarAnimated(hide: false, completion: nil)
      customTabBarController.setSelectLine(index: 0)
    }
    // 여행 도시 추가
    if arrayMap == false{
      navView.setButtonTitle(title: "다음")
      navView.actionBtn.addTarget(self, action: #selector(nextEvent), for: .touchUpInside)
      map()
    }else{
      navView.setButtonTitle(title: "")
      array_map()
    }
    //    }
    
  }
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setLeftIcon(image: UIImage(named: "back")!)
    view.dismissBtn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
    //    view.backgroundColor = UIColor.clear
    return view
  }()
  // 마커 안에 들어가는 라벨
  lazy var textLabelInMarker : UILabel = {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    label.text = "1"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
    label.textColor = Defaull_style.markerTextColor
    //        label.backgroundColor = .black
    label.clipsToBounds = true
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  func customMarker(color : UIColor) -> UIImage {
    let customMarker = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    customMarker.layer.cornerRadius = 40/2
    customMarker.layer.borderWidth = 1.5
    customMarker.layer.borderColor = Defaull_style.markerTextColor.cgColor
    customMarker.backgroundColor = color
    customMarker.translatesAutoresizingMaskIntoConstraints = false
    customMarker.addSubview(textLabelInMarker)
    textLabelInMarker.centerXAnchor.constraint(equalTo: customMarker.centerXAnchor).isActive = true
    textLabelInMarker.centerYAnchor.constraint(equalTo: customMarker.centerYAnchor).isActive = true
    textLabelInMarker.widthAnchor.constraint(equalTo: customMarker.widthAnchor).isActive = true
    textLabelInMarker.heightAnchor.constraint(equalTo: customMarker.heightAnchor).isActive = true
    
    return customMarker.asImage()
  }
  func draw_marker(i : detailRealm,index:Int){
    let marker = GMSMarker()
    let colorStr = i.color
    var colorUIColor = #colorLiteral(red: 0.5372078419, green: 0.5372861624, blue: 0.5371831059, alpha: 1)
    if colorStr != "default"{
      let colorArr = colorStr.components(separatedBy: " ")
      colorUIColor = UIColor.init(red: characterToCgfloat(str: colorArr[0]), green: characterToCgfloat(str: colorArr[1]), blue: characterToCgfloat(str: colorArr[2]), alpha: characterToCgfloat(str: colorArr[3]))
    }
    textLabelInMarker.text = String(index)
    marker.icon = customMarker(color: colorUIColor)
    marker.position = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
    marker.title = i.title
    marker.snippet = i.address
    marker.map = self.mapView
    location_coordi.append(marker.position)
  }
  func characterToCgfloat(str : String) -> CGFloat {
    let n = NumberFormatter().number(from: str)
    return n as! CGFloat
  }
  
  // path 선택 시
  func array_map(){
    navView.setTitle(title: navTitle)
    let camera = GMSCameraPosition.camera(withLatitude: currentSelect.latitude, longitude: currentSelect.longitude, zoom: 11.5)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    //    view = mapView
    if dayDetailRealm.count == 1 {
      draw_marker(i: dayDetailRealm.first!,index : 1)
    }else{
      // 데이터 다 계산한 후에 화면 업데이트 하도록 디스패치 그룹 만들어줌
      let dispatchGroup = DispatchGroup()
      
      for i in 0 ..< dayDetailRealm.count-1{
        dispatchGroup.enter()
        //0,1,2
        let origin = "\(dayDetailRealm[i].latitude),\(dayDetailRealm[i].longitude)"
        draw_marker(i: dayDetailRealm[i],index : i+1)
        let destination = "\(dayDetailRealm[i+1].latitude),\(dayDetailRealm[i+1].longitude)"
        draw_marker(i: dayDetailRealm[i+1],index : i+2)
        guard let googleMapAPIKey = Singleton.shared.googleMapAPIKey else { return }
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=transit&key=" + googleMapAPIKey
        
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
              let state = json["status"]
              let error = json["error_message"]
              print(error)
              print(state)
              
              if state! as! String == "OK"{
                //                            print(String(describing: state.va))
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
              }else if state! as! String == "ZERO_RESULTS" {
                print("ZERO_RESULTS")
                OperationQueue.main.addOperation({
                  let path = GMSMutablePath()
                  path.add(CLLocationCoordinate2D(latitude: self.dayDetailRealm[i].latitude, longitude: self.dayDetailRealm[i].longitude))
                  path.add(CLLocationCoordinate2D(latitude: self.dayDetailRealm[i+1].latitude, longitude: self.dayDetailRealm[i+1].longitude))
                  self.pathArr.append(path)
                  let polyline = GMSPolyline.init(path: path)
                  polyline.strokeWidth = 4
                  polyline.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                  polyline.map = self.mapView
                  print("끝")
                  dispatchGroup.leave()
                })
              }
              
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
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
      }
    }
  }
  func map(){
    //    //        print(selectPlaceInfo)
    ////    self.navigationItem.title =  selectPlaceInfo.title
    navView.setTitle(title: selectPlaceInfo.title)
    //    let camera = GMSCameraPosition.camera(withLatitude:selectPlaceInfo.location!.latitude, longitude: selectPlaceInfo.location!.longitude, zoom: 15)
    //    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    //    //        view = mapView
    //
    //    // Creates a marker in the center of the map.
    //    let marker = GMSMarker()
    //    // set custom color
    //    marker.icon = GMSMarker.markerImage(with: myColor ?? #colorLiteral(red: 0.8544613487, green: 0.4699537418, blue: 0.4763622019, alpha: 1))
    //    marker.position = CLLocationCoordinate2D(latitude: (selectPlaceInfo.location?.latitude)! , longitude: (selectPlaceInfo.location?.longitude)!)
    //    marker.title = selectPlaceInfo.title
    //    marker.snippet = selectPlaceInfo.address
    //    marker.map = mapView
    //    mapView.selectedMarker = marker
    DispatchQueue.main.async {
      let position = CLLocationCoordinate2D(latitude: (self.selectPlaceInfo.location?.latitude)! , longitude: (self.selectPlaceInfo.location?.longitude)!)
      let marker = GMSMarker(position: position)
      self.mapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
      marker.title = self.selectPlaceInfo.title
      marker.snippet = self.selectPlaceInfo.address
      marker.map = self.mapView
    }
    
  }
  
}

extension AddTripCheckMapViewController {
  @objc func popViewController() {
    self.navigationController?.popViewController(animated: true)
  }
  @objc func nextEvent(){
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
      let countryRealmDB = countryRealm()
      countryRealmDB.city = selectPlaceInfo.address
      countryRealmDB.country = selectPlaceInfo.title
      countryRealmDB.latitude = (selectPlaceInfo.location?.latitude)!
      countryRealmDB.longitude = (selectPlaceInfo.location?.longitude)!
      let calenderVC = AddTripDateViewController()
      calenderVC.saveCountryRealmData = countryRealmDB
      self.navigationController?.pushViewController( calenderVC, animated: true)
    }
  }
}
