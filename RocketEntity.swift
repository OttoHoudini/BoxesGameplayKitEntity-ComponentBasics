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
    
    var throttleLevel: Double {
        return component(ofType: ThrottleComponent.self)!.level
    }
    
    let throttleComponentSystem = GKComponentSystem<ThrottleComponent>(componentClass: ThrottleComponent.self)
    let thrustComponentSystem = GKComponentSystem<ThrustComponent>(componentClass: ThrustComponent.self)
    let fuelTankComponentSystem = GKComponentSystem<FuelTankComponent>(componentClass: FuelTankComponent.self)
    let particleComponentSystem = GKComponentSystem<ParticleComponent>(componentClass: ParticleComponent.self)

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
        fuelTankComponentSystem.update(deltaTime: seconds)
        particleComponentSystem.update(deltaTime: seconds)
    }
    
    func setThrottleState(_ state: ThrottleComponent.State) {
        component(ofType: ThrottleComponent.self)!.state = state
    }
    
    func fuelConsumptionRate() -> Double {
        return thrustComponentSystem.components.map{$0.fuelConsumptionRate}.reduce(0.0, +)
    }
    
    func hasFuel() -> Bool {
        return fuelTankComponentSystem.components.map {$0.remainingFuel}.reduce(0.0, +) > 0 ? true : false
    }
}
