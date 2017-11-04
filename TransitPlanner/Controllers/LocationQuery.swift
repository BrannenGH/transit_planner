//
//  LocationQuery.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/29/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

class LocationQuery{
    let locationManager:CLLocationManager
    let start: String?
    let end: String?
    let completionHandler: ([MKMapItem]?,[MKMapItem]?) -> ()
    var startResult: [MKMapItem]?
    var endResult: [MKMapItem]?
    
    
    init(start:String?, end:String?, locationManager:CLLocationManager, completionHandler:@escaping (_ startResult:[MKMapItem]?,_ endResult:[MKMapItem]?) -> ()){
        print("Start location \(start ?? "None")")
        print("End location \(end!)")
        self.locationManager = locationManager
        self.start = start
        self.end = end
        self.completionHandler = completionHandler
        startRequest()
    }
    
    private func startRequest(){
        let request = MKLocalSearchRequest()
        if start == nil || start! == ""{
            locationManager.requestWhenInUseAuthorization()
            startResult = [MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location!.coordinate))]
        } else {
            request.naturalLanguageQuery = start!
            let startSearch = MKLocalSearch(request: request)
            startSearch.start(completionHandler: startLookup)
        }
    }
    
    private func startLookup(response:MKLocalSearchResponse?,error:Error?){
        if error == nil {
            startResult = response!.mapItems
            endRequest()
        } else {
            print(error!)
        }
    }
    
    private func endRequest(){
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = end!
        let endSearch = MKLocalSearch(request: request)
        endSearch.start(completionHandler: endLookup)
    }
    
    private func endLookup(response:MKLocalSearchResponse?,error:Error?){
        if error == nil {
            endResult = response!.mapItems
            completionHandler(startResult,endResult)
        } else {
            print(error!)
        }
    }
    
}
