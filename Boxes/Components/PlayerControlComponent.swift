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
    
    /// A convenience property for the entity's thrust component.
    var thrustComponent: ThrustComponent? {
        return entity?.component(ofType: ThrustComponent.self)
    }

    // MARK: -
    // MARK: Methods
    
    /// Causes the entity to accelerate
    func setThrottle(state: ThrustComponent.State) {
        thrustComponent?.state = state
    }
}
