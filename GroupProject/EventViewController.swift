//
//  EventViewController.swift
//  GroupProject
//
//  Created by Jonathan Kevin Rosales on 4/23/19.
//  Copyright © 2019 Jonathan Kevin Rosales. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var day = Day(date: Date())
    var events : [Event] = []
    

    
    @IBOutlet weak var labelOutlet: UILabel!
    
    
    @IBOutlet weak var tableViewOutlet: UITableView!{
        didSet{
            tableViewOutlet.delegate = self
            tableViewOutlet.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let df = DateFormatter()
        df.dateFormat = "d, yyyy"
        labelOutlet.text = "May \(df.string(from: day.date))"
        //events = day.events
        update()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let datef = DateFormatter()
        datef.dateFormat = "MM/DD/YYYY"
        
        
        print(events[indexPath.row])
        
        
        if let myCell = cell as? Cell{
            
            myCell.className.text = events[indexPath.row].info
            myCell.dueDate.text = datef.string(from: events[indexPath.row].dueDate)
            myCell.name.text = events[indexPath.row].name
            myCell.textLabel?.numberOfLines = 0
            myCell.textLabel?.lineBreakMode = .byWordWrapping
    
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func update(){
        
        let data = Date()
        let toPush = Event(name: "Trial", dueDate: data, info: "This is a trial")
        
        events = [toPush]
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

class Cell: UITableViewCell{
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var name: UILabel!
    
}
