//
//  ViewController.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 9/23/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var startLocation:String?
    var endLocation:String?

    //MARK: Properties

    @IBOutlet weak var currentMapView: MKMapView!
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(false)
        currentMapView.delegate = self
        currentMapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        FirebaseApp.configure()
        //TODO: If app previously not given location permission, would crash here. Will be solved when multiple views
        //are implemented.
        if startLocation == nil {
            let start:MKMapItem = MKMapItem(placemark:MKPlacemark(coordinate: locationManager.location!.coordinate))
        } else {
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = startLocation!
            let startSearch = MKLocalSearch(request)
            startSearch.start
            let start:MKMapItem = MKMapItem(placemark:MKPlacemark(coordinate: locationManager.location!.coordinate))
        }
        let end:MKMapItem = MKMapItem(placemark:MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 45.3, longitude: -93.2)))
        APIManager(map:currentMapView,start:start,end:end)
    }
    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    
    //MARK: Actions
    /*@IBAction func search(_ sender: UIButton) {
        if (startTextField.text != nil && endTextField.text != nil){
            geocoder.geocodeAddressString(startTextField.text!)
        }
    }*/
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func mapViewWillStartLoadingMap(_ currentMapView:MKMapView ){
        
    }
    
    func mapViewDidFinishLoadingMap(_ currentMapView: MKMapView) {
    }
    
    func mapView(_ currentMapView: MKMapView, didAdd:[MKOverlayRenderer]){
        
    }
    
    func mapView(_ currentMapView:MKMapView,didSelect:MKAnnotationView){
        //TODO: Find nearest transit node
        //TODO: Calculate drive to transit node
        //TODO: Calculate transit from transit node to transit node
        //TODO: Calculate drive from finalnode to final
        if (didSelect.annotation is TransitNode){
            let transitNode = didSelect.annotation as! TransitNode
            let directionsQuery = DirectionsQuery(start:MKMapItem.forCurrentLocation(),end:transitNode.getMapItem(),
                    formOfTransportation: MKDirectionsTransportType.automobile)
            directionsQuery.addToMap(map: currentMapView)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            return RouteRenderer(line: overlay as! MKPolyline)
        }
        return MKOverlayRenderer()
    }
}

