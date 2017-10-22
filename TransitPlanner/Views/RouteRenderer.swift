//
//  RouteRenderer.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/21/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import MapKit

class RouteRenderer: MKPolylineRenderer {
    init(line:MKPolyline){
        super.init(overlay:line as MKOverlay)
        self.strokeColor = UIColor.black
        self.lineWidth = 3
    }
}
