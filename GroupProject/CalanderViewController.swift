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
    
    var isMay = true
    
    @IBOutlet var calander: [UIButton]!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBAction func goJune(_ sender: Any) {
        if isMay{
            isMay = false
            monthLabel.text = "June 2019"
            var curr = 26
            var june = false
            var may = true
            var july = false
            
            for button in calander{
                button.setTitle("\(curr)", for: UIControl.State.normal)
                curr += 1
                button.setTitleColor(UIColor.white, for: .normal)
                if may == true || july == true {
                    button.setTitleColor(UIColor.darkGray, for: .normal)
                }
                if june == false && curr == 32{
                    curr = 1
                    june = true
                    may = false
                }else if june == true && curr == 30{
                    curr = 1
                    june = false
                    july = true
                }
            }
        }
    }
    
    @IBAction func goMay(_ sender: Any) {
        if isMay == false{
            isMay = true
            self.viewDidLoad()
        }
    }

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
        
        monthLabel.text = "May 2019"
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
                    self.days[x].button?.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                    self.days[x].button?.layer.cornerRadius = 5
                    
                    
                }
                x += 1
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
