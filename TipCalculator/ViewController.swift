//
//  ViewController.swift
//  TipCalculator
//
//  Created by Kuei-Tin Hsu on 3/9/17.
//  Copyright © 2017 Kuei-Tin Hsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipSelect: UISegmentedControl!
    @IBOutlet weak var totalLabel: UILabel!

    @IBOutlet weak var perSplit: UILabel!
    
    @IBOutlet weak var splitNum: UILabel!
    @IBOutlet weak var splitSlider: UISlider!
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
   
    
    var tipPercents = [15,18,20,25]
    var tipDefaultIndex = 0
    var splitDefault = 1
    var defaults = UserDefaults.standard
    var lastBill = 0.0
    var lastAccessTime = Date()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        loadDefaultValue()
        //Check if the current time is less than that last access time plus 10 minutes, then populate the text field with the prevously saved bill amount
        if((Date() < lastAccessTime.addingTimeInterval(10*60)) && lastBill > 0) {
            billField.text = String(lastBill)
        }

        for (index, tipPercent) in tipPercents.enumerated()
        {
            tipSelect.setTitle(String(format:"%d%%",tipPercent), forSegmentAt: index)
        }
   
        //change Settings button to cogwheel icon
        self.settingsButton.title = NSString(string:"\u{2699}\u{0000FE0E}") as String
        
        //set displays to default values
        tipSelect.selectedSegmentIndex = tipDefaultIndex
        tipSelect.sendActions(for:UIControlEvents.valueChanged)
        splitSlider.setValue(Float(splitDefault), animated: false)
        splitNum.text = String(Int(splitSlider.value))
        
        //set focus to the text field when user opens the app
        self.billField.becomeFirstResponder()
        
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    @IBAction func onChangeBill(_ sender: Any) {
        updateDisplay()
        defaults.set(lastBill,forKey:"lastBill")
        defaults.set(Date(),forKey:"lastAccessTime")
        defaults.synchronize()
    }


 
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    

    
    /**
     Read default values from storage
     **/
    func loadDefaultValue() {
        
        let tipDef = defaults.integer(forKey: "tipDefaultIndex")
        let splitDef = defaults.integer(forKey:"splitDefault")
        let lastTm = defaults.object(forKey: "lastAccessTime")
        lastBill = defaults.double(forKey: "lastBill")
        
        if(tipDef == 0) {
            defaults.set(tipDefaultIndex, forKey: "tipDefaultIndex")
        }
        else {
            tipDefaultIndex = tipDef
        }
        
        if(splitDef == 0 ) {
            defaults.set(splitDefault, forKey: "splitDefault")
        }
        else {
            splitDefault = splitDef
        }
     
        if(lastTm != nil) {
            lastAccessTime = lastTm as! Date
        }
    }
    

    /**
     Update display as user input changes values
     
     **/
    func updateDisplay() {
        let bill = Double(billField.text!) ?? 0
        let split = Int(splitSlider.value)
        //get the value of the percentage in numeric only. Trim the percent sign.
        let tipPercent = NSString(string:tipSelect.titleForSegment(at: tipSelect.selectedSegmentIndex)!.trimmingCharacters(in: ["%"])).doubleValue
        splitNum.text = String(split)
        let tip = bill * tipPercent/100
        let total = tip + bill
        tipLabel.text = formatDisplayCurrency(value:tip)
        totalLabel.text = formatDisplayCurrency(value:total)
        perSplit.text = formatDisplayCurrency(value:total/Double(split))
        lastBill = bill
        
        
    }
    
    func formatDisplayCurrency(value: Double) -> String {
        let currencyformatter = NumberFormatter()
        currencyformatter.numberStyle = .currency
        currencyformatter.maximumFractionDigits = 2;
        currencyformatter.locale = Locale(identifier: Locale.current.identifier)
        let convertedString = currencyformatter.string(from: value as NSNumber);
        return convertedString!;
    }
}

