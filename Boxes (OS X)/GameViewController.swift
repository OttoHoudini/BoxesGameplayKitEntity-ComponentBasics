/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    An `NSViewController` subclass that stores references to game-wide input sources and managers.
*/

import SceneKit

class GameViewController: NSViewController {
    // MARK: Properties
    
    let game = Game()
//    var modifierPressed: ?
    
    // MARK: Methods
    
    override func viewDidLoad() {
        // Grab the controller's view as a SceneKit view.
        guard let scnView = view as? SCNView else { fatalError("Unexpected view class") }
        
        // Set our background color to a light gray color.
        scnView.backgroundColor = NSColor.lightGray
        
        // Ensure the view controller can display our game's scene.
        scnView.scene = game.scene
        
        // Ensure the game can manage updates for the scene.
        scnView.delegate = game
        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(target: self, action: #selector(handleClick(_:)))
        clickGesture.buttonMask = 0x2
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
    }
    
    override func flagsChanged(with event: NSEvent) {
        if event.modifierFlags.contains(NSEvent.ModifierFlags.shift) {
            game.setThrottle(state: .up)

        } else if event.modifierFlags.contains(NSEvent.ModifierFlags.control) {
            game.setThrottle(state: .down)

        } else {
            game.setThrottle(state: .hold)
        }
    }
    
    
    override func keyDown(with event: NSEvent) {
        if event.characters == "z" {
            game.setThrottle(state: .off)
        }
    }

    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are clicked
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            game.controlEntityWith(node: hitResults.first!.node)
        }
    }
}
