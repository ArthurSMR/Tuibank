//
//  Extensions.swift
//  tuibank
//
//  Created by Arthur Rodrigues on 08/01/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

public extension UIView {
    
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
    }
    
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0.0
        }
    }
    
}
