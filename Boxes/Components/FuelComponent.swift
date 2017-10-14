//
//  FuelComponent.swift
//  Boxes
//
//  Created by Jeffery Jensen on 10/8/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import GameplayKit

class FuelComponent: RocketComponent {
    
    //MARK: Properties
    
    /// The max amount of fuel the component holds
    let maxAmount: Double
    
    /// The remaining fuel in the component
    var remainingAmount: Double
    
    //MARK: -
    //MARK: Methods
    
    init(rocket: RocketEntity? = nil, maxAmount: Double) {
        self.maxAmount = maxAmount
        self.remainingAmount = maxAmount
        
        super.init()

        self.rocketEntity = rocket
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard remainingAmount > 0.0, let rocket = rocketEntity else { return }
        
        let consumedAmount = rocket.fuelConsumptionRate() * rocket.throttlePercent * seconds
        remainingAmount = (0.0 ... maxAmount).clamp(remainingAmount - consumedAmount)
    }
}
