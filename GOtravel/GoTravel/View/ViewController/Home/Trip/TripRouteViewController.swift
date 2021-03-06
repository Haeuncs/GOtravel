//
//  TripRouteViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/14.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import GoogleMaps


class TripRouteViewController: UIViewController {
  let day: Int
  let trip: Trip
  let plans: [Plan]
  var routePaths: [GMSPath] = []
  var routeLocationCoordinate: [CLLocationCoordinate2D] = []

  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setButtonTitle(title: "")
    view.setLeftIcon(image: UIImage(named: "back")!)
    view.dismissBtn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
    return view
  }()

  lazy var  mapView: GMSMapView = {
    let map = GMSMapView()
    map.translatesAutoresizingMaskIntoConstraints = false
    return map
  }()

  lazy var textLabelInMarker: UILabel = {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
    label.textColor = DefaullStyle.markerTextColor
    label.clipsToBounds = true
    label.translatesAutoresizingMaskIntoConstraints = false

    return label
  }()

    init(day: Int, trip: Trip, plans: [Plan]) {
    self.day = day
    self.trip = trip
    self.plans = plans
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navView.setTitle(title: String(day + 1) + "일차 경로")
    configureMap()
    configureLayout()
    drawTripRoute()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let customTabBarController = self.tabBarController as? TabbarViewController {
      customTabBarController.hideTabBarAnimated(hide: false, completion: nil)
    }
  }

  func configureLayout(){
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

  func configureMap() {
    let camera = GMSCameraPosition.camera(
        withLatitude: trip.coordinate.latitude,
      longitude: trip.coordinate.longitude,
      zoom: 11.5
    )
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
  }

  @objc func popViewController() {
    self.navigationController?.popViewController(animated: true)
  }

  func drawMarker(plan: Plan, index: Int) {
    let marker = GMSMarker()
    var colorUIColor = #colorLiteral(red: 0.5372078419, green: 0.5372861624, blue: 0.5371831059, alpha: 1)
    if let colorStr = plan.pinColor {
        colorUIColor = colorStr
    }
    textLabelInMarker.text = String(index)
    marker.icon = customMarker(color: colorUIColor)
    marker.position = CLLocationCoordinate2D(
        latitude: plan.coordinate.latitude,
        longitude: plan.coordinate.longitude
    )
    marker.title = plan.title
    marker.snippet = plan.address
    marker.map = self.mapView
    routeLocationCoordinate.append(marker.position)
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

  func drawTripRoute() {
    guard plans.count > 1 else {
        drawMarker(plan: plans.first!, index: 1)
      return
    }

    // 데이터 다 계산한 후에 화면 업데이트 하도록 디스패치 그룹 만들어줌
    let dispatchGroup = DispatchGroup()
    for i in 0 ..< plans.count - 1 {
      dispatchGroup.enter()
      //0,1,2
        let origin = "\(plans[i].coordinate.latitude),\(plans[i].coordinate.longitude)"
      drawMarker(plan: plans[i],index: i + 1)
        let destination = "\(plans[i + 1].coordinate.latitude),\(plans[i + 1].coordinate.longitude)"
      drawMarker(plan: plans[i + 1],index: i + 2)
      guard let googleMapAPIKey = Singleton.shared.googleMapAPIKey else { return }
      let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=transit&key=" + googleMapAPIKey

      let url = URL(string: urlString)

      URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in
        guard error == nil else {
          dispatchGroup.leave()
          return
        }
        do{
          let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
          let routes = json["routes"] as! NSArray
          let state = json["status"]
          let error = json["error_message"]

          if state! as! String == "OK" {
            OperationQueue.main.addOperation({
              for route in routes {
                let routeOverviewPolyline: NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                let points = routeOverviewPolyline.object(forKey: "points")
                let path = GMSPath.init(fromEncodedPath: points! as! String)
                self.routePaths.append(path!)

                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                polyline.map = self.mapView

                dispatchGroup.leave()
              }
            })
          }
          else if state! as! String == "ZERO_RESULTS" {
            print("ZERO_RESULTS")
            OperationQueue.main.addOperation({
              let path = GMSMutablePath()
              let originCoordinate = CLLocationCoordinate2D(
                latitude: self.plans[i].coordinate.latitude,
                longitude: self.plans[i].coordinate.longitude
              )
              let destinationCoordinate = CLLocationCoordinate2D(
                latitude: self.plans[i + 1].coordinate.latitude,
                longitude: self.plans[i + 1].coordinate.longitude
              )
              path.add(originCoordinate)
              path.add(destinationCoordinate)

              self.routePaths.append(path)

              let polyline = GMSPolyline.init(path: path)
              polyline.strokeWidth = 4
              polyline.strokeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
              polyline.map = self.mapView
              print("끝")
              dispatchGroup.leave()
            })
          }
        } catch let error as NSError {
          print("error:\(error)")
          dispatchGroup.leave()
        }
      }).resume()
    }

    dispatchGroup.notify(queue: .main) {
      print("실행")
      var bounds = GMSCoordinateBounds()
      for loc in self.routeLocationCoordinate {
        bounds = bounds.includingCoordinate(loc)
      }
      self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
    }
  }
}
