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

//Make struts for closures, clean up call backs. Also have object be initalized with stings of locations.
class APIManager: NSObject, CLLocationManagerDelegate {
    private let map:MKMapView
    private let ref: DatabaseReference
    private let geoFire: GeoFire
    private let locationManager = CLLocationManager()
    private var nodes:[TransitNode] = [TransitNode]()
    var start:MKMapItem?
    var end:MKMapItem?
    
    //MARK:Closures
    
    //MARK: Application Logic
    
    init(map:MKMapView,start:String?,end:String?) {
        self.map = map
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref.child("GeoFire"))
        super.init()
        _ = LocationQuery(start:start,end:end,locationManager:locationManager,completionHandler: { startResult, endResult in
            self.start = startResult![0]
            self.end = endResult![0]
            self.downloadNodes(start: startResult![0].placemark.location!, end: endResult![0].placemark.location!)
        })
    }
    
    func getNodes() -> [TransitNode] {
        return nodes
    }
    
    private func downloadNodes(start:CLLocation,end:CLLocation){
        self.loadQueryToMap(query: geoFire.query(at: start, withRadius: 20))
        self.loadQueryToMap(query: geoFire.query(at: end, withRadius: 20))
    }
    
    private func loadQueryToMap(query:GFCircleQuery?){
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
    
    //TODO: Find another way to do this
    private func updateFirebase() {
        ref.child("TransitLocations").observeSingleEvent(of: DataEventType.value, with:{(snapshot) in
            let nodeDictionary = snapshot.value as? [String : [String: Any?]]
            for (nodeName,properties) in nodeDictionary! {
                self.nodes.append(TransitNode(properties["Name"]! as! String,properties["Latitude"]! as! CLLocationDegrees,properties["Longitude"]! as! CLLocationDegrees))
                self.geoFire.setLocation(CLLocation(latitude:properties["Latitude"]! as! CLLocationDegrees,longitude:properties["Longitude"]! as! CLLocationDegrees), forKey: nodeName)
            }
            self.map.showAnnotations(self.nodes, animated: false)
            self.map.setRegion(MKCoordinateRegion(center: self.nodes[0].getCoordinates(),span: MKCoordinateSpan(latitudeDelta:0.10,longitudeDelta:0.10)), animated: true)
        })
    }
    
    func getDirections(start:MKMapItem, end:MKMapItem, formOfTransport:MKDirectionsTransportType, map:MKMapView){
        let directionQuery = DirectionsQuery(start: start, end: end, formOfTransportation: formOfTransport)
        directionQuery.addToMap(map: map)
    }
    
    
    // Set up error conditions soon.
    func getStart() -> MKMapItem{
        return self.start!
    }
    
    func getEnd() -> MKMapItem {
        return self.end!
    }
}
