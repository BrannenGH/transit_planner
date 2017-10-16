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

    //MARK: Properties
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
        
        let location1 = TransitNode("Northtown", 45.12697,-93.264415)
        let location2 = TransitNode("Foley Park and Ride", 45.142311, -93.285325)
        currentMapView.setRegion(MKCoordinateRegion(center: location1.getCoordinates(),span: MKCoordinateSpan(latitudeDelta:0.10,longitudeDelta:0.10)), animated: true)
        
        currentMapView.showAnnotations([location1,location2], animated: false)
    }
    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    
    //MARK: Actions
    @IBAction func search(_ sender: UIButton) {
        headerLabel.text = startTextField.text!
    }
    
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
        if let transitNode = didSelect.annotation as? TransitNode {
            let request = MKDirectionsRequest()
            request.source = MKMapItem.forCurrentLocation()
            request.destination = transitNode.getMapItem()
            request.requestsAlternateRoutes = false
            
            let directions = MKDirections(request: request)
            
            
            directions.calculate(completionHandler: {(response,error) in
                if error != nil {
                    print("ERROR")
                } else {
                    for route in response!.routes {
                        let currentLine:MKPolyline = route.polyline
                        currentMapView.add(currentLine, level: MKOverlayLevel.aboveRoads)
                        for step in route.steps {
                            print(step.instructions)
                        }
                    }
                }
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.blue
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 1
            return renderer
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        }
        
        return MKOverlayRenderer()
    }
}

