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
    let geocoder = CLGeocoder()
    var startLocation:String?
    var endLocation:String?
    var startTransportationType: MKDirectionsTransportType = MKDirectionsTransportType.any
    var endTransportationType: MKDirectionsTransportType = MKDirectionsTransportType.any
    var selectedNodes = [TransitNode]()
    var previousNode: TransitNode?
    var apiManager:APIManager?


    //MARK: Properties

    @IBOutlet weak var currentMapView: MKMapView!
    
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(false)
        currentMapView.delegate = self
        currentMapView.showsUserLocation = true
        FirebaseApp.configure()
        self.apiManager = APIManager(map:currentMapView,start:startLocation,end:endLocation)
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
        if (previousNode == nil){
            previousNode = (didSelect.annotation as! TransitNode)
            apiManager!.getDirections(start:apiManager!.getStart(),end:previousNode!.getMapItem(), formOfTransport: startTransportationType, map: currentMapView)
        } else {
            let secondNode: TransitNode = didSelect.annotation as! TransitNode
            apiManager!.getDirections(start: previousNode!.getMapItem(), end: secondNode.getMapItem(), formOfTransport: MKDirectionsTransportType.transit, map: currentMapView)
            apiManager!.getDirections(start: secondNode.getMapItem(), end: apiManager!.getEnd(), formOfTransport: endTransportationType, map: currentMapView)
        }
        /*if (didSelect.annotation is TransitNode){
            let transitNode = didSelect.annotation as! TransitNode
            let directionsQuery = DirectionsQuery(start:MKMapItem.forCurrentLocation(),end:transitNode.getMapItem(),
                    formOfTransportation: MKDirectionsTransportType.automobile)
            directionsQuery.addToMap(map: currentMapView)
        }*/
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            return RouteRenderer(line: overlay as! MKPolyline)
        }
        return MKOverlayRenderer()
    }
    
    func setStartType(_ start:String){
        startTransportationType = strToTransportation(name: start)
    }
    
    func setEndType(_ end:String){
        endTransportationType = strToTransportation(name: end)
    }
    
    private func strToTransportation(name:String) -> MKDirectionsTransportType {
        switch name {
            case "Driving":
                return MKDirectionsTransportType.automobile
            case "Walking":
                return MKDirectionsTransportType.walking
            default:
                return MKDirectionsTransportType.any
        }
    }
}

