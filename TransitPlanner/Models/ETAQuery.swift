//
//  ETAQuery.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 17-11-23
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

func ETAQuery(start:MKMapItem, end:MKMapItem, transport:MKDirectionsTransportType, completionHandler: @escaping (MKETAResponse?) -> ()){
    
    func startRequest(){
        let request = MKDirectionsRequest()
        request.source = start
        request.destination = end
        request.requestsAlternateRoutes = false
        request.transportType = transport
        /*
         TODO: Once time chooser is implemented
         request.departureDate =
         request.arrivalDate =
         */
        let directions = MKDirections(request: request)
        directions.calculateETA(completionHandler: recieveETA)
    }

    func recieveETA(_ response:MKETAResponse?, _ error: Error?) {
        if (response != nil){
            completionHandler(response)
        } else {
            print(error ?? "Error and response were nil")
        }
    }
    startRequest()
}
