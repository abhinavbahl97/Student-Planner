//
//  CalanderViewController.swift
//  GroupProject
//
//  Created by Jonathan Kevin Rosales on 4/18/19.
//  Copyright © 2019 Jonathan Kevin Rosales. All rights reserved.
//

import UIKit

class CalanderViewController: UIViewController {

    @IBOutlet var Days: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var curr = 28
        
        for button in Days{
            button.setTitle("\(curr%30)", for: UIControl.State.normal)
            curr += 1
            if (curr == 0){
                curr += 1
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
