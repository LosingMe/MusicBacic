//
//  ControllerMore.swift
//  Music Player
//
//  Created by Jz D on 2019/7/23.
//  Copyright © 2019 polat. All rights reserved.
//

import UIKit



extension ViewController{
    
    
    func alertSongExsit(){
        let alert = UIAlertController(title: "Music Error", message: "No songs Exsit", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Cancel it", style: UIAlertAction.Style.cancel) { (action) in            }
        alert.addAction(action)
        present(alert, animated: true, completion: {})
    }
    
    
}



