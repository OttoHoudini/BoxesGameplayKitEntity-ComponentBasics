//
//  ThrustComponent.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/7/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class ThrustComponent: GKComponent {
    
    enum State {
        case off
        case up
        case down
        case hold
    }
    
    // MARK: Properties
    
    var state = State.off
    
    let maxThrust: Double
    
    /// The direction the thrust is applied.
    let directionVector = simd_double3(0, 1, 0)
    
    /// The magnitude of the thrust applied.
    var magnitude = 0.0
    
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    init(maxThrust: Double) {
        self.maxThrust = maxThrust
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    // MARK: Methods
    
    override func update(deltaTime seconds: TimeInterval) {
        let amount = 1.0 * seconds
        
        switch state {
        case .off:
            magnitude = 0.0
            
        case .up:
            magnitude += amount
            
        case .down:
            magnitude -= amount
            
        case .hold:
            break
        }
        
        magnitude = (0.0 ... 1.0).clamp(magnitude)
        
        if magnitude > 0 {
            print("Appling thrust at: \(String(format:"%.2f", magnitude))%")
            
            let thrustVector = directionVector * (magnitude * maxThrust)
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
