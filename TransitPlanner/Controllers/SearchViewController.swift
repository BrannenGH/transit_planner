//
//  SearchViewController.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/28/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    var startPos:String?
    var endPos:String?
    
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var startSwitch: UISwitch!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var endSwitch: UISwitch!
    @IBOutlet weak var searchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        startTextField.delegate = self
        endTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation
    @IBAction func startPosUpdated(_ sender: UITextField) {
        startPos = sender.text
    }
    
    @IBAction func endPosUpdated(_ sender: UITextField) {
        endPos = sender.text
    }
    @IBAction func searchTouchDown() {
        header.text = "\(startPos ?? "None") \(endPos ?? "None")"
        header.sizeToFit()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField == startTextField){
            self.endTextField.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if let mapViewController = segue.destination as? MapViewController {
            mapViewController.startLocation = startPos
            mapViewController.endLocation = endPos
        }
    }
}
