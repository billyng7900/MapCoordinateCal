//
//  Gravity.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 23/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public protocol Gravity
{
    var isPositive: Bool { get }
    func getDegree(peaksLocation:[Int],accelerationListX:[Acceleration],accelerationListY:[Acceleration],accelerationListZ:[Acceleration],gravityXList:[Double],gravityYList:[Double],gravityZList:[Double]) -> Double
}