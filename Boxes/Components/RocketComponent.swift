//
//  BaseComponent.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/12/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class RocketComponent: GKComponent {
    
    /// A pointer to the rocket the component is used on.
    var rocketEntity: RocketEntity?
    
    init(rocket: RocketEntity? = nil) {
        self.rocketEntity = rocket
        
        super .init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
