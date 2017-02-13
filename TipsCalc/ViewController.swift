//
//  ViewController.swift
//  TipsCalc
//
//  Created by Linh Le on 11/9/16.
//  Copyright © 2016 Linh Le. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var BillLabel: UITextField!
    @IBOutlet weak var TipLabel: UILabel!
    @IBOutlet weak var TotalLabel: UILabel!
    @IBOutlet weak var tipPercentSegment: UISegmentedControl!
    @IBOutlet weak var billNumberLabel: UILabel!
    @IBOutlet weak var waiterImage: UIImageView!
    @IBOutlet weak var RestaurantLabel: UITextField!
    
    var bill = 0.0
    var tip = 0.0
    var total =  0.0
    var tipPercentage = [0.05,0.1,0.2]
    var tipPercent = 0.0
    let defaults = UserDefaults.standard
    var billNumber = 0
    var location = "Unknown"
    var restaurant = "Unknown"
    
    @IBAction func calc(_ sender: Any) {
        checkLimitInput()
        calcTip()
    }
    @IBAction func updateRestaurant(_ sender: UITextField) {
        restaurant = RestaurantLabel.text ?? "Unknown"
    }
    
    @IBAction func tipPercentage(_ sender: Any) {
        updateImage()
        calcTip()
    }
   
    @IBAction func TapRecognize(_ sender: UITapGestureRecognizer) {
        BillLabel.endEditing(true)
        RestaurantLabel.endEditing(true)
    }
    
    @IBAction func ClearText(_ sender: UIButton) {
        BillLabel.text = ""
        calcTip()
        
    }
    @IBAction func ClearRestaurant(_ sender: UIButton) {
        RestaurantLabel.text = ""
    }
    @IBAction func Save(_ sender: UIButton) {
        updateHistory()
    }
    
    @IBOutlet weak var TipPercentBar: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Remain the last bill info.
        loadSession()
        loadBillNumber()
        updateImage()
        //Use numberPad to input the bill
        BillLabel.keyboardType = UIKeyboardType.decimalPad //numberPad
        BillLabel.becomeFirstResponder()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMoveToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMoveToForeground), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)


    }
    override func viewDidAppear(_ animated: Bool) {
        //Re load bill number
        loadBillNumber()
        //Re load tip percentages
        let option1 = 0.05*(Double((defaults.string(forKey: "tippercentageoption1")) ?? "1") ?? 1)
        let option2 = 0.05*(Double((defaults.string(forKey: "tippercentageoption2")) ?? "2") ?? 2)
        let option3 = 0.05*(Double((defaults.string(forKey: "tippercentageoption3")) ?? "3") ?? 3)
        tipPercentage = [option1,option2,option3]
        TipPercentBar.setTitle((String(Int(option1*100))+"%"), forSegmentAt: 0)
        TipPercentBar.setTitle((String(Int(option2*100))+"%"), forSegmentAt: 1)
        TipPercentBar.setTitle((String(Int(option3*100))+"%"), forSegmentAt: 2)
        //re-calculate bill
        calcTip()

    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calcTip() {
        tipPercent = tipPercentage[tipPercentSegment.selectedSegmentIndex]
        bill = Double(BillLabel.text!) ?? 0.0
        tip = Double(bill) * tipPercent
        total = tip + Double(bill)
        saveSession()
        loadSession()
    }
    func updateHistory() {
        //check bill is set or not
        if bill == 0 {
            log.warning("bill is not set")
            return
        }
        log.info(String(defaults.integer(forKey: "billNumber")))
        
        //add 1 new bill to billNumber
        billNumber += 1
        defaults.set(billNumber, forKey: "billNumber")
        
        //add to nsdefault
        defaults.setValue([String(bill),String(tip),String(total),(location),(restaurant)], forKey: ("bill No."+String(billNumber)))
        let temp = defaults.array(forKey: ("bill No."+String(billNumber)))
        log.warning("array in history: \(temp?[0])_\(temp?[1])_\(temp?[2])_\(temp?[3])_\(temp?[4])")
        //update bill number in view
        billNumberLabel.text = "No. "+String(billNumber)
    }
    func saveSession(){
        defaults.set(bill, forKey: "TipCalculate.RemainLastBill")
        defaults.set(RestaurantLabel.text, forKey: "TipCalculate.RemainLastRestaurant")
        defaults.set(tip, forKey: "TipCalculate.RemainLastTip")
        defaults.set(total, forKey: "TipCalculate.RemainLastTotal")
    }
    func clearSession(){
        log.info("clear session")
        defaults.set("", forKey: "TipCalculate.RemainLastBill")
        defaults.set("", forKey: "TipCalculate.RemainLastRestaurant")
        defaults.set("", forKey: "TipCalculate.RemainLastTip")
        defaults.set("", forKey: "TipCalculate.RemainLastTotal")
        loadSession()
    }
    func loadBillNumber(){
        //Load bill number
        billNumber = defaults.integer(forKey: "billNumber")
        billNumberLabel.text = "No. \(billNumber)"
    }
    func loadSession(){
        bill = defaults.double(forKey: "TipCalculate.RemainLastBill")
        restaurant = defaults.string(forKey: "TipCalculate.RemainLastRestaurant") ?? "Unknown"
        tip = defaults.double(forKey: "TipCalculate.RemainLastTip")
        total = defaults.double(forKey: "TipCalculate.RemainLastTotal")
        
        if bill == 0 {BillLabel.text = ""}else{/*BillLabel.text = String(bill)*/}
        TipLabel.text = String(utilities.numberToCurrency(tip))
        TotalLabel.text = String(utilities.numberToCurrency(total))
        RestaurantLabel.text = restaurant
    }
    func updateImage()  {
        
        if tipPercentage[tipPercentSegment.selectedSegmentIndex] < 0.1 {
            waiterImage.image = UIImage(named: "fire-jenkins")
        }else{
            waiterImage.image = UIImage(named: "waiter")
        }
    }
    func checkLimitInput() {
        let quantityOfCharacter = BillLabel.text!.characters.count
        let maxLength = 10
        log.info(String(quantityOfCharacter))
        if quantityOfCharacter > maxLength {
            log.warning("over load!!")
            BillLabel.deleteBackward()
        }
        //check 0 leading
        if (BillLabel.text!) == "0"{
            BillLabel.deleteBackward()
            TipLabel.text = utilities.numberToCurrency(0)
            TotalLabel.text = utilities.numberToCurrency(0)
        }
        //check decimal trailing
//        let billInput = Double(BillLabel.text!) ?? 0
//        log.info(String(billInput)+" "+String(Double(round(billInput*100)/100)))
//        if(billInput != (Double(round(billInput*100)/100))){
//            log.info("delete 3rd decimal")
//            BillLabel.deleteBackward()
//        }
        
    }
    func checkLeaveTime(){
//        let appState = UIApplication.shared.applicationState.rawValue
//        log.info("---check leave time")
//        log.info(String(describing: appState))
//        if appState == 0{
//            let reopenTime = utilities.getTime()
//            log.info("reopen time: \(reopenTime)")
//            defaults.set(reopenTime, forKey: "TipCalculate.reopenTime")
//
//        }else if appState == 2{
//            let inactiveTime = utilities.getTime()
//            log.info("background time: \(inactiveTime)")
//            defaults.set(inactiveTime, forKey: "TipCalculate.inactiveTime")
//        }else{
//        }
//        
        let activeTime = defaults.double(forKey: "TipCalculate.reopenTime") - defaults.double(forKey: "TipCalculate.inactiveTime")
        log.info(String(activeTime))
        if activeTime>1000 {
            clearSession()
            defaults.set("", forKey: "TipCalculate.reopenTime")
            defaults.set("", forKey: "TipCalculate.inactiveTime")

        }
    }
    func  appMoveToForeground() {
        let reopenTime = utilities.getTime()
        log.info("reopen time: \(reopenTime)")
        defaults.set(reopenTime, forKey: "TipCalculate.reopenTime")
        checkLeaveTime()
    }
    func appMoveToBackground() {
        let inactiveTime = utilities.getTime()
        log.info("background time: \(inactiveTime)")
        defaults.set(inactiveTime, forKey: "TipCalculate.inactiveTime")

    }

}

