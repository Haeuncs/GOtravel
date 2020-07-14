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

class AddTripCheckMapViewController: UIViewController {

  let searchType: SearchType
  let realm = try! Realm()

  // 장소 검색에서 VC에게 전달받는 변수들
  var selectPlaceInfo = PlaceInfo()
  var dayRealmDB = dayRealm()

  // path의 VC에서 받는 city 네임
  var navTitle = ""

  lazy var  mapView: GMSMapView = {
    let map = GMSMapView()
    map.translatesAutoresizingMaskIntoConstraints = false
    return map
  }()

  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setLeftIcon(image: UIImage(named: "back")!)
    view.dismissBtn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
    return view
  }()

  lazy var textLabelInMarker: UILabel = {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    label.text = "1"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
    label.textColor = DefaullStyle.markerTextColor
    label.clipsToBounds = true
    label.translatesAutoresizingMaskIntoConstraints = false

    return label
  }()

  init(searchType: SearchType) {
    self.searchType = searchType
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
      navView.setButtonTitle(title: "다음")
      navView.actionBtn.addTarget(self, action: #selector(nextEvent), for: .touchUpInside)
      map()
      initView()
  }

  override func viewWillAppear(_ animated: Bool) {
    if let customTabBarController = self.tabBarController as? TabbarViewController {
      customTabBarController.hideTabBarAnimated(hide: false, completion: nil)
    }    
  }

  func initView(){
    view.backgroundColor = .white
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

  func customMarker(color: UIColor) -> UIImage {
    let customMarker = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    customMarker.layer.cornerRadius = 40 / 2
    customMarker.layer.borderWidth = 1.5
    customMarker.layer.borderColor = DefaullStyle.markerTextColor.cgColor
    customMarker.backgroundColor = color
    customMarker.translatesAutoresizingMaskIntoConstraints = false
    customMarker.addSubview(textLabelInMarker)
    textLabelInMarker.centerXAnchor.constraint(equalTo: customMarker.centerXAnchor).isActive = true
    textLabelInMarker.centerYAnchor.constraint(equalTo: customMarker.centerYAnchor).isActive = true
    textLabelInMarker.widthAnchor.constraint(equalTo: customMarker.widthAnchor).isActive = true
    textLabelInMarker.heightAnchor.constraint(equalTo: customMarker.heightAnchor).isActive = true
    
    return customMarker.asImage()
  }

  func draw_marker(i: detailRealm, index: Int) {
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
  }

  func characterToCgfloat(str: String) -> CGFloat {
    let n = NumberFormatter().number(from: str)
    return n as! CGFloat
  }
  
  // path 선택 시
  func map() {
    navView.setTitle(title: selectPlaceInfo.title)

    guard let latitude = self.selectPlaceInfo.location?.latitude,
      let longitude = self.selectPlaceInfo.location?.longitude else {
        return
    }
    let position = CLLocationCoordinate2D(
      latitude: latitude,
      longitude: longitude
    )
    let marker = GMSMarker(position: position)
    marker.title = self.selectPlaceInfo.title
    marker.snippet = self.selectPlaceInfo.address
    marker.map = self.mapView

    DispatchQueue.main.async {
      self.mapView.camera = GMSCameraPosition(target: position, zoom: 15, bearing: 0, viewingAngle: 0)
    }
  }
}

extension AddTripCheckMapViewController {
  @objc func popViewController() {
    self.navigationController?.popViewController(animated: true)
  }

  @objc func nextEvent() {
    if searchType == .city {
      let countryRealmDB = countryRealm()
      countryRealmDB.city = selectPlaceInfo.address
      countryRealmDB.country = selectPlaceInfo.title
      countryRealmDB.latitude = (selectPlaceInfo.location?.latitude)!
      countryRealmDB.longitude = (selectPlaceInfo.location?.longitude)!
      let calenderVC = AddTripDateViewController()
      calenderVC.saveCountryRealmData = countryRealmDB
      self.navigationController?.pushViewController( calenderVC, animated: true)
    }
    else {
      let detailRealmDB = detailRealm()
      detailRealmDB.title = selectPlaceInfo.title
      detailRealmDB.address = selectPlaceInfo.address
      detailRealmDB.longitude = (selectPlaceInfo.location?.longitude)!
      detailRealmDB.latitude = (selectPlaceInfo.location?.latitude)!
      detailRealmDB.color = "default"
      debugPrint(detailRealmDB)
      debugPrint(dayRealmDB.detailList)
      try! realm.write {
        dayRealmDB.detailList.append(detailRealmDB)
      }
      self.navigationController?.popToRootViewController(animated: true)
    }
  }
}
