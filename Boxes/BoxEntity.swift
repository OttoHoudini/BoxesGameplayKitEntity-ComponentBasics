//
//  BoxEntity.swift
//  Boxes
//
//  Created by Jeffery Jensen on 9/30/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameKit

class BoxEntity: GKEntity {
    
    /**
     Creates box entities with a set of components as specified in the
     parameters. It uses default parameter values so parameters can be
     ommitted in the method call. The parameter particleComponentName is a
     string optional so its default parameter value can be nil.
     
     - Parameter color: The color of the box that this entity should have.
     
     - Parameter wantsPlayerControlComponent: Whether or not this entity
     should be set up with a player control component.
     
     - Parameter particleComponentName: The name of the particle
     component entity should be set up with.
     
     - Returns: An entity with the set of components requested.
     */
    init(forNodeWithColor color: NSColor, wantsPlayerControlComponent: Bool = false, withParticleComponentNamed particleComponentName: String? = nil) {
        
        super.init()
        
        // Create and attach a geometry component to the box.
        let boxNode = SCNNode.init(geometry: SCNBox())
        boxNode.physicsBody = SCNPhysicsBody.init(type: .dynamic, shape: nil)
        boxNode.geometry?.materials.first?.diffuse.contents = color
        
        let geometryComponent = GeometryComponent(geometryNode: boxNode)
        self.addComponent(geometryComponent)
        
        // If requested, create and attach a particle component.
        if let particleComponentName = particleComponentName {
            let particleComponent = ParticleComponent(particleName: particleComponentName)
            self.addComponent(particleComponent)
        }
        
        // If requested, create and attach a player control component.
        if wantsPlayerControlComponent {
            let playerControlComponent = PlayerControlComponent()
            self.addComponent(playerControlComponent)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
