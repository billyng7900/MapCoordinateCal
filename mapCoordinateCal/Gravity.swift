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
    func getDegree(lowestPeakLocation:[Int],accelerationListY:[Acceleration],accelerationListX:[Acceleration],gravity1List:[Double],gravity2List:[Double]) -> Double
}