//
//  SettingsViewController.swift
//  TipsCalc
//
//  Created by Linh Le on 11/9/16.
//  Copyright © 2016 Linh Le. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //let log = LinhLog()

    @IBOutlet weak var option1: UILabel!
    @IBOutlet weak var option2: UILabel!
    @IBOutlet weak var option3: UILabel!
    @IBOutlet weak var TipPercentPicker: UIPickerView!
    
    let defaults = UserDefaults.standard
    var pickerData = [[String]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Connect data:
        self.TipPercentPicker.delegate = self
        self.TipPercentPicker.dataSource = self
        
        // Input data into the Array:
        pickerData = [["5%","10%","15%","20%","25%"],
                      ["5%","10%","15%","20%","25%"],
                      ["5%","10%","15%","20%","25%"]]
        
        //set picker with current value of tip percentage
        let option1 = (Int((defaults.string(forKey: "tippercentageoption1")) ?? "1") ?? 1) - 1
        let option2 = (Int((defaults.string(forKey: "tippercentageoption2")) ?? "2") ?? 2) - 1
        let option3 = (Int((defaults.string(forKey: "tippercentageoption3")) ?? "3") ?? 3) - 1
        TipPercentPicker.selectRow(option1, inComponent: 0, animated: true)
        TipPercentPicker.selectRow(option2, inComponent: 1, animated: true)
        TipPercentPicker.selectRow(option3, inComponent: 2, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[0].count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            defaults.setValue(row+1, forKey: "tippercentageoption1")
        }else if component == 1 {
            defaults.setValue(row+1, forKey: "tippercentageoption2")
        }else if component == 2 {
            defaults.setValue(row+1, forKey: "tippercentageoption3")
        }
    }
}
