//
//  InputPlansViewController.swift
//  Calendar
//
//  Created by Leqi Long on 8/5/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import CoreData

protocol InputPlansViewControllerDelegate{
    func fetchActivities(selectedDate: NSDate?)
}

class InputPlansViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
//MARK: -Outlets
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var plansTextField: UITextField!
    
//MARK: -Properties
    var context: NSManagedObjectContext{
        return CoreDataStack.sharedInstance.context
    }
    var userSetTime: NSDate?
    var currentDate: Date?
    var selectedDate: NSDate?
    var delegate: InputPlansViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        plansTextField.delegate = self
        datePickerView.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        print("currentDate is \(currentDate)!!!")
    }
    
    func datePickerChanged(sender: AnyObject?){
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        
        let strDate = formatter.stringFromDate(datePickerView.date)
        print("strDate is \(strDate)")
        userSetTime = datePickerView.date
        
    }
    
    func updateTable(selectedDate: NSDate?){
        delegate?.fetchActivities(selectedDate)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        if plansTextField.text != ""{
            let activity = Activity(detail: plansTextField.text!, context: self.context)
            activity.time = userSetTime ?? datePickerView.date
            activity.date = currentDate
            activity.selectedDate = selectedDate
            print("activity.selectedDate in InputPlansViewControlleris \(activity.selectedDate)!!!")
            do{
               try context.save()
            }catch{}
            
            updateTable(selectedDate)
            
            dismissViewControllerAnimated(true, completion: nil)
        }else{
            displayError("Oops. You didn't enter any texts")
        }
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        <#code#>
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
