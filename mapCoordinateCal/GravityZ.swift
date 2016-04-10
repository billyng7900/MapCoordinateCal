//
//  GravityZ.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 28/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class GravityZ: NSObject, Gravity
{
    public var isPositive:Bool
    public var finalxVector:Double = 0
    public var finalyVector:Double = 0
    init(isPositive:Bool)
    {
        self.isPositive = isPositive
    }
    
    public func getDegree(peaksLocation:[Int],accelerationListX:[Acceleration],accelerationListY:[Acceleration],accelerationListZ:[Acceleration],gravityXList:[Double],gravityYList:[Double],gravityZList:[Double]) -> Double
    {
        //let peakHelper = PeakHelper()
        //let medianLocation = peakHelper.findMedianBetweenPeaks(lowestPeakLocation, peaksLocation: peaksLocation)
        var xVector:Double = 0
        var yVector:Double = 0
        var sum:Double = 0
        var weight:Double = 1
        if !isPositive
        {
            for var i=0;i<peaksLocation.count;i++
            {
                let angleFinder = AngleFinder()
                let angle = CommonFunction.degreesFromRadians(angleFinder.findTiltAngle(gravityZList[peaksLocation[i]]))
                let gravityCal = checkSecondGravity(gravityYList[peaksLocation[i]], xGravity: gravityXList[peaksLocation[i]], yAcceleration: accelerationListY[peaksLocation[i]].getAcceleration(), xAcceleration: accelerationListX[peaksLocation[i]].getAcceleration(), angle: angle)
                xVector += (gravityCal.getHorizontalAcceleartion()) * weight
                yVector += (gravityCal.getVerticalAcceleration()) * weight
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
                let angle = CommonFunction.degreesFromRadians(angleFinder.findTiltAngle(gravityZList[peaksLocation[i]]))
                let gravityCal = checkSecondGravity(gravityYList[peaksLocation[i]], xGravity: gravityXList[peaksLocation[i]], yAcceleration: accelerationListY[peaksLocation[i]].getAcceleration(), xAcceleration: accelerationListX[peaksLocation[i]].getAcceleration(), angle: angle)
                xVector += -(gravityCal.getHorizontalAcceleartion()) * weight
                yVector += (gravityCal.getVerticalAcceleration()) * weight
                sum = sum + weight
                if weight < 2
                {
                    weight = weight + 0.3
                }
            }
        }
        xVector = xVector/sum
        yVector = yVector/sum
        finalxVector = xVector
        finalyVector = yVector
        var degree = CommonFunction.degreesFromRadians(atan2(xVector, yVector))
        degree = CommonFunction.checkDegree(degree)
        return degree
    }
    
    public func checkSecondGravity(yGravity:Double,xGravity:Double,yAcceleration:Double,xAcceleration:Double,angle:Double) -> GravityCal
    {
        var gravityCal:GravityCal
        if abs(yGravity) >= abs(xGravity)
        {
            gravityCal = GravityZY(angle: angle, hAcceleration: xAcceleration, vAcceleration: yAcceleration)
        }
        else
        {
            gravityCal = GravityZX(angle: angle, hAcceleration: xAcceleration, vAcceleration: yAcceleration)
        }
        return gravityCal
    }
}
