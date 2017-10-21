//
//  DirectionsQuery.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/19/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

class DirectionsQuery{
    var routes:[MKRoute]?
    var waitingMap:MKMapView?

    //MARK:Closures
    
    func handleResponse(_ response:MKDirectionsResponse?,_ error:Error?){
        if (error != nil) {
            print("ERROR")
        }else if (response != nil){
            routes = response!.routes
            if (waitingMap != nil){
                addToMap(map: waitingMap!)
            }
        }
    }

    
    init(start:MKMapItem, end:MKMapItem, formOfTransportation:MKDirectionsTransportType){
        let request = MKDirectionsRequest()
        request.source = start
        request.destination = end
        request.requestsAlternateRoutes = false
        request.transportType = formOfTransportation
        /*TODO: Once time chooser is implemented
        request.departureDate =
        request.arrivalDate =
        */
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler:handleResponse)
    }
    
    func addToMap(map:MKMapView){
        if (routes != nil){
            for route in routes! {
                let line = route.polyline
                map.add(line,level:MKOverlayLevel.aboveRoads)
            }
        } else {
            waitingMap = map
        }
    }
}
