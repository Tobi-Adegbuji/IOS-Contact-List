//
//  StateViewController.swift
//  My Contact List
//
//  Created by Cistudent on 4/13/20.
//  Copyright © 2020 Cistudent. All rights reserved.
//

import UIKit
import CoreData

class StateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pckState: UIPickerView!
    
    let stateItems: Array<String> = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL",
                                     "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA",
                                     "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE",
                                     "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK",
                                     "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT",
                                     "VA", "WA", "WV", "WI", "WY"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pckState.dataSource = self;
        pckState.delegate = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let settings = UserDefaults.standard
        let defaultState = settings.string(forKey: Constants.kDefaultState)
        var i = 0
        for field in stateItems {
            if field == defaultState {
                pckState.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        pckState.reloadComponent(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIPickerViewDelegateMethods
    
    // Returns the number of 'columns' to display
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the # of rows in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateItems.count
    }
    
    // Sets the value that is shown for each row in the picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateItems[row]
    }
    
    // If the user chooses from the pickerview, it calls this function
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaultState = stateItems[row]
        let settings = UserDefaults.standard
        settings.set(defaultState, forKey: Constants.kDefaultState)
        settings.synchronize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
