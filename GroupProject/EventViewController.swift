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
    var events : [Event]?
    
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!{
        didSet{
            tableViewOutlet.delegate = self
            tableViewOutlet.dataSource = self
            tableViewOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.7520371675, blue: 0.2334620059, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let df = DateFormatter()
        df.dateFormat = "d, yyyy"
        labelOutlet.text = "May \(df.string(from: day.date))"
        events = day.events
        //update()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let datef = DateFormatter()
        datef.dateFormat = "MM/DD/YYYY"
        
        if let myCell = cell as? Cell{
        
            myCell.className.text = events![indexPath.row].info
            myCell.name.text = events![indexPath.row].name
            
            myCell.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            
//            myCell.textLabel?.numberOfLines = 0
//            myCell.textLabel?.lineBreakMode = .byWordWrapping
    
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func update(){
        
        
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
    @IBOutlet weak var name: UILabel!
    
}
