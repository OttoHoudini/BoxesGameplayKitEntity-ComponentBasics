/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    A component that attaches to an entity. This component controls a geometry node's physics body.
*/

import SceneKit
import GameplayKit

class GeometryComponent: GKSCNNodeComponent {
    
    // MARK: -
    // MARK: Methods
    
    func applyForce(_ direction: SCNVector3, asImpulse impulse: Bool) {
        node.physicsBody?.applyForce(direction, asImpulse: impulse)
    }
}
