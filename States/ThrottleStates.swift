//
//  ThrottleStates.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class ThrottleOffState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        guard !(stateClass.self == ThrottleDownState.self)  else {
            return false
        }
        return true
    }
}

class ThrottleUpState: GKState {
    
}

class ThrottleDownState: GKState {
    
}

class hrottleHoldState: GKState {
    
}

