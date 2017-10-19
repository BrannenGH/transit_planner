//
//  APIManager.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/18/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import Foundation

class APIManager {
    let session:URLSession;
    
    //MARK:Closures
    //Test Closure
    func recieveResponse(_ data:Data?,_ response:URLResponse?,_ error:Error?){
        if response is HTTPURLResponse && (response! as! HTTPURLResponse).statusCode == 200{
            //Makes sure if any weird call calls this handler it doesn't be weird
            
        }
    }
    
    //MARK: Application Logic
    func configureSession(_ config:URLSessionConfiguration){
        //Configuration Logic goes here.
    }
    
    init(){
        let sessionConfiguration = URLSessionConfiguration.default;
        configureSession(sessionConfiguration)
        session = URLSession(configuration: sessionConfiguration)
    }
    

    
    //Testing URLSessions
    func getNodes(url:URL){
        session.dataTask(with: url, completionHandler: recieveResponse)
    }
    
}
