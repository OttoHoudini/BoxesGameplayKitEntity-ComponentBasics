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
    func toggleEngine() {
        thrustComponent?.magnitude = thrustComponent?.magnitude == 0.0 ? 1.5 : 0.0
    }
}

// MARK: -
// MARK: ThrustComponent

class ThrustComponent: GKComponent {
    // MARK: Properties
    
    /// The direction the thrust is applied.
    var directionVector = simd_double3(0, 1, 0)
    
    /// The magnitude of the thrust applied.
    var magnitude = 0.0
    
    /// A convenience property for the entity's geometry component.
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }
    
    // MARK: -
    // MARK: Methods
    
    override func update(deltaTime seconds: TimeInterval) {
        if magnitude > 0 {
            let thrustVector = directionVector * magnitude
            geometryComponent?.applyForce(SCNVector3(thrustVector))
        }
    }
}
