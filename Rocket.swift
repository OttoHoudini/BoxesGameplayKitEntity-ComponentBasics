//
//  Rocket.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/9/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import GameplayKit

class Rocket {
    var partEntities = [GKEntity]()
    let throttle: ThrottleComponent
    
    let particleComponentSystem = GKComponentSystem(componentClass: ParticleComponent.self)
    let thrustComponentSystem = GKComponentSystem(componentClass: ThrustComponent.self)
    let fuelComponentSystem = GKComponentSystem(componentClass: FuelComponent.self)
    
    init(throttleComponent: ThrottleComponent) {
        self.throttle = throttleComponent
        self.throttle.fuelComponentSystem = (self.fuelComponentSystem as! GKComponentSystem<FuelComponent>)

    }
}

class ThrottleComponent: GKComponent {
    private let changeRate = 0.5
    
    var fuelComponentSystem: GKComponentSystem<FuelComponent>?
    
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
            
        case .down:
            percent -= changeRate * seconds
            
        case .hold:
            break
        }
        
        percent = (0.0 ... 1.0).clamp(percent)
    }
    
    func hasFuel() -> Bool {
        var fuelAmount = 0.0
        
        for fuelComponent in fuelComponentSystem!.components {
            fuelAmount += fuelComponent.remainingAmount
        }
        
        return fuelAmount > 0 ? true : false
    }
}
