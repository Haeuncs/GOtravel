//
//  searchTravelLocationViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 10/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class searchTravelLocationViewController:UIViewController{

    
    @IBOutlet var tableView: UITableView!
    private enum SegueID: String {
        case showDetail
        case showAll
    }
    
    private enum CellReuseID: String {
        case resultCell
    }
    
    private var places: [MKMapItem]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var suggestionController: SuggestionsTableTableViewController!
    
    private var searchController: UISearchController!
    
    @IBOutlet private var locationManager: LocationManager!

    private var locationManagerObserver: NSKeyValueObservation?
    
    private var foregroundRestorationObserver: NSObjectProtocol?
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
    
    private var boundingRegion: MKCoordinateRegion?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        suggestionController = SuggestionsTableTableViewController()
        suggestionController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: suggestionController)
        searchController.searchResultsUpdater = suggestionController
        
//        searchController.searchBar.isUserInteractionEnabled = false
//        searchController.searchBar.alpha = 0.5

        self.searchController.searchBar.isUserInteractionEnabled = true
        self.searchController.searchBar.alpha = 1.0

//        locationManagerObserver = locationManager.observe(\LocationManager.currentLocation) { [weak self] (_, _) in
//            if let location = self?.locationManager.currentLocation {
//                // This sample only searches for nearby locations, defined by the device's location. Once the current location is
//                // determined, enable the search functionality.
//                
//                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
//                self?.suggestionController.searchCompleter.region = region
//                self?.boundingRegion = region
//                
//                self?.searchController.searchBar.isUserInteractionEnabled = true
//                self?.searchController.searchBar.alpha = 1.0
//                
//                self?.tableView.reloadData()
//            }
//        }
        
//        let name = UIApplication.willEnterForegroundNotification
//        foregroundRestorationObserver = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: { [weak self] (_) in
//            // Get a new location when returning from Settings to enable location services.
//            self?.locationManager.requestLocation()
//        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "여행"
        // remove push black something...;0_0
        self.navigationController?.view.backgroundColor = .white

        self.navigationController?.navigationBar.tintColor = .white
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        
        // Keep the search bar visible at all times.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        /*
         Search is presenting a view controller, and needs the presentation context to be defined by a controller in the
         presented view controller hierarchy.
         */
        definesPresentationContext = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        locationManager.requestLocation()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("run")
//        guard let mapViewController = segue.destination as? MapViewController else {
//            print("retest")
//            return
//        }
//
//        if segue.identifier == "test" {
//            print("test")
//            // Get the single item.
//            guard let selectedItemPath = tableView.indexPathForSelectedRow, let mapItem = places?[selectedItemPath.row] else { return }
//            print(mapItem)
//            // Pass the new bounding region to the map destination view controller and center it on the single placemark.
//            var region = boundingRegion
//            region?.center = mapItem.placemark.coordinate
//            mapViewController.boundingRegion = region
//            print(region)
//            // Pass the individual place to our map destination view controller.
//            mapViewController.mapItems = [mapItem]
//        } else if segue.identifier == SegueID.showAll.rawValue {
//
//            // Pass the new bounding region to the map destination view controller.
//            mapViewController.boundingRegion = boundingRegion
//
//            // Pass the list of places found to our map destination view controller.
//            mapViewController.mapItems = places
//        }
//    }
    
    /// - Parameter suggestedCompletion: A search completion provided by `MKLocalSearchCompleter` when tapping on a search completion table row
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    /// - Parameter queryString: A search string from the text the user entered into `UISearchBar`
    private func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    /// - Tag: SearchRequest
    private func search(using searchRequest: MKLocalSearch.Request) {
        // Confine the map search area to an area around the user's current location.
        if let region = boundingRegion {
            searchRequest.region = region
            print(region)
        }
        
        // Use the network activity indicator as a hint to the user that a search is in progress.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [weak self] (response, error) in
            guard error == nil else {
//                self?.displaySearchError(error)
//                print("error")
                return
            }
//            print(response?.mapItems)

            self?.places = response?.mapItems
            
            // Used when setting the map's region in `prepareForSegue`.
            self?.boundingRegion = response?.boundingRegion
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            let mapItem = self?.places?[0]
            // Pass the new bounding region to the map destination view controller and center it on the single placemark.
            var region = self?.boundingRegion
            region?.center = mapItem!.placemark.coordinate
            
            let uvc = self!.storyboard!.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                        
            uvc.boundingRegion = region
            // Pass the individual place to our map destination view controller.
            uvc.mapItems = [mapItem] as! [MKMapItem]
            
            print(mapItem)
            print(self!.boundingRegion)

            self!.navigationController?.pushViewController(uvc, animated: true)
            

        }
        

    }
    
    private func displaySearchError(_ error: Error?) {
//        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
//            let alertController = UIAlertController(title: "Could not find any places.", message: errorString, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alertController, animated: true, completion: nil)
//        }
    }
}

extension searchTravelLocationViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard locationManager.currentLocation != nil else { return 1 }
        return places?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard locationManager.currentLocation != nil else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = NSLocalizedString("LOCATION_SERVICES_WAITING", comment: "Waiting for location table cell")
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            cell.accessoryView = spinner
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseID.resultCell.rawValue, for: indexPath)
        
        if let mapItem = places?[indexPath.row] {
            cell.textLabel?.text = mapItem.name
            cell.detailTextLabel?.text = mapItem.placemark.formattedAddress
        }
        
        return cell
    }
}

extension searchTravelLocationViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell0")
        tableView.deselectRow(at: indexPath, animated: true)
        print("cell")
        DispatchQueue.global().sync{

            if let suggestion = suggestionController.completerResults?[indexPath.row] {
                    search(for: suggestion)
            }
        }
////        guard locationManager.currentLocation != nil else { return }
//
//        if tableView == suggestionController.tableView, let suggestion = suggestionController.completerResults?[indexPath.row] {
//            searchController.isActive = false
//            searchController.searchBar.text = suggestion.title
//            search(for: suggestion)
//        }

//        let suggestion = suggestionController.completerResults?[indexPath.row]
//        search(for: suggestion!)
//        print(places![indexPath.row])
//        print(places?.count)
//        self.performSegue(withIdentifier: "test", sender: nil)
//        let uvc = self.storyboard!.instantiateViewController(withIdentifier: "MapViewController")
//        self.navigationController?.pushViewController(uvc, animated: true)

    }
}

extension searchTravelLocationViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search")
        searchBar.resignFirstResponder()
//        dismiss(animated: true, completion: nil)
        
        // The user tapped search on the `UISearchBar` or on the keyboard. Since they didn't
        // select a row with a suggested completion, run the search with the query text in the search field.
        search(for: searchBar.text)
    }
}
