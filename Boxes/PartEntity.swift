//
//  PartEntity.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/16/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class PartEntity: GKEntity {
    
    func topAxis() -> SCNVector3 {
        return SCNVector3(0, 1, 0)
    }
    
//    func topAnchor() -> SCNVector3 {
//        if let geometryComponent = component(ofType: GeometryComponent.self) {
//            
//            let box  = geometryComponent.node.boundingBox
//            let boxDimensions = SCNVector3(simd_float3.init(box.max) - simd_float3(box.min))
//        }
//    }
}
