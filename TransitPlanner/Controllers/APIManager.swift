//
//  APIManager.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/18/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation

class APIManager {
    var session:URLSession? = nil;
    
    //MARK:Closures
    //Test Closure
    func recieveResponse(_ data:Data?,_ response:URLResponse?,_ error:Error?){
        if (data != nil){
            let
        }
    }
    
    //MARK: Application Logic
    func configureSession(_ config:URLSessionConfiguration){
        //Configuration Logic goes here.
    }
    
    init(){
        session! = URLSession(configuration: configureSession())
    }
    
    func configureSession() -> URLSessionConfiguration {
        return URLSessionConfiguration.default
    }
    
    //Testing URLSessions
    func getNodes(url:URL){
        session!.dataTask(with: url, completionHandler: recieveResponse)
    }
    
}
