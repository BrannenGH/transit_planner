//
//  Location.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 17-11-04.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

class Location {
    typealias Kilometers = Double
    let location: MKMapItem
    let range: Kilometers
    let transport: MKDirectionsTransportType
    var nearbyNodes: [TransitNode]?
    
    
    init(location:MKMapItem,range:Kilometers,transport:MKDirectionsTransportType){
        self.location = location
        self.range = range
        self.transport = transport
    }
    
    func getMapItem() -> MKMapItem {
        return location
    }
    
    func setNodes(nodes:[TransitNode]){
        nearbyNodes = nodes
    }
    
    func getNodes() -> [TransitNode] {
        return nearbyNodes!
    }
    
    func getCoordinate() -> CLLocation {
        return location.placemark.location!
    }
}
