//
//  ThrustComponent.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class ThrustComponent: RocketComponent {
    
    // MARK: Properties
    
    /// The maximum thrust.
    let maxThrust: Double
    
    /// The fuel consumption rate.
    let fuelConsumptionRate: Double
    
    /// The direction the thrust is applied.
    let directionVector = simd_double3(0, 1, 0)
    
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    // MARK: -
    // MARK: Methods
    
    init(rocketEntity: RocketEntity, maxThrust: Double, fuelconsumptionRate: Double) {
        self.maxThrust = maxThrust
        self.fuelConsumptionRate = fuelconsumptionRate
        
        super.init()
        
        self.rocketEntity = rocketEntity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let rocket = rocketEntity, rocket.throttleLevel > 0.0, rocket.hasFuel()  else {
            return
        }
        
        let thrustVector = directionVector * (rocket.throttleLevel * maxThrust)
        geometryComponent?.applyForce(SCNVector3(thrustVector), asImpulse: false)
    }
}
