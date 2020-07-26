//
//  placeSearchViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 17/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

import IQKeyboardManagerSwift
import SnapKit

// 도시 검색 Search View Controller
enum SearchType {
  case city
  case place
}

class AddTripViewController: UIViewController {
  // 앞 View 에서 전달 받는 데이터
  var category = [["장소 검색","검색하고 싶은 장소를 검색하세요."],["도시 검색","검색하고 싶은 도시를 입력하세요."]]

  var searchType: SearchType
    var trip: Trip
    let day: Int

  var tablePlaceInfo = Array<PlaceInfo>()
  var fetcher: GMSAutocompleteFetcher?

  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setLeftIcon(image: UIImage(named: "back")!)
    view.dismissBtn.addTarget(self, action: #selector(popEvent), for: .touchUpInside)
    return view
  }()

  lazy var searchView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 12
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor.grey03.cgColor
    view.layer.zeplinStyleShadows(color: .black, alpha: 0.1, x: 0, y: 3, blur: 20, spread: 0)
    return view
  }()

  lazy var searchImg: UIImageView = {
    let image = UIImageView()
    image.contentMode = .scaleAspectFit
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
    image.tintColor = .grey03
    return image
  }()

  lazy var textField: UITextField = {
    let text = UITextField()
    text.clearButtonMode = UITextField.ViewMode.whileEditing
    text.addTarget(self, action: #selector(textEdit), for: .editingChanged)
    text.addTarget(self, action: #selector(textEditBigin), for: .editingDidBegin)
    text.addTarget(self, action: #selector(textEditEnd), for: .editingDidEnd)
    text.tintColor = .black
    text.textColor = .black
    text.attributedPlaceholder = NSAttributedString(
      string: "어디로 여행을 가시나요?",
      attributes: [NSAttributedString.Key.foregroundColor:
        UIColor.grey03])
    text.translatesAutoresizingMaskIntoConstraints = false
    //    text.placeholder = "어디로 여행을 가시나요?"
    return text
  }()

  lazy var tableView: UITableView = {
    let table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.separatorStyle = .none
    table.backgroundColor = UIColor.white
    table.register(PlaceSearchTableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()

  lazy var containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white
    return view
  }()

    init(searchType: SearchType, trip: Trip, day: Int) {
        self.searchType = searchType
        self.day = day
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    IQKeyboardManager.shared.enable = false
    switch searchType {
    case .city:
      navView.setTitle(title: "여행 도시 검색")
    case .place:
      navView.setTitle(title: "여행 장소 검색")
    }
    initView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.view.backgroundColor = UIColor.white
    tableView.reloadData()
    if let customTabBarController = self.tabBarController as? TabbarViewController {
      customTabBarController.hideTabBarAnimated(hide: false, completion: nil)
    }
  }

  func initView(){
    self.view.backgroundColor = .white
    view.addSubview(navView)
    view.addSubview(searchView)
    searchView.addSubview(searchImg)
    searchView.addSubview(textField)
    view.addSubview(tableView)
    view.bringSubviewToFront(searchView)
    navView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(44)
    }
    searchView.snp.makeConstraints{ make in
      make.top.equalTo(navView.snp.bottom).offset(20)
      make.left.equalTo(view.snp.left).offset(16)
      make.right.equalTo(view.snp.right).offset(-16)
      make.height.equalTo(38)
    }
    searchImg.snp.makeConstraints{ make in
      make.centerY.equalTo(searchView.snp.centerY)
      make.left.equalTo(searchView.snp.left).offset(16)
      make.height.equalTo(24)
      make.width.equalTo(24)
    }
    textField.snp.makeConstraints{ make in
      make.centerY.equalTo(searchView.snp.centerY)
      make.left.equalTo(searchImg.snp.right).offset(10)
      make.height.equalTo(24)
      make.right.equalTo(searchView.snp.right).offset(-16)
    }
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    // Set bounds to inner-west Sydney Australia.
    let neBoundsCorner = CLLocationCoordinate2D(latitude: -33.843366,
                                                longitude: 151.134002)
    let swBoundsCorner = CLLocationCoordinate2D(latitude: -33.875725,
                                                longitude: 151.200349)
    let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                     coordinate: swBoundsCorner)
    
    // Set up the autocomplete filter.
    let filter = GMSAutocompleteFilter()
    switch searchType {
    case .city:
      filter.type = .city
    case .place:
      filter.type = .establishment
    }

    // Create the fetcher.
    fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
    fetcher?.delegate = self
    
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension AddTripViewController {
  @objc func textEditBigin() {
    textField.placeholder = ""
    UIView.animate(withDuration: 0.6,
                   delay: 0,
                   options: [.curveEaseOut],
                   animations: { [weak self] in
                    self?.textField.tintColor = .black
                    self?.textField.textColor = .black
                    self?.searchView.layer.borderColor = UIColor.black.cgColor
                    self?.searchImg.tintColor = .black
      }, completion: nil)
  }
  @objc func textEditEnd(){
    if textField.text == "" {
      textField.placeholder = "어디로 여행을 가시나요?"
      UIView.animate(withDuration: 0.6,
                     delay: 0,
                     options: [.curveEaseOut],
                     animations: { [weak self] in
                      self?.textField.tintColor = .grey03
                      self?.textField.textColor = .black
                      self?.searchView.layer.borderColor = UIColor.grey03.cgColor
                      self?.searchImg.tintColor = .grey03
        }, completion: nil)
    }
  }
  @objc func textEdit(){
    fetcher?.sourceTextHasChanged(textField.text)
  }
}

extension AddTripViewController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tablePlaceInfo.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaceSearchTableViewCell
    cell.titleLabel.text = tablePlaceInfo[indexPath.row].title
    cell.addressLabel.text = tablePlaceInfo[indexPath.row].address
    
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let mapData = tablePlaceInfo[safe: indexPath.row] else {
        return
    }
    let newPlan = Plan(
        address: mapData.address,
        title: mapData.title,
        coordinate: Coordinate(latitude: mapData.location?.latitude ?? 0, longitude: mapData.location?.longitude ?? 0),
        displayOrder: Int16(trip.planByDays[day].plans.count),
        identifier: UUID()
    )
    let googleMapVC = AddTripCheckMapViewController(
        searchType: searchType,
        trip: trip,
        plan: newPlan,
        day: day
    )
    self.navigationController?.pushViewController(googleMapVC, animated: true)
  }
  
}

extension AddTripViewController: UITableViewDataSource {
  
}

extension AddTripViewController {
  @objc func popEvent(){
    self.navigationController?.popViewController(animated: true)

  }
}

extension AddTripViewController: UISearchBarDelegate{
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.navigationController?.popViewController(animated: true)
  }
}

extension AddTripViewController: GMSAutocompleteFetcherDelegate {
  
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
    tablePlaceInfo.removeAll()
    let dispatchGroup = DispatchGroup()
    
    for prediction in predictions {
      
      var new_data = PlaceInfo()
      new_data.title = prediction.attributedPrimaryText.string
      new_data.address = prediction.attributedSecondaryText?.string ?? ""
      
      let placeID = prediction.placeID
      let placeClient = GMSPlacesClient()
      dispatchGroup.enter()
      placeClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
        if let error = error {
          print("lookup place id query error: \(error.localizedDescription)")
          dispatchGroup.leave()
          return
        }
        
        guard let place = place else {
          print("No place details for \(placeID)")
          dispatchGroup.leave()
          return
        }
        
        new_data.location = place.coordinate
        new_data.placeID = place.placeID ?? ""
        self.tablePlaceInfo.append(new_data)
        dispatchGroup.leave()
        print(self.tablePlaceInfo)
      })
    }
    dispatchGroup.notify(queue: .main) {
      self.tableView.reloadData()
    }
  }
  
  func didFailAutocompleteWithError(_ error: Error) {
    //resultText?.text = error.localizedDescription
    print(error.localizedDescription)
  }
}
