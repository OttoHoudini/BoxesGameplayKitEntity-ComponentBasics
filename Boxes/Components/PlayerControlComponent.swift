/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A component that attaches to an entity. This component enables a geometry node to jump.
*/

import GameplayKit
import SceneKit

// MARK: -
// MARK: PlayerControlComponent

class PlayerControlComponent: GKComponent {
    // MARK: Properties
    
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    /// A convenience property for the entity's thrust component.
    var thrustComponent: ThrustComponent? {
        return entity?.component(ofType: ThrustComponent.self)
    }

    // MARK: -
    // MARK: Methods
    
    /// Tells this entity's geometry component to jump.
    func jump() {
        let jumpVector = SCNVector3(x: 0, y: 2, z: 0)
        geometryComponent?.applyImpulse(jumpVector)
    }
    
    /// Causes the entity to accelerate
    func setThrottle(state: ThrustComponent.State) {
        thrustComponent?.state = state
    }
}


// MARK: -
// MARK: ThrustComponent

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
            print("Holding throttle")
        }
        
        magnitude = (0.0 ... 1.0).clamp(magnitude)
        
        if magnitude > 0 {
            print(magnitude)

            let thrustVector = directionVector * (magnitude * maxThrust)
            geometryComponent?.applyForce(SCNVector3(thrustVector))
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
