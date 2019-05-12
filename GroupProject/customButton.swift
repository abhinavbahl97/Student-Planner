//
//  customButton.swift
//  GroupProject
//
//  Created by abhinav bahl on 5/12/19.
//  Copyright © 2019 Jonathan Kevin Rosales. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 23.0
        layer.borderColor = UIColor(red: 255/255, green: 128/255, blue:0/255, alpha: 1.0).cgColor
        layer.borderWidth = 3.0
    }
}
