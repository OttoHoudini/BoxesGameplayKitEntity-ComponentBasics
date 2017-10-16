//
//  Rocket.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/9/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class RocketEntity: GKEntity {
    
    //MARK: Properties
    
    var partEntities = [GKEntity]()
    
    var throttleComponent: ThrottleComponent? {
        return component(ofType: ThrottleComponent.self)
    }
    
    var torqueDirection = simd_float3() {
        didSet {
            print("DidSet Torque:  \(torqueDirection)")
            let _ = torqueComponentSystem.components.map() { $0.direction = torqueDirection }
        }
    }
    
    var isSASActive = false {
        didSet {
            if isSASActive {
                let _ = torqueComponentSystem.components.map() { $0.toggelAngularDamping() }
            }
        }
    }
    
    let torqueComponentSystem = GKComponentSystem<TorqueComponent>(componentClass: TorqueComponent.self)
    let thrustComponentSystem = GKComponentSystem<ThrustComponent>(componentClass: ThrustComponent.self)
    let fuelTankComponentSystem = GKComponentSystem<FuelTankComponent>(componentClass: FuelTankComponent.self)
    let particleComponentSystem = GKComponentSystem<ParticleComponent>(componentClass: ParticleComponent.self)

    //MARK: -
    //MARK Methods
    
    override init() {
        super.init()
        
        self.addComponent(ThrottleComponent())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setThrottleState(_ state: ThrottleComponent.State) {
        throttleComponent?.state = state
    }
    
//    func updateTorqueDirection(_ direction: SCNVector3) {
//        let _ = torqueComponentSystem.components.map() { $0.direction = direction }
//    }
    
    func fuelConsumptionRate() -> Double {
        return thrustComponentSystem.components.map{$0.fuelConsumptionRate}.reduce(0.0, +)
    }
    
    func hasFuel() -> Bool {
        return fuelTankComponentSystem.components.map {$0.remainingFuel}.reduce(0.0, +) > 0 ? true : false
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        throttleComponent?.update(deltaTime: seconds)
        torqueComponentSystem.update(deltaTime: seconds)
        torqueComponentSystem.update(deltaTime: seconds)
        thrustComponentSystem.update(deltaTime: seconds)
        fuelTankComponentSystem.update(deltaTime: seconds)
        particleComponentSystem.update(deltaTime: seconds)
    }
}
