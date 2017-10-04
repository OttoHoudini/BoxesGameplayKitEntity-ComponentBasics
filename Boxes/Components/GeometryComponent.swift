/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A component that attaches to an entity. This component controls a geometry node's physics body.
*/

import SceneKit
import GameplayKit

class GeometryComponent: GKSCNNodeComponent {
    
    // MARK: Methods
    
    /// Applies an upward impulse to the entity's box node, causing it to jump.
    func applyImpulse(_ vector: SCNVector3) {
        node.physicsBody?.applyForce(vector, asImpulse: true)
    }
    
    /// Applies an upward force the entity's box node, causing it to accelerate.
    func applyForce(_ vector: SCNVector3) {
        node.physicsBody?.applyForce(vector, asImpulse: false)
    }
}
