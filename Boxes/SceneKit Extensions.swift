//
//  SceneKit Extensions.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/16/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import SceneKit

extension SCNPhysicsSliderJoint {
    
    public class func fixed(bodyA: SCNPhysicsBody, axisA: SCNVector3, anchorA: SCNVector3, bodyB: SCNPhysicsBody, axisB: SCNVector3, anchorB: SCNVector3) -> SCNPhysicsSliderJoint {
        let joint = SCNPhysicsSliderJoint(bodyA: bodyA, axisA: axisA, anchorA: anchorA, bodyB: bodyB, axisB: axisB, anchorB: anchorB)
        
        joint.maximumLinearLimit = 0.0
        joint.minimumLinearLimit = 0.0
        joint.maximumAngularLimit = 0.0
        joint.minimumAngularLimit = 0.0
        joint.motorMaximumTorque = 0
        joint.motorMaximumForce = 0
        
        return joint
    }
}
