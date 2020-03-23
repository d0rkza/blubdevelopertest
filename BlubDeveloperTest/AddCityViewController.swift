//
//  AddCityViewController.swift
//  BlubDeveloperTest
//
//  Created by Marko Pranjić on 22/03/2020.
//  Copyright © 2020 Marko Pranjić. All rights reserved.
//

import UIKit
import os.log

class AddCityViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cityTextField: UITextField!
    
    var city: CityWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cityTextField.delegate = self
        updateAddButtonState()
    }

    //Navigation
    //Dismiss this view
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Prepare data to be transfered through segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === addButton else {
            os_log("The add button was not pressed", log: OSLog.default, type: .debug)
            return
        }
        let cityName = cityTextField.text ?? ""
        city = CityWeather(name: cityName)
        
    }
    
    func textFieldDidBeginEditing(_ cityTextField: UITextField) {
        addButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ cityTextField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ cityTextField: UITextField) {
        updateAddButtonState()
        navigationItem.title = cityTextField.text
    }
    
    func updateAddButtonState() {
        let text = cityTextField.text ?? ""
        
        addButton.isEnabled = !text.isEmpty
    }
}
