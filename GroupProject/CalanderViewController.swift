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
    
    mutating func addEvent(newEvent: Event){
        events.append(newEvent)
    }
    
}

extension Day{
    init(date: Date){
        self.date = date
    }
}

class CalanderViewController: UIViewController {

    @IBOutlet var calander: [UIButton]!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! EventViewController
        
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
            button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 19)
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
        self.tabBarController?.hidesBottomBarWhenPushed = false
        
        
    }
    
    @IBAction func addEvent(_ sender: UIButton) {
        
        let calander = Calendar(identifier: .gregorian)
        
        let datePicker =  UIDatePicker()
        let alert = UIAlertController(title: "Enter New Home Work Assignment", message: "Don't procrastinate!", preferredStyle: .alert)
        
        datePicker.datePickerMode = .date
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter name.."
            textField.borderStyle = .roundedRect
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter class name.."
            textField.borderStyle = .roundedRect
        }
        alert.addTextField { (data) in
            data.placeholder = "Select due date.."
            data.inputView = datePicker
            data.borderStyle = .roundedRect
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            
            print(datePicker.date)
            //if anything isnt filled in a mistake will happen
            let assignmentName = alert?.textFields![0]
            let className = alert?.textFields![1]
            
            var x = 0
            
            for day in self.days{
                if calander.isDate(day.date, equalTo: datePicker.date, toGranularity: .day) {
                    let newEvent = Event(name: (assignmentName?.text!)!, dueDate: datePicker.date, info: (className?.text!)!)
                    
                    self.days[x].addEvent(newEvent: newEvent)
                }
                x += 1
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
