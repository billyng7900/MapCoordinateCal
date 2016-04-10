//
//  GravityX.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 28/3/2016.
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
    public func getDegree(peaksLocation:[Int],accelerationListX:[Acceleration],accelerationListY:[Acceleration],accelerationListZ:[Acceleration],gravityXList:[Double],gravityYList:[Double],gravityZList:[Double]) -> Double
    {
        var zVector:Double = 0
        var yVector:Double = 0
        var sum:Double = 0
        var weight:Double = 0
        if isPositive
        {
            for var i=0;i<peaksLocation.count;i++
            {
                let angleFinder = AngleFinder()
                let angle = CommonFunction.degreesFromRadians(angleFinder.findTiltAngle(gravityXList[peaksLocation[i]]))
                let gravityCal = checkSecondGravity(gravityZList[peaksLocation[i]], yGravity: gravityYList[peaksLocation[i]], zAcceleration: accelerationListZ[peaksLocation[i]].getAcceleration(), yAcceleration: accelerationListY[peaksLocation[i]].getAcceleration(), angle: angle)
                zVector += (gravityCal.getHorizontalAcceleartion())
                yVector += gravityCal.getVerticalAcceleration()
                sum = sum + weight
                if weight < 2
                {
                    weight = weight + 0.3
                }
            }
        }
        else
        {
            for var i=0;i<peaksLocation.count;i++
            {
                let angleFinder = AngleFinder()
                let angle = CommonFunction.degreesFromRadians(angleFinder.findTiltAngle(gravityXList[peaksLocation[i]]))
                let gravityCal = checkSecondGravity(gravityZList[peaksLocation[i]], yGravity: gravityYList[peaksLocation[i]], zAcceleration: accelerationListZ[peaksLocation[i]].getAcceleration(), yAcceleration: accelerationListY[peaksLocation[i]].getAcceleration(), angle: angle)
                zVector += -(gravityCal.getHorizontalAcceleartion())
                yVector += (gravityCal.getVerticalAcceleration())
                sum = sum + weight
                if weight < 2
                {
                    weight = weight + 0.3
                }
            }
        }
        zVector = zVector/sum
        yVector = yVector/sum
        var degree = CommonFunction.degreesFromRadians(atan2(zVector, yVector))
        degree = CommonFunction.checkDegree(degree)
        return degree
    }
    
    public func checkSecondGravity(zGravity:Double,yGravity:Double,zAcceleration:Double,yAcceleration:Double,angle:Double) -> GravityCal
    {
        var gravityCal:GravityCal
        if abs(zGravity) >= abs(yGravity)
        {
            gravityCal = GravityXZ(angle: angle, hAcceleration: zAcceleration, vAcceleration: yAcceleration)
        }
        else
        {
            gravityCal = GravityXY(angle: angle, hAcceleration: zAcceleration, vAcceleration: yAcceleration)
        }
        return gravityCal
    }

}