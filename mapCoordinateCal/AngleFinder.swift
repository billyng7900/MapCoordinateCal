//
//  AngleFiner.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 25/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public class AngleFinder
{
    public func findTiltAngle(var gravityAngle:Double) -> Double
    {
        gravityAngle = abs(gravityAngle)
        return acos(gravityAngle/9.08665)
    }
    
    public func findCloserAngleAverage(degreeList:[Double]) -> Double
    {
        var x:Double = 0
        var y:Double = 0
        for var i=0;i<degreeList.count;i++
        {
            x += cos(CommonFunction.radiansFromDegrees(degreeList[i]))
            y += sin(CommonFunction.radiansFromDegrees(degreeList[i]))
        }
        var degree = CommonFunction.degreesFromRadians(atan2(y/Double(degreeList.count), x/Double(degreeList.count)))
        degree = CommonFunction.checkDegree(degree)
        return degree
        /*var sunSin:Double = 0
        var sunCos:Double = 0
        var counter = 0
        for degree in degreeList
        {
            let angle = degree * M_PI/180
            sunSin += sin(angle)
            sunCos += cos(angle)
            counter++
        }
        var avBearing:Double = 0
        if counter > 0
        {
            var bearingInRad = atan2(sunSin/Double(counter), sunCos/Double(counter))
            avBearing = (bearingInRad * 180)/M_PI
            if avBearing < 0
            {
                avBearing += 360
            }
        }
        return avBearing
        var angleY:Double = 0
        for var i=0;i<degreeList.count;i++
        {
            angleY += degreeList[i]
        }
        let averageAngle = angleY/Double(degreeList.count)
        angleY = 0
        for var i=0;i<degreeList.count;i++
        {
            var angle = degreeList[i]
            if angle < averageAngle
            {
                angle += 360
            }
            angleY += angle
        }
        angleY = angleY/Double(degreeList.count)
        return angleY*/
    }
}