//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Kuei-Tin Hsu on 3/9/17.
//  Copyright © 2017 Kuei-Tin Hsu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    var tipDefaultIndex = 0
    var splitDefault = 1
    var tipPercents = [15,18,20,25]
    @IBOutlet weak var tipPicker: UIPickerView!
    @IBOutlet weak var defaultNumofSplitLabel: UILabel!
    @IBOutlet weak var splitSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadDefaultValue()

        self.tipPicker.dataSource = self
        self.tipPicker.delegate = self
        tipPicker.selectRow(tipDefaultIndex, inComponent: 0, animated: true)
        splitSlider.setValue(Float(splitDefault), animated: true)
        defaultNumofSplitLabel.text = String(splitDefault)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onChangeDefaultSplit(_ sender: Any) {
        let defaults = UserDefaults.standard
        splitDefault = Int(splitSlider.value)
        defaultNumofSplitLabel.text = String(splitDefault)
        defaults.set(splitDefault, forKey:"splitDefault")
        defaults.synchronize()

    
    }

    func loadDefaultValue() {
        let defaults = UserDefaults.standard
        let tipDef = defaults.integer(forKey: "tipDefaultIndex")
        let splitDef = defaults.integer(forKey:"splitDefault")
        
        tipDefaultIndex = tipDef
        
        
        if(splitDef == 0 ) {
            defaults.set(splitDefault, forKey: "splitDefault")
        }
        else {
            splitDefault = splitDef
        }
    }
    
    // DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tipPercents.count
    }
    
    // Delegate    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(tipPercents[row])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let defaults = UserDefaults.standard
        tipDefaultIndex = row
        defaults.set(tipDefaultIndex, forKey: "tipDefaultIndex")
        defaults.synchronize()

    }
   
}
