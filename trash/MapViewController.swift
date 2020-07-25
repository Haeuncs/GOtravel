/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Secondary view controller used to display the map and found annotations.
*/

import UIKit
import MapKit


class MapViewController: UIViewController {
    let realm = try! Realm()
    
    private enum AnnotationReuseID: String {
        case pin
    }
    
//    @IBAction func undo(_ sender: Any) {
//
//        dismiss(animated: true, completion: nil)
//    }
    @IBOutlet private var mapView: MKMapView!
    var root: UINavigationController?
    var mapItems: [MKMapItem]?
    var boundingRegion: MKCoordinateRegion?

    @IBAction func yes(_ sender: Any) {
//        let map = mapItems?.first?.placemark
//        let countryData = countryRealm()
//        countryData.country = map?.country ?? ""
//        countryData.city = map?.locality ?? ""
//        countryData.longitude = map?.coordinate.longitude ?? 0.0
//        countryData.latitude = map?.coordinate.latitude ?? 0.0
        
        let vc = AddTripDateViewController()
        
//        vc.mapItem = mapItems?.first
//        vc.region = mapView.region
        
        self.navigationController?.pushViewController(vc, animated: true)
//        let uvc = self.storyboard!.instantiateViewController(withIdentifier: "mainViewController")
//        self.navigationController!.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        
        if let region = boundingRegion {
            mapView.region = region
        }
        mapView.delegate = self
        
        // Show the compass button in the navigation bar.
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        mapView.showsCompass = true // Use the compass in the navigation bar instead.
        
        // Make sure `MKPinAnnotationView` and the reuse identifier is recognized in this map view.
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationReuseID.pin.rawValue)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let mapItems = mapItems else { return }
        
        if mapItems.count == 1, let item = mapItems.first {
            title = item.name
        } else {
            title = NSLocalizedString("TITLE_ALL_PLACES", comment: "All Places view controller title")
        }
        
        // Turn the array of MKMapItem objects into an annotation with a title and URL that can be shown on the map.
        let annotations = mapItems.compactMap { (mapItem) -> PlaceAnnotation? in
            guard let coordinate = mapItem.placemark.location?.coordinate else { return nil }
            
            let annotation = PlaceAnnotation(coordinate: coordinate)
            annotation.title = mapItem.name
            annotation.url = mapItem.url
            annotation.subtitle = mapItem.placemark.title
            return annotation
        }
        mapView.addAnnotations(annotations)
        print(mapItems.first)
        print(mapItems.first?.placemark)
        print(mapItems.first?.placemark.country)
        print(mapItems.first?.placemark.administrativeArea)
        print(mapItems.first?.placemark.locality)
        print(mapItems.first?.placemark.subLocality)
        print(mapItems.first?.placemark.thoroughfare)
        print(mapItems.first?.placemark.subThoroughfare)
        print(mapItems.first?.placemark.subLocality)
        print(mapItems.first?.placemark.region)
        print(mapItems.first?.placemark.timeZone)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("Failed to load the map: \(error)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceAnnotation else { return nil }
        
        // Annotation views should be dequeued from a reuse queue to be efficent.
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationReuseID.pin.rawValue, for: annotation) as? MKMarkerAnnotationView
        view?.canShowCallout = true
        
        // If the annotation has a URL, add an extra Info button to the annotation so users can open the URL.
        if annotation.url != nil {
            let infoButton = UIButton(type: .detailDisclosure)
            view?.rightCalloutAccessoryView = infoButton
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PlaceAnnotation else { return }
        if let url = annotation.url {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
