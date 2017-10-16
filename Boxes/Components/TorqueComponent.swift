//
//  ReactionWheelComponent.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/14/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class TorqueComponent: GKComponent {
    // MARK: Properties
    
    let magnitude: CGFloat
    let angularDamping: CGFloat
    var direction = simd_float3()
    
    var geometryComponent: GeometryComponent? {
        return entity?.component(ofType: GeometryComponent.self)
    }

    // MARK: -
    // MARK: Methods
    
    init(magnitude: CGFloat, angularDamping: CGFloat) {
        self.magnitude = magnitude
        self.angularDamping = angularDamping
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggelAngularDamping() {
        geometryComponent?.node.physicsBody?.angularDamping = geometryComponent?.node.physicsBody?.angularDamping == 0.0 ? angularDamping : 0.0
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard direction != simd_float3(), let geometryNode = geometryComponent else { print("not applying torque")
            return }
        
        let torqueAxis = geometryNode.node.presentation.worldTransform * SCNVector3.init(direction)
        print("\(torqueAxis)")
        let torque = SCNVector4(torqueAxis.x, torqueAxis.y, torqueAxis.z, magnitude)
        geometryNode.applyTorque(torque, asImpulse: false)
    }
}

func * (left: SCNMatrix4, right: SCNVector3) -> SCNVector3 { //multiply mat4 by vec3 as if w is 0.0
    return SCNVector3(
        left.m11 * right.x + left.m21 * right.y + left.m31 * right.z,
        left.m12 * right.x + left.m22 * right.y + left.m32 * right.z,
        left.m13 * right.x + left.m23 * right.y + left.m33 * right.z
    )
}

//extension float4 {
//    var xyz: float3 {
//        return float3(x, y, z)
//    }
//
//    init(_ vec3: float3, _ w: Float) {
//        self = float4(vec3.x, vec3.y, vec3.z, w)
//    }
//}
//
//extension float4x4 {
//    var upperLeft3x3: float3x3 {
//        let (a,b,c,_) = columns
//        return float3x3(a.xyz, b.xyz, c.xyz)
//    }
//
//    init(rotation: float3x3, position: float3) {
//        let (a,b,c) = rotation.columns
//        self = float4x4(float4(a, 0),
//                        float4(b, 0),
//                        float4(c, 0),
//                        float4(position, 1))
//    }
//}

