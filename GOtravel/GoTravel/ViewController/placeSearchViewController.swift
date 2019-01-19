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
import RealmSwift

class placeSearchViewController : UIViewController {
    // 앞 View 에서 전달 받는 데이터
    var category = [["장소 검색","검색하고 싶은 장소를 검색하세요."],["도시 검색","검색하고 싶은 도시를 입력하세요."]]
    var categoryIndex = 0
    
    var countryRealmDB : countryRealm?
    var dayRealmDB  = dayRealm()
    
    private var searchController: UISearchController!
    private var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        //        table.layer.cornerRadius = 10
        //        table.layer.masksToBounds = true
        table.backgroundColor = UIColor.clear
        return table
    }()
    private var containerView : UIView = {
        let view = UIView()
        //        view.layer.backgroundColor = UIColor.red.cgColor
        //        view.layer.cornerRadius = 10
        //
        //        // border
        //        view.layer.borderWidth = 1.0
        //        view.layer.borderColor = UIColor.black.cgColor
        //
        //        // shadow
        //        view.layer.shadowColor = UIColor.black.cgColor
        //        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        //        view.layer.shadowOpacity = 0.7
        //        view.layer.shadowRadius = 4.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var tablePlaceInfo = Array<PlaceInfo>()
    //    var tableData=[String]()
    //    var secData = [String]()
    //    var Images = [UIImage]()
    var fetcher: GMSAutocompleteFetcher?
    var myBackgroundColor = UIColor()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //        self.view.backgroundColor = Style.bgColor
        self.navigationController?.view.backgroundColor = myBackgroundColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationBar.isTranslucent=false
        
        searchController = UISearchController(searchResultsController: nil)
        //        searchController.searchResultsUpdater = suggestionController
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        //        tableView = UITableView()
        tableView.register(placeSearchTableViewCell.self, forCellReuseIdentifier: "cell")
        
        containerView.addSubview(tableView)
        view.addSubview(containerView)
        
        self.navigationItem.title = category[categoryIndex][0]
        searchController.searchBar.placeholder = category[categoryIndex][1]

        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func initView(){
        let paddingSize = CGFloat(0)
        //        containerView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -paddingSize),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: paddingSize),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -paddingSize),
            
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            
            
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
        if categoryIndex == 0 {
            // 사업체 검색
            filter.type = .establishment
        }else{
            // 지역 검색
            filter.type = .city
        }
        
        // Create the fetcher.
        fetcher = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //        self.tableView.reloadData()
        
    }
}
extension placeSearchViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablePlaceInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! placeSearchTableViewCell
        cell.titleLabel.text = tablePlaceInfo[indexPath.row].title
        cell.addressLabel.text = tablePlaceInfo[indexPath.row].address
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let googleMapVC = googleMapViewController()
        print(tablePlaceInfo[indexPath.row])
        googleMapVC.selectPlaceInfo = tablePlaceInfo[indexPath.row]
        googleMapVC.myColor = myBackgroundColor
        googleMapVC.dayRealmDB = dayRealmDB
        googleMapVC.arrayMap = false
        self.navigationController?.pushViewController(googleMapVC, animated: true)
    }
    
}
extension placeSearchViewController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension placeSearchViewController: GMSAutocompleteFetcherDelegate {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        tablePlaceInfo.removeAll()
        let dispatchGroup = DispatchGroup()
        
        for prediction in predictions {
            
            var new_data = PlaceInfo()
            new_data.title = prediction.attributedPrimaryText.string
            new_data.address = prediction.attributedSecondaryText?.string ?? ""
            
            let placeID =  prediction.placeID ?? "ChIJV4k8_9UodTERU5KXbkYpSYs"
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
                print(place.coordinate)
                
                new_data.location = place.coordinate
                new_data.placeID = place.placeID
                self.tablePlaceInfo.append(new_data)
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue:.main) {
            self.tableView.reloadData()
        }
    }
    
    
    func didFailAutocompleteWithError(_ error: Error) {
        //resultText?.text = error.localizedDescription
        print(error.localizedDescription)
    }
    
    
}

extension placeSearchViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        print(searchController.searchBar.text!)
        fetcher?.sourceTextHasChanged(searchController.searchBar.text!)
    }
}
