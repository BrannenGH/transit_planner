//
//  LocationQuery.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/29/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

class LocationQuery: NSObject, CLLocationManagerDelegate{
    let locationManager = CLLocationManager()
    let start: String?
    let end: String?
    let apiManager: APIManager
    var startResult: [MKMapItem]?
    var startCoordinate: CLLocation?
    var endResult: [MKMapItem]?
    
    init(start:String?, end:String?,apiManager:APIManager){
        print("Start location \(start ?? "None")")
        print("End location \(end!)")
        self.start = start
        self.end = end
        self.apiManager = apiManager
        super.init()
        startRequest()
    }
    
    private func startRequest(){
        let request = MKLocalSearchRequest()
        if start == nil || start! == ""{
            locationManager.requestWhenInUseAuthorization()
            startCoordinate = locationManager.location
        } else {
            request.naturalLanguageQuery = start!
            let startSearch = MKLocalSearch(request: request)
            startSearch.start(completionHandler: startLookup)
        }
    }
    
    private func startLookup(response:MKLocalSearchResponse?,error:Error?){
        if error == nil {
            startResult = response?.mapItems
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
            finish()
        } else {
            print(error!)
        }
    }
    
    private func finish(){
        if startResult != nil {
            apiManager.downloadNodes(start: startResult![0].placemark.location!, end: endResult![0].placemark.location!)
        } else {
            apiManager.downloadNodes(start: startCoordinate!, end: endResult![0].placemark.location!)
        }
    }
}
