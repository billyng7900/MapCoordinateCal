//
//  GravityX.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 23/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class GravityX: NSObject, Gravity
{
    public var isPositive:Bool
    
    init(isPositive:Bool)
    {
        self.isPositive = isPositive
    }
    public func getDegree(lowestPeakLocation:[Int],accelerationListY:[Acceleration],accelerationListX:[Acceleration]) -> Double
    {
        var zVector = Double()
        var yVector = Double()
        if !isPositive
        {
            for var i=0;i<lowestPeakLocation.count;i++
            {
                zVector += accelerationListX[lowestPeakLocation[i]].getAcceleration()
                yVector += accelerationListY[lowestPeakLocation[i]].getAcceleration()
            }
        }
        else
        {
            for var i=0;i<lowestPeakLocation.count;i++
            {
                zVector += accelerationListX[lowestPeakLocation[i]].getAcceleration()
                yVector += -(accelerationListY[lowestPeakLocation[i]].getAcceleration())
            }
        }
        zVector = zVector/Double(lowestPeakLocation.count)
        yVector = yVector/Double(lowestPeakLocation.count)
        var degree = CommonFunction.degreesFromRadians(atan2(zVector, yVector))
        degree = CommonFunction.checkDegree(degree)
        return degree
    }
}