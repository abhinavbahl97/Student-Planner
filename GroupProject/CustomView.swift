//
//  CustomView.swift
//  GroupProject
//
//  Created by abhinav bahl on 5/12/19.
//  Copyright © 2019 Jonathan Kevin Rosales. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 4.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5.0
    }
    
}
