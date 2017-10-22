//
//  APIManager.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/18/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit
import FirebaseDatabase

class APIManager {
    let map:MKMapView
    let ref:DatabaseReference!
    var nodes:[TransitNode] = [TransitNode]()
    
    //MARK:Closures
    //Test Closure

    //MARK: Application Logic
    
    init(map:MKMapView){
        self.map = map
        ref = Database.database().reference()
        downloadNodes()
    }
    
    func getNodes() -> [TransitNode] {
        return nodes
    }
    
    func downloadNodes() {
        ref.child("TransitLocations").observeSingleEvent(of: DataEventType.value, with:{(snapshot) in
            let nodeDictionary = snapshot.value as? [String : [String: Any?]]
            for (_,properties) in nodeDictionary! {
                self.nodes.append(TransitNode(properties["Name"]! as! String,properties["Latitude"]! as! CLLocationDegrees,properties["Longitude"]! as! CLLocationDegrees))
            }
            self.map.showAnnotations(self.nodes, animated: false)
            self.map.setRegion(MKCoordinateRegion(center: self.nodes[0].getCoordinates(),span: MKCoordinateSpan(latitudeDelta:0.10,longitudeDelta:0.10)), animated: true)
        })
    }
}
