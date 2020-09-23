//
//  LayerExtern.swift
//  music
//
//  Created by Jz D on 2019/7/26.
//  Copyright © 2019 dengjiangzhou. All rights reserved.
//

import UIKit



extension CALayer{
    
    func addUpperLayer(_ y: CGFloat = -1){
        
        let upperLayer = CALayer()
        upperLayer.borderColor = UIColor.yellow.cgColor
        upperLayer.borderWidth = 2
        upperLayer.frame = CGRect(x: -1, y: y, width: frame.width, height: 3)
        addSublayer(upperLayer)
        
    }
    
    
    
}
