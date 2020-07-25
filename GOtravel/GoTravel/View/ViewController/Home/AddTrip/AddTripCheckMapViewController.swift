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

import SnapKit

class AddTripCheckMapViewController: UIViewController {

  private let searchType: SearchType
    private let newPlan: Plan
    private var trip: Trip
    private let day: Int

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

    init(searchType: SearchType, trip: Trip, plan: Plan, day: Int) {
        self.searchType = searchType
        self.newPlan = plan
        self.day = day
        self.trip = trip
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

func characterToCgfloat(str: String) -> CGFloat {
    let n = NumberFormatter().number(from: str)
    return n as! CGFloat
  }
  
  // path 선택 시
  func map() {
    navView.setTitle(title: newPlan.title)

    let position = CLLocationCoordinate2D(
        latitude: newPlan.coordinate.latitude,
        longitude: newPlan.coordinate.longitude
    )
    let marker = GMSMarker(position: position)
    marker.title = newPlan.title
    marker.snippet = newPlan.address
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
        trip.planByDays[day].plans.append(newPlan)
        let result = TripCoreDataManager.shared.updateTrip(updateTrip: trip)
        print(result)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
