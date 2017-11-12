//
//  LocationQuery.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/29/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

func LocationQuery(location:String, completionHandler:@escaping (_ result:[MKMapItem]?) -> ()){
    func startRequest(){
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = location
        let startSearch = MKLocalSearch(request: request)
        startSearch.start(completionHandler: receiveRequest)
    }
    
    func receiveRequest(response:MKLocalSearchResponse?,error:Error?){
        if response != nil {
            completionHandler(response!.mapItems)
        } else {
            print(error ?? "Error and Response nil")
        }
    }
    
    startRequest()
}
