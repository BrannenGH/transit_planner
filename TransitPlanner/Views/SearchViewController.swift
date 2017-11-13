//
//  SearchViewController.swift
//  TransitPlanner
//
//  Created by Brannen Hall on 10/28/17.
//  Copyright © 2017 BrannenGHH. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let transportionTypes = ["Driving","Walking"]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var routePlanner: RoutePlanner?


    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        routePlanner = appDelegate.routePlanner
        startTextField.delegate = self
        endTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        if segue.destination is MapViewController {
            routePlanner!.fetchRoute(start: startTextField.text!, end: endTextField.text!)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return transportionTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return transportionTypes[row]
    }
}
