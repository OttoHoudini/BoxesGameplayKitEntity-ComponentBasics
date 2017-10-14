//
//  ThrottleComponent.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class ThrottleComponent: GKComponent {
    private let changeRate = 1.0
        
    enum State {
        case off
        case up
        case down
        case hold
    }
    
    var state = ThrottleComponent.State.off
    var percent = 0.0
    
    override func update(deltaTime seconds: TimeInterval) {
        switch state {
        case .off:
            percent = 0.0

        case .up:
            percent += changeRate * seconds
            print("Thottleing up")
            
        case .down:
            percent -= changeRate * seconds
            print("Thottleing down")

        case .hold:
            print("Thottle: \(percent)")
            break
        }
        
        percent = (0.0 ... 1.0).clamp(percent)
    }
}
