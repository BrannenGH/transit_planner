//
//  APIManager.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/18/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

protocol RoutePlannerDelegate: class {
    func loadToMap(wholeRoute:RoutePlanner.WholeRoute)
}

//Make struts for closures, clean up call backs. Also have object be initalized with stings of locations.
class RoutePlanner {
    typealias WholeRoute = (MKRoute,MKRoute,MKRoute)
    let data:DatabaseAccess
    weak var delegate: RoutePlannerDelegate?
    
    init() {
        data = DatabaseAccess()
    }
    
    func fetchRoute(start:String,end:String){
        LocationQuery(location:start){ (startResult) in
            LocationQuery(location:end){ (endResult) in
                let startLocation = Location(location:(startResult![0]),range:20,transport: MKDirectionsTransportType.automobile)
                let endLocation = Location(location:(endResult![0]), range:20, transport: MKDirectionsTransportType.automobile)
                self.data.retrieveNodes(location: startLocation){ (nodes) in
                    startLocation.setNodes(nodes: nodes)
                    self.data.retrieveNodes(location: endLocation) { (nodes) in
                        endLocation.setNodes(nodes: nodes)
                        BestRoute(start:startLocation,end: endLocation){ (wholeRoute) in
                            self.delegate!.loadToMap(wholeRoute: wholeRoute)
                        }
                    }
                }
            }
        }
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
