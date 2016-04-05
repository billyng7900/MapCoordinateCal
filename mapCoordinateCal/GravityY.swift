//
//  GravityY.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 28/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class GravityY: NSObject, Gravity
{
    public var isPositive:Bool
    
    init(isPositive:Bool)
    {
        self.isPositive = isPositive
    }
    
    public func getDegree(peaksLocation:[Int],accelerationListX:[Acceleration],accelerationListY:[Acceleration],accelerationListZ:[Acceleration],gravityXList:[Double],gravityYList:[Double],gravityZList:[Double]) -> Double
    {
        var xVector:Double = 0
        var zVector:Double = 0
        var sum:Double = 0
        var weight:Double = 0
        if isPositive
        {
            for var i=0;i<peaksLocation.count;i++
            {
                let angleFinder = AngleFinder()
                let angle = CommonFunction.degreesFromRadians(angleFinder.findTiltAngle(gravityYList[peaksLocation[i]]))
                let gravityCal = checkSecondGravity(gravityZList[peaksLocation[i]], xGravity: gravityXList[peaksLocation[i]], zAcceleration: accelerationListZ[peaksLocation[i]].getAcceleration(), xAcceleration: accelerationListX[peaksLocation[i]].getAcceleration(), angle: angle)
                xVector += (gravityCal.getHorizontalAcceleartion())
                zVector += gravityCal.getVerticalAcceleration()
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
                let angle = CommonFunction.degreesFromRadians(angleFinder.findTiltAngle(gravityYList[peaksLocation[i]]))
                let gravityCal = checkSecondGravity(gravityZList[peaksLocation[i]], xGravity: gravityXList[peaksLocation[i]], zAcceleration: accelerationListZ[peaksLocation[i]].getAcceleration(), xAcceleration: accelerationListX[peaksLocation[i]].getAcceleration(), angle: angle)
                xVector += (gravityCal.getHorizontalAcceleartion())
                zVector += -(gravityCal.getVerticalAcceleration())
                sum = sum + weight
                if weight < 2
                {
                    weight = weight + 0.3
                }
            }
        }
        xVector = xVector/sum
        zVector = zVector/sum
        var degree = CommonFunction.degreesFromRadians(atan2(xVector, zVector))
        degree = CommonFunction.checkDegree(degree)
        return degree

    }
    
    public func checkSecondGravity(zGravity:Double,xGravity:Double,zAcceleration:Double,xAcceleration:Double,angle:Double) -> GravityCal
    {
        var gravityCal:GravityCal
        if abs(zGravity) >= abs(xGravity)
        {
            gravityCal = GravityYZ(angle: angle, hAcceleration: xAcceleration, vAcceleration: zAcceleration)
        }
        else
        {
            gravityCal = GravityYX(angle: angle, hAcceleration: xAcceleration, vAcceleration: zAcceleration)
        }
        return gravityCal
    }
    
    public func getVector() -> (Double, Double) {
        return (0.0,0.0)
    }

}
