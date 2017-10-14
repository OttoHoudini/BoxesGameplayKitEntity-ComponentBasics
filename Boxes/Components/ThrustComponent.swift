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
    
    let maxThrust: Double
    
    let fuelConsumptionRate: Double
    
    /// The direction the thrust is applied.
    let directionVector = simd_double3(0, 1, 0)
    
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    init(rocketEntity: RocketEntity, maxThrust: Double, fuelconsumptionRate: Double) {
        self.maxThrust = maxThrust
        self.fuelConsumptionRate = fuelconsumptionRate
        
        super.init()
        
        self.rocketEntity = rocketEntity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Methods
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let rocket = rocketEntity  else {
            return
        }
        let throttlePercent = rocket.throttlePercent
        
        if rocket.hasFuel(), throttlePercent > 0.0 {
            let thrustVector = directionVector * (throttlePercent * maxThrust)
            geometryComponent?.applyForce(SCNVector3(thrustVector), asImpulse: false)
        }
    }
}

extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}
