//
//  FuelComponent.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class FuelComponent: GKComponent {
    
    //MARK: Properties
    
    /// The max amount of fuel the component holds
    let maxAmount: Double
    
    /// The remaining fuel in the component
    var remainingAmount: Double
    
    /// Determines if the fuel tank is empty
    var isEmpty: Bool { get { return remainingAmount == 0.0 } }
    
    let throttle: ThrottleComponent

    //MARK: -
    //MARK: Methods
    
    init(maxAmount: Double, throttleComponent: ThrottleComponent) {
        self.maxAmount = maxAmount
        self.remainingAmount = maxAmount
        self.throttle = throttleComponent
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func consumeFuel(amount: Double) {
        if remainingAmount > 0.0 {
            remainingAmount = (0.0 ... maxAmount).clamp(remainingAmount - amount)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        consumeFuel(amount: 1 * throttle.percent * seconds)
    }
}
