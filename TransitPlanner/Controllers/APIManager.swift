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
import GeoFire

class APIManager {
    let map:MKMapView
    let ref:DatabaseReference!
    let geoFire: GeoFire!
    var nodes:[TransitNode] = [TransitNode]()
    
    //MARK:Closures
    
    //MARK: Application Logic
    
    init(map:MKMapView,start:MKMapItem,end:MKMapItem){
        self.map = map
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref.child("GeoFire"))
        let endCoordinate = end.placemark.location!
        let startCoordinate = start.placemark.location!
        downloadNodes(start:startCoordinate,end:endCoordinate)
    }
    
    func getNodes() -> [TransitNode] {
        return nodes
    }
    
    func downloadNodes(start:CLLocation,end:CLLocation){
        loadQueryToMap(query: geoFire.query(at: start, withRadius: 20))
        loadQueryToMap(query:geoFire.query(at:end, withRadius: 20))
    }
    
    func loadQueryToMap(query:GFCircleQuery?){
        query!.observe(GFEventType.keyEntered) { (key, location) in
            self.ref.child("TransitLocations").child(key!).observeSingleEvent(of: .value, with: {(snapshot) in
                let nodeDictionary = snapshot.value as! [String: Any?]
                self.nodes.append(TransitNode(nodeDictionary["Name"]! as! String,nodeDictionary["Latitude"]! as! CLLocationDegrees,nodeDictionary["Longitude"]! as! CLLocationDegrees))
                if (self.nodes.count != 0){
                    self.map.showAnnotations(self.nodes, animated: false)
                    self.map.setRegion(MKCoordinateRegion(center: self.nodes[0].getCoordinates(),span: MKCoordinateSpan(latitudeDelta:0.10,longitudeDelta:0.10)), animated: true)
                }
            })
        }
    }
/*  Old version, updates firebase nodes.
     func downloadNodes() {
        ref.child("TransitLocations").observeSingleEvent(of: DataEventType.value, with:{(snapshot) in
            let nodeDictionary = snapshot.value as? [String : [String: Any?]]
            for (nodeName,properties) in nodeDictionary! {
                self.nodes.append(TransitNode(properties["Name"]! as! String,properties["Latitude"]! as! CLLocationDegrees,properties["Longitude"]! as! CLLocationDegrees))
                self.geoFire.setLocation(CLLocation(latitude:properties["Latitude"]! as! CLLocationDegrees,longitude:properties["Longitude"]! as! CLLocationDegrees), forKey: nodeName)
            }
            self.map.showAnnotations(self.nodes, animated: false)
            self.map.setRegion(MKCoordinateRegion(center: self.nodes[0].getCoordinates(),span: MKCoordinateSpan(latitudeDelta:0.10,longitudeDelta:0.10)), animated: true)
        })
    }*/
}
