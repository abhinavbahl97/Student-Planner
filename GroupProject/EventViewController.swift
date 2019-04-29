//
//  EventViewController.swift
//  GroupProject
//
//  Created by Jonathan Kevin Rosales on 4/23/19.
//  Copyright © 2019 Jonathan Kevin Rosales. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    
    
    var day = Day(date: Date())
    var events : [Event] = []
    

    
    @IBOutlet weak var labelOutlet: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let df = DateFormatter()
        
        df.dateFormat = "d, yyyy"
        labelOutlet.text = "May \(df.string(from: day.date))"
        events = day.events!
        
        
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
