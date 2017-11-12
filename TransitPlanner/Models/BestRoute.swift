//
//  BestRoute.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 17-11-12.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

func BestRoute(start:Location, end:Location, completionHandler: @escaping (RoutePlanner.WholeRoute) -> ()){
    typealias transitRoute = (route:MKRoute,start:MKMapItem,end:MKMapItem)
    
    func planRoute() {
        //Fetches all possible routes
        var possibleRoutes : [transitRoute] = [transitRoute]()
        for startNode in start.getNodes(){
            for endNode in end.getNodes(){
                //Apparently can't get transit directions, no such route for polyline
                DirectionsQuery(start: startNode.getMapItem(), end: endNode.getMapItem(), transport: .automobile){ (routes) in
                    possibleRoutes.append((route:routes[0]!,start:startNode.getMapItem(),end:endNode.getMapItem()))
                    if (possibleRoutes.count >= start.getNodes().count * end.getNodes().count){
                        findMinRoute(routes: possibleRoutes)
                    }
                }
                sleep(5)
            }
        }
    }
    
    func findMinRoute(routes:[transitRoute]){
        //Compares to itself first, maybe fix by starting at one
        var minRoute = routes[0]
        for route in routes{
            if (minRoute.route.expectedTravelTime - route.route.expectedTravelTime > 0){
                minRoute = route
            }
        }
        DirectionsQuery(start: start.getMapItem(), end: minRoute.start, transport: .automobile) { (firstRoute) in
            DirectionsQuery(start: minRoute.end, end: end.getMapItem(), transport: .automobile) { (lastRoute) in
                completionHandler((firstRoute[0]!,minRoute.route,lastRoute[0]!))
            }
        }
    }
    planRoute()
}
