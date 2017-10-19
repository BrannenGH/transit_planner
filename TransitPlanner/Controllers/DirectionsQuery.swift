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
    let directions: MKDirections
    
    //MARK:Closures
    
    func handleResponse(response,error){
        
    }
    
    
    init(start:MKMapItem, end:MKMapItem, startDriving:Bool, endDriving:Bool){
        let request = MKDirectionsRequest()
        request.source = start
        request.destination = end
        request.requestsAlternateRoutes = false
        directions = MKDirections(request: request)
        directions.calculate(completionHandler: <#T##MKDirectionsHandler##MKDirectionsHandler##(MKDirectionsResponse?, Error?) -> Void#>)
    }
    
    if let transitNode = didSelect.annotation as? TransitNode {
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
