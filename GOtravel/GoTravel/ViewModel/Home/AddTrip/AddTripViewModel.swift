//
//  AddTripViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/18.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import GooglePlaces
import RxSwift
import RxCocoa

class AddTripViewModel: NSObject, GMSAutocompleteFetcherDelegate {
  let disposeBag = DisposeBag()
  let places: BehaviorRelay<[PlaceInfo]> = BehaviorRelay(value: [])
  let searchText: BehaviorRelay<String> = BehaviorRelay(value: "")
  
  var fetcher: GMSAutocompleteFetcher?
  var selectedPlace: BehaviorRelay<PlaceInfo?> = BehaviorRelay(value: nil)
  var selectedIndex: BehaviorRelay<Int?> = BehaviorRelay(value: nil)
  
  override init() {
    super.init()
    // Set bounds to inner-west Sydney Australia.
    let neBoundsCorner = CLLocationCoordinate2D(latitude: -33.843366,
                                                longitude: 151.134002)
    let swBoundsCorner = CLLocationCoordinate2D(latitude: -33.875725,
                                                longitude: 151.200349)
    let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                     coordinate: swBoundsCorner)
    
    // Set up the autocomplete filter.
    let filter = GMSAutocompleteFilter()
    // 지역 검색
    filter.type = .city
    
    // Create the fetcher.
    fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
    fetcher?.delegate = self
    
    searchText.asObservable().subscribe(onNext: { [weak self](str) in
      self?.fetcher?.sourceTextHasChanged(str)
      print(str)
    })
    .disposed(by: disposeBag)
  }
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
    var placeInfo: [PlaceInfo] = []
    let dispatchGroup = DispatchGroup()
    
    for prediction in predictions {
      
      var new_data = PlaceInfo()
      new_data.title = prediction.attributedPrimaryText.string
      new_data.address = prediction.attributedSecondaryText?.string ?? ""
      
      let placeID =  prediction.placeID
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
        placeInfo.append(new_data)
        dispatchGroup.leave()
      })
    }
    dispatchGroup.notify(queue:.main) {
      self.places.accept(placeInfo)
      //      self.tableView.reloadData()
    }
  }
  
  func didFailAutocompleteWithError(_ error: Error) {
    print(error.localizedDescription)
  }
  
  
}
//extension AddTripViewModel: NSObject, GMSAutocompleteFetcherDelegate {
//  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
//    var placeInfo: [PlaceInfo] = []
//    let dispatchGroup = DispatchGroup()
//
//    for prediction in predictions {
//
//      var new_data = PlaceInfo()
//      new_data.title = prediction.attributedPrimaryText.string
//      new_data.address = prediction.attributedSecondaryText?.string ?? ""
//
//      let placeID =  prediction.placeID
//      let placeClient = GMSPlacesClient()
//      dispatchGroup.enter()
//      placeClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
//        if let error = error {
//          print("lookup place id query error: \(error.localizedDescription)")
//          dispatchGroup.leave()
//          return
//        }
//
//        guard let place = place else {
//          print("No place details for \(placeID)")
//          dispatchGroup.leave()
//          return
//        }
//
//        new_data.location = place.coordinate
//        new_data.placeID = place.placeID ?? ""
//        placeInfo.append(new_data)
//        dispatchGroup.leave()
//      })
//    }
//    dispatchGroup.notify(queue:.main) {
////      self.places.accept()
//      //      self.tableView.reloadData()
//    }
//  }
//
//  func didFailAutocompleteWithError(_ error: Error) {
//    print(error.localizedDescription)
//  }
//
//}
