//
//  ScrollView.swift
//  music
//
//  Created by Jz D on 2019/7/13.
//  Copyright © 2019 dengjiangzhou. All rights reserved.
//

import UIKit

class ScrollView: UIScrollView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
}
