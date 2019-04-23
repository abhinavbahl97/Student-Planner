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
    var button: UIButton
    
}



class CalanderViewController: UIViewController {

    @IBOutlet var calander: [UIButton]!
    
    var days: [Day] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var curr = 28
        var april = true
        var june = false
        var dateComponents = DateComponents()
        let userCalendar = Calendar.current // user calendar

        dateComponents.year = 2019

        
        for button in calander{
                
            button.setTitle("\(curr)", for: UIControl.State.normal)
            button.setTitleColor(UIColor.white, for: .normal)
            
            if june{
                button.setTitleColor(UIColor.darkGray, for: .normal)
            }
            
            curr += 1
            
            if april == true{
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
                dateComponents.day = curr
                dateComponents.timeZone = TimeZone(abbreviation: "EST")

                var someDateTime = userCalendar.date(from: dateComponents)
                
                var newDay = Day(date: someDateTime!, events: [], button: button)
                days.append(newDay)
   
            }
            
            
        }
        
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
