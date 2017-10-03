/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Handles logic controlling the scene. Primarily, it initializes the game's entities and components structure, and handles game updates.
*/

import SceneKit
import GameplayKit

class Game: NSObject, SCNSceneRendererDelegate {
    // MARK: Properties
    
    /// The scene that the game controls.
    let scene = SCNScene(named: "GameScene.scn")!
    
    /**
        Manages all of the player control components, allowing you to access all 
        of them in one place.
    */
    let playerControlComponentSystem = GKComponentSystem(componentClass: PlayerControlComponent.self)
    
    /**
        Manages all of the particle components, allowing you to update all of 
        them synchronously.
    */
    let particleComponentSystem = GKComponentSystem(componentClass: ParticleComponent.self)

    /// Holds the box entities, so they won't be deallocated.
    var boxEntities = [GKEntity]()
    var controlledBox = GKEntity()
    
    /// Keeps track of the time for use in the update method.
    var previousUpdateTime: TimeInterval = 0
    
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
        let redBoxEntity = BoxEntity.init(forNodeWithColor: NSColor.red)
        
        let yellowBoxEntity = BoxEntity.init(forNodeWithColor: NSColor.yellow, withParticleComponentNamed: "Fire")
        
        let greenBoxEntity = BoxEntity.init(forNodeWithColor: NSColor.green, wantsPlayerControlComponent: true)
        
        let blueBoxEntity = BoxEntity.init(forNodeWithColor: NSColor.blue, wantsPlayerControlComponent: true, withParticleComponentNamed: "Sparkle")
        
        // Keep track of all the newly-created box entities.
        boxEntities = [
            redBoxEntity,
            yellowBoxEntity,
            greenBoxEntity,
            blueBoxEntity,
        ]
        
        controlledBox = greenBoxEntity
    }
    
    /**
        Checks each box for components. If a box has a particle and/or player 
        control component, it is added to the appropriate component system.
        Since the methods `jumpBoxes(_:)` and `renderer(_:)` use component
        systems to reference components, a component will not properly affect 
        the scene unless it is added to one of these systems.
    */
    func addComponentsToComponentSystems() {
        for box in boxEntities {
            particleComponentSystem.addComponent(foundIn: box)
            playerControlComponentSystem.addComponent(foundIn: box)
        }
    }
    
    // MARK: Methods
    
    /**
        Causes each box controlled by an entity with a playerControlComponent 
        to jump.
    */
    func jumpBoxes() {
        /*
            Iterate over each component in the component system that is a
            PlayerControlComponent.
        */
        for case let component as PlayerControlComponent in playerControlComponentSystem.components {
            component.jump()
        }
    }
    
    func controlEntityWith(node: SCNNode) {
        if let boxEntity = boxEntities.first(where: {$0.component(ofType: GeometryComponent.self)?.node == node}) {
            controlledBox = boxEntity
            
            highlight(node: node)
        }
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
     Causes the currently controlled box controlled by an entity with a playerControlComponent
     to jump.
     */
    func jumpBox() {
        /*
         Iterate over each component in the component system that is a
         PlayerControlComponent.
         */
        for case let component as PlayerControlComponent in controlledBox.components {
            component.jump()
        }
    }
    
    /**
        Updates every frame, and keeps components in the particle component 
        system up to date.
    */
    func renderer(_: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // Calculate the time change since the previous update.
        let timeSincePreviousUpdate = time - previousUpdateTime
        
        // Update the particle component system with the time change.
        particleComponentSystem.update(deltaTime: timeSincePreviousUpdate)
        
        // Update the previous update time to keep future calculations accurate.
        previousUpdateTime = time
    }
}
