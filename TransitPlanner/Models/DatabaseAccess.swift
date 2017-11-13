//
//  DatabaseAccess.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 17-11-04.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import GeoFire
import FirebaseDatabase

class DatabaseAccess {
    private let ref: DatabaseReference
    private let geoFire: GeoFire
    
    
    init() {
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref.child("GeoFire"))
    }
    
    func retrieveNodes(location: Location,completionHandler: @escaping ([TransitNode]) -> ()){
        let query = geoFire.query(at:location.getCoordinate(), withRadius: location.range)
        var observed = 0
        query!.observe(GFEventType.keyEntered) { (key, location) in
            if observed == 0 {
                observed += 1
                self.ref.child("TransitLocations").child(key!).observeSingleEvent(of: .value, with: {(snapshot) in
                    let nodeDictionary = snapshot.value as! [String: Any?]
                    var downloadedNodes = [TransitNode]()
                    do {
                        downloadedNodes.append(TransitNode(nodeDictionary["Name"]! as! String,nodeDictionary["Latitude"]! as! CLLocationDegrees,nodeDictionary["Longitude"]! as! CLLocationDegrees))
                    } /*catch {
                     print("There is an error with the database configuration")
                     }*/
                    completionHandler(downloadedNodes)
                    /*Figure out how in the world to get the NSObserver to stop observing
                    util then*/
                    //query?.removeObserver(query!, forKeyPath: <#T##String#>)
                })
            }
        }
    }
    
    /*private func updateFirebase() {
        ref.child("TransitLocations").observeSingleEvent(of: DataEventType.value, with:{(snapshot) in
            let nodeDictionary = snapshot.value as? [String : [String: Any?]]
            for (nodeName,properties) in nodeDictionary! {
                self.nodes.append(TransitNode(properties["Name"]! as! String,properties["Latitude"]! as! CLLocationDegrees,properties["Longitude"]! as! CLLocationDegrees))
                self.geoFire.setLocation(CLLocation(latitude:properties["Latitude"]! as! CLLocationDegrees,longitude:properties["Longitude"]! as! CLLocationDegrees), forKey: nodeName)
            }
        })
    }*/
}
