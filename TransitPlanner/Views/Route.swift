//
//  Route.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/18/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Route {
    let line:MKPolyline;
    let render:MKPolylineRenderer;
    
    init(_ line:MKPolyline, color:UIColor = UIColor.black){
        self.line = line
        render = MKPolylineRenderer(polyline: line);
        render.lineWidth = 3;
        render.strokeColor = color;
    }
    
    func setColor(color:UIColor){
        render.strokeColor = color;
    }
    
    func getRenderer() -> MKPolylineRenderer{
        return render;
    }
}
