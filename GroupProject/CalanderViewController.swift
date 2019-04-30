//
//  CalanderViewController.swift
//  GroupProject
//
//  Created by Jonathan Kevin Rosales on 4/18/19.
//  Copyright © 2019 Jonathan Kevin Rosales. All rights reserved.
//

import UIKit

struct Event{
    
    var name: String
    var dueDate = Date()
    var info: String
    
    
}

struct Day{
    
    var date = Date()
    var events : [Event] = []
    var button: UIButton?
    
}

extension Day{
    init(date: Date){
        self.date = date
    }
}



class CalanderViewController: UIViewController {

    @IBOutlet var calander: [UIButton]!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destVC = segue.destination as! EventViewController
        
        var toReturn = Day(date: Date())
        
        for day in days{
            if day.button == sender as? UIButton{
                toReturn = day
            }
        }
        
        destVC.day = toReturn
    }
    
    var days: [Day] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var curr = 28
        var april = true
        var june = false
        var dateComponents = DateComponents()
        let userCalendar = Calendar.current // user calendar
        var newDate: Date?
        var newDay: Day
        
        dateComponents.year = 2019
        
        //the following sets up the numbers for the calander and assigns dates to May dates adding them to "days" collection

        for button in calander{
                
            button.setTitle("\(curr)", for: UIControl.State.normal)
            button.setTitleColor(UIColor.white, for: .normal)
            curr += 1
            
            if june{
            
                button.setTitleColor(UIColor.darkGray, for: .normal)
            
            }else if april == true{
                button.setTitleColor(UIColor.darkGray, for: .normal)
                if curr == 31{
                    april = false
                    curr = 1
                }
            }else{
                if curr == 32{
                    curr = 1
                    june = true
                }
            }
            if april == false && june == false{
                
                dateComponents.month = 5
                dateComponents.day = curr - 1
                dateComponents.timeZone = TimeZone(abbreviation: "EST")

                newDate = userCalendar.date(from: dateComponents)
                newDay = Day(date: newDate!, events: [], button: button)
                days.append(newDay)
            }
        }
    }
    


    
    @IBAction func addEvent(_ sender: UIButton) {
        
        let datePicker =  UIDatePicker()
        let alert = UIAlertController(title: "Enter New Home Work Assignment", message: "Don't procrastinate!", preferredStyle: .alert)
        
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter name.."
            textField.borderStyle = .roundedRect
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter class name.."
            textField.borderStyle = .roundedRect
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Select due date.."
            textField.inputView = datePicker
            textField.borderStyle = .roundedRect
            
            
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            
            //if anything isnt filled in a mistake will happen
            let assignmentName = alert?.textFields![0]
            let className = alert?.textFields![1]
            for day in self.days{
                if day.date == datePicker.date{
                    let newEvent = Event(name: (assignmentName?.text!)!, dueDate: datePicker.date, info: (className?.text!)!)
                    var toChange = day.events
                    toChange.append(newEvent) //is this really updating it??
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
