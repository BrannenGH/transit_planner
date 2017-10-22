//
//  TransitNode.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/14/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

class TransitNode: NSObject, MKAnnotation {
    let title: String?
    let name: String
    let coordinate: CLLocationCoordinate2D
    var nextNode: TransitNode? = nil
    
    init(_ name: String, _ lat: CLLocationDegrees, _ long: CLLocationDegrees){
        self.coordinate = CLLocationCoordinate2D(latitude: lat,longitude: long)
        self.title = name
        self.name = name
        super.init()
    }
    func getMapItem() -> MKMapItem{
        return MKMapItem(placemark: MKPlacemark(coordinate: self.coordinate))
    }
    
    func getCoordinates() -> CLLocationCoordinate2D{
        return self.coordinate
    }
    
    func setNext(_ node:TransitNode){
        nextNode! = node
    }
    
    func getNext()-> TransitNode? {
        return nextNode
    }
}
