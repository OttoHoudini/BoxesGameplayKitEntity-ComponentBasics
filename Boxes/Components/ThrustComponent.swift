//
//  ThrustComponent.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class ThrustComponent: GKComponent {
    
    // MARK: Properties
    let throttle: ThrottleComponent

    let maxThrust: Double
    
    /// The direction the thrust is applied.
    let directionVector = simd_double3(0, 1, 0)
    
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    init(maxThrust: Double, throttleComponent: ThrottleComponent) {
        self.maxThrust = maxThrust
        self.throttle = throttleComponent
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Methods
    
    override func update(deltaTime seconds: TimeInterval) {
   
        if throttle.percent > 0, throttle.hasFuel()  {            
            let thrustVector = directionVector * (throttle.percent * maxThrust)
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
