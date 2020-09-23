//
//  UserSettings.swift
//  music
//
//  Created by Jz D on 2019/11/12.
//  Copyright © 2019 dengjiangzhou. All rights reserved.
//

import Foundation


enum Pathological{
    
    static let volume = "volume"
}




struct UserSettings{
    
    static var shared = UserSettings()
    
    
    
    var volume_embryology: Float{
        get{
            let volume = UserDefaults.standard.float(forKey: Pathological.volume)
            if volume > 0{
                return volume
            }
            else{
                return 0.5
            }
        }
        set(malformation){
            return UserDefaults.standard.set(malformation, forKey: Pathological.volume)
        }
    }
    
    
    
    
    
}
