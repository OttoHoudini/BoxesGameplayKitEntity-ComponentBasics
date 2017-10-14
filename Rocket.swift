//
//  Rocket.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/9/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class RocketEntity: GKEntity {
    
    var partEntities = [GKEntity]()
    
    var throttlePercent: Double {
        return component(ofType: ThrottleComponent.self)!.percent
    }
    
    let throttleComponentSystem = GKComponentSystem(componentClass: ThrottleComponent.self)
    let fuelComponentSystem = GKComponentSystem(componentClass: FuelComponent.self)
    let thrustComponentSystem = GKComponentSystem(componentClass: ThrustComponent.self)
    let particleComponentSystem = GKComponentSystem(componentClass: ParticleComponent.self)

    override init() {
        super.init()
        
        let throttleComponent = ThrottleComponent()
        throttleComponentSystem.addComponent(throttleComponent)
        self.addComponent(throttleComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        throttleComponentSystem.update(deltaTime: seconds)
        thrustComponentSystem.update(deltaTime: seconds)
        fuelComponentSystem.update(deltaTime: seconds)
        particleComponentSystem.update(deltaTime: seconds)
    }
    
    func setThrottleState(_ state: ThrottleComponent.State) {
        component(ofType: ThrottleComponent.self)!.state = state
    }
    
    func fuelConsumptionRate() -> Double {
        return 1.0
    }
    
    func hasFuel() -> Bool {
        var fuelAmount = 0.0
        
        for case let fuelComponent as FuelComponent in fuelComponentSystem.components {
            fuelAmount += fuelComponent.remainingAmount
        }
        
        return fuelAmount > 0 ? true : false
    }
}

//class RocketComponentSystem: GKComponentSystem<RocketComponent> {
//    
//    let rocket: RocketEntity
//    
//    init(rocket: RocketEntity, componentClass: GKComponent.Type) {
//        self.rocket = rocket
//        
//        super.init()
//    }
//}

