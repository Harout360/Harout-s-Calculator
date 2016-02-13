//
//  ViewController.swift
//  Calculator with Memory
//
//  Created by Harout Grigoryan on 2/12/16.
//  Copyright © 2016 HaroutG. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    var isClear = true
    var doneCalc = false //true when equals clicked
    var calc1: Double = 0
    var operation = "="
    var selectedButton: UIButton!
    var calculationsText = ""
    
    @IBOutlet weak var totalTF: UITextField! //total displayed
    @IBOutlet weak var calculationsTF: UITextField!
    
    var totalDisplayed: Double {
        get {
            return NSNumberFormatter().numberFromString(totalTF.text!)!.doubleValue
        }
        set {
            totalTF.text  = "\(newValue.cleanValue)"
            isClear = true
        }
    }
    
    
    
    
    @IBAction func digitClick(sender: AnyObject) {
        let digit = sender.currentTitle!
        if isClear || totalTF.text == "0"{
            
            if(selectedButton != nil){
                //remove selected operation when number clicked (remove border)
                selectedButton.layer.borderWidth = 0
                
                //print calculations
                calculationsText = calculationsTF.text! + "\(totalDisplayed.cleanValue) \(operation) "
                calculationsTF.text = calculationsText.componentsSeparatedByString("=").last
            }
            
            //first number entered
            totalTF.text = digit
            
        } else if((totalTF.text == "0" && digit != "0") || totalTF.text != "0"){
            //condition prevents "0000", bunch of only zeros
            //not the first number so append to current number shown
            if (totalTF.text?.characters.count < 9){
                totalTF.text = totalTF.text! + digit!
            }
        }
        
        
        isClear = false
    }
    
    @IBAction func clear(sender: AnyObject) {
        clearCalc("0")
        calculationsTF.text = ""
    }
    
    @IBAction func backspace(sender: AnyObject) {
        var newVal = totalTF.text!
        newVal.removeCharsFromEnd(1)
        totalTF.text = newVal
    }
    
    
    @IBAction func operationClick(sender: AnyObject) {
        switch sender.currentTitle!! {
            case "+", "−", "×","÷":
                calculate()
                operation = sender.currentTitle!!
                calc1 = totalDisplayed
                isClear = true
                changedSelectedOperation(sender as! UIButton)
            case "%":
                totalDisplayed *= 0.01
                isClear = false
            case "+/−":
                totalDisplayed = totalDisplayed == 0 ? 0 : -totalDisplayed
                isClear = false
            default:break
        }

    }
    
    @IBAction func decimalClick(sender: AnyObject) {
        if (!totalTF.text!.containsString(".")){
            totalTF.text = isClear ? "0." : totalTF.text! + "."
            isClear = false
        }
    }
    
    
    @IBAction func equalsClicked(sender: AnyObject) {
        doneCalc = true
        calculate()
        operation = "="
        calculationsTF.text = calculationsTF.text! + " = \(totalTF.text!)"
        doneCalc = false
    }
    
    func calculate(){
        if (!isClear){
            printCalculations()
            //apply new operation to total
            
            print("\(calc1) \(operation) \(totalDisplayed)")
            switch operation {
                case "+":
                    totalDisplayed += calc1
                case "−":totalDisplayed = calc1 - totalDisplayed
                case "÷":totalDisplayed = calc1 / totalDisplayed
                case "×":totalDisplayed *= calc1
                default:break
            }

        }
        else {
            //equals was pressed and there may be a total displayed, keep it there
            clearCalc(totalTF.text!)
        }
    }
    
    func printCalculations(){
        //print new calcs to calculationsTF
        let printedOperation = doneCalc ? "" : " \(operation)"
        calculationsText = calculationsTF.text! +
                    "\(totalDisplayed.cleanValue)\(printedOperation) "
        //print after the initial "=" problem (quick work-around)
        calculationsTF.text = calculationsText.componentsSeparatedByString("=").last
    }
    
    func clearCalc(numToDisplay:String){
        totalDisplayed = Double(numToDisplay)!
        operation = "="
        
        if selectedButton != nil {
            selectedButton.layer.borderWidth = 0
        }
    }
    
    func changedSelectedOperation(currentSelection: UIButton){
        //switch which button's borders are showing
        if(selectedButton != nil){
            selectedButton.layer.borderWidth = 0
        }
        selectedButton = currentSelection
        selectedButton.layer.borderWidth = 1
        selectedButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Double {
    //remove zeros at end of decimal (5.0 -> 5)
    var cleanValue: String {
        return self % 1 == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension String {
    mutating func removeCharsFromEnd(removeCount:Int)
    {
        let stringLength = self.characters.count
        if stringLength > 1{
            let substringIndex = max(0, stringLength - removeCount)
            self = self.substringToIndex(self.startIndex.advancedBy(substringIndex))
        } else {
            self = "0"
        }
    }
}
