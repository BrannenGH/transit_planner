//
//  ViewController.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 9/23/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let locations:[TransitNode] = [
    TransitNode("Northtown", 45.12697,-93.264415),
    TransitNode("Foley Park and Ride", 45.142311, -93.285325)]

    //MARK: Properties
    @IBOutlet weak var destinationSelector: UISwitch!
    @IBOutlet weak var startSelector: UISwitch!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var currentMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTextField.delegate = self
        endTextField.delegate = self
        currentMapView.delegate = self
        currentMapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        
        currentMapView.setRegion(MKCoordinateRegion(center: locations[0].getCoordinates(),span: MKCoordinateSpan(latitudeDelta:0.10,longitudeDelta:0.10)), animated: true)
        
        currentMapView.showAnnotations(locations, animated: false)
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        headerLabel.text = textField.text
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

