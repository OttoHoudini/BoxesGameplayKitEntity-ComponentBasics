/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Handles logic controlling the scene. Primarily, it initializes the game's entities and components structure, and handles game updates.
*/

import SceneKit
import GameplayKit

let BitmaskRocketCamera     = Int(1 << 2)
let BitmaskNavigationCamera = Int(1 << 3)
let BitmaskMapCamera        = Int(1 << 4)
let BitmaskGround           = Int(1 << 5)
let BitmaskPart             = Int(1 << 6)

class Game: NSObject, SCNSceneRendererDelegate {
    // MARK: Properties
    
    /// The scene that the game controls.
    let scene = SCNScene(named: "GameScene.scn")!
    
    /// Holds the box entities, so they won't be deallocated.
    var currentRocket = RocketEntity()
    
    /// Keeps track of the time for use in the update method.
    var previousUpdateTime: TimeInterval = 0
    
    // MARK: -
    // MARK: Initialization
    
    override init() {
        super.init()
        
        setUpEntities()
        addComponentsToComponentSystems()
    }
    
    /**
        Sets up the entities for the scene. It creates four entities with a
        factory method, but leaves the purple box entity for you to set up
        yourself.
    */
    func setUpEntities() {
        // Create entities with components using the factory method.
        let ground = scene.rootNode.childNode(withName: "floor", recursively: true)!
        ground.physicsBody?.categoryBitMask = BitmaskGround
        ground.physicsBody?.collisionBitMask = BitmaskPart
        
        let engineEntity = makeBoxEntity(forNodeWithName: "yellowBox", wantsTorqueComponent: true, wantsThrustComponent: true, withParticleComponentNamed: "Fire")
        
        let fuelEntity = makeBoxEntity(forNodeWithName: "blueBox", wantsFuelComponent: true)
        
        let fuelNode  = fuelEntity.component(ofType: GeometryComponent.self)!.node
        let engineNode = engineEntity.component(ofType: GeometryComponent.self)!.node
        fuelNode.position = SCNVector3(0, 1.5, 0)
        engineNode.position = SCNVector3(0, 0.5, 0)

        fuelNode.physicsBody?.categoryBitMask = BitmaskPart
        fuelNode.physicsBody?.collisionBitMask = BitmaskGround
        
        engineNode.physicsBody?.categoryBitMask = BitmaskPart
        engineNode.physicsBody?.collisionBitMask = BitmaskGround
        
        let joint = SCNPhysicsSliderJoint.fixed(bodyA: fuelNode.physicsBody!, axisA: SCNVector3(0, 1,0), anchorA: SCNVector3(0, -0.5, 0), bodyB: engineNode.physicsBody!, axisB: SCNVector3(0, 1, 0), anchorB: SCNVector3(0, 0.5, 0))
        
        scene.physicsWorld.addBehavior(joint)
        
        currentRocket.partEntities = [engineEntity, fuelEntity]
    }
    
    /**
        Checks each box for components. If a box has a particle and/or player
        control component, it is added to the appropriate component system.
        Since the methods `jumpBoxes(_:)` and `renderer(_:)` use component
        systems to reference components, a component will not properly affect
        the scene unless it is added to one of these systems.
    */
    func addComponentsToComponentSystems() {
        for partEntity in currentRocket.partEntities {
            currentRocket.torqueComponentSystem.addComponent(foundIn: partEntity)
            currentRocket.particleComponentSystem.addComponent(foundIn: partEntity)
            currentRocket.thrustComponentSystem.addComponent(foundIn: partEntity)
            currentRocket.fuelTankComponentSystem.addComponent(foundIn: partEntity)
        }
    }
    
    // MARK: -
    // MARK: Methods

    func setThrottle(state: ThrottleComponent.State) {
        currentRocket.setThrottleState(state)
    }
    
    func controlEntityWith(node: SCNNode) {
    }
    
    func highlight(node: SCNNode) {
        // get its material
        let material =  node.geometry!.firstMaterial!
        
        // highlight it
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        
        // on completion - unhighlight
        SCNTransaction.completionBlock = {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            material.emission.contents = NSColor.black
            
            SCNTransaction.commit()
        }
        
        material.emission.contents = NSColor.red
        
        SCNTransaction.commit()
    }
    
    /**
        Updates every frame, and keeps components in the particle component
        system up to date.
    */
    func renderer(_: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Calculate the time change since the previous update.
        let timeSincePreviousUpdate = time - previousUpdateTime
        
        currentRocket.update(deltaTime: timeSincePreviousUpdate)
        
        // Update the previous update time to keep future calculations accurate.
        previousUpdateTime = time
    }
    
    // MARK: -
    // MARK: Box Factory Method
    
    /**
        Creates box entities with a set of components as specified in the
        parameters. It uses default parameter values so parameters can be
        ommitted in the method call. The parameter particleComponentName is a
        string optional so its default parameter value can be nil.
    
        - Parameter name: The name of the box that this entity should manage.
    
        - Parameter wantsPlayerControlComponent: Whether or not this entity
        should be set up with a player control component.
    
        - Parameter particleComponentName: The name of the particle
        component entity should be set up with.
    
        - Returns: An entity with the set of components requested.
    */
    func makeBoxEntity(forNodeWithName name: String, wantsTorqueComponent: Bool = false, wantsThrustComponent: Bool = false, wantsFuelComponent: Bool = false, withParticleComponentNamed particleComponentName: String? = nil) -> GKEntity {
        
        // Create the box entity and grab its node from the scene.
        let box = GKEntity()
        guard let boxNode = scene.rootNode.childNode(withName: name, recursively: false) else {
            fatalError("Making box with name \(name) failed because the GameScene scene file contains no nodes with that name.")
        }
        
        // Create and attach a geometry component to the box.
        let geometryComponent = GeometryComponent(node: boxNode)
        box.addComponent(geometryComponent)
        
        // If requested, create and attach a particle component.
        if let particleComponentName = particleComponentName {
            let particleComponent = ParticleComponent(particleName: particleComponentName)
            box.addComponent(particleComponent)
        }
        
        // If requested, create and attach a thrust component.
        if wantsThrustComponent {
            let thrustComponent = ThrustComponent(rocketEntity: currentRocket, maxThrust: 2.125, fuelconsumptionRate: 1.0)
            box.addComponent(thrustComponent)
        }
        
        if wantsFuelComponent {
            let fuelComponent = FuelTankComponent(rocket: currentRocket, maxAmount: 20)
            box.addComponent(fuelComponent)
        }
        
        if wantsTorqueComponent {
            let torqueComponent = TorqueComponent(magnitude: 0.2, angularDamping: 0.125)
            box.addComponent(torqueComponent)
        }
        
        return box
    }
}

