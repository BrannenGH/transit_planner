//
//  DirectionsQuery.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/19/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

func DirectionsQuery(start:MKMapItem, end:MKMapItem, transport:MKDirectionsTransportType, completionHandler: @escaping ([MKRoute?]) -> ()){
    
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
        if (transport != MKDirectionsTransportType.transit){
            directions.calculate(completionHandler:recieveRequest)
        } else {
            directions.calculateETA(completionHandler: recieveETA)
        }
    }

    func recieveRequest(_ response:MKDirectionsResponse?,_ error:Error?){
        if (response != nil){
            completionHandler(response!.routes)
        } else {
            print(error ?? "Error and response were nil")
        }
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
