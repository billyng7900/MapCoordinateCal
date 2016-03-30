//
//  peakHelper.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 21/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public class PeakHelper
{
    private let peakThreshold = 2.8//based on testing
    
    public func peakFinding(accelerationAbsList:[Acceleration]) -> [Int]
    {
        var peaks = [Acceleration]()
        var peaksLocation = [Int]()
        var peaksCount = 0
        for var i=1; i<accelerationAbsList.count-1;i++
        {
            if accelerationAbsList[i].getAcceleration() > peakThreshold
            {
                if accelerationAbsList[i].getAcceleration() > accelerationAbsList[i+1].getAcceleration() && accelerationAbsList[i-1].getAcceleration() < accelerationAbsList[i].getAcceleration()
                {
                    peaks.append(accelerationAbsList[i])
                    peaksLocation.append(i)
                }
            }
        }
        var toBeRemoved = [Int]()
        for var i=0;i<peaks.count-1;i++
        {
            let peak1 = peaks[i]
            let peak1Location = peaksLocation[i]
            for var j=i+1;j<peaks.count;j++
            {
                let peak2 = peaks[j]
                let peak2Location = peaksLocation[j]
                let weakerPeak:Int
                if peak2Location - peak1Location < 9
                {
                    if peak2.getAcceleration() > peak1.getAcceleration()
                    {
                        weakerPeak = peak1Location
                    }
                    else
                    {
                        weakerPeak = peak2Location
                    }
                    toBeRemoved.append(weakerPeak)
                }
            }
        }
        var finalPeakLocation = [Int]()
        for var i=0; i<peaks.count;i++ //since array element cannot be removed by another array
        {
            var isToBeRemoved = false
            for var j=0;j<toBeRemoved.count;j++
            {
                if peaksLocation[i] == toBeRemoved[j]
                {
                    isToBeRemoved = true
                }
            }
            if !isToBeRemoved
            {
                finalPeakLocation.append(peaksLocation[i])
            }
        }
        return finalPeakLocation
    }
    
    public func findLowestPeak(accelerationAbsList:[Acceleration],peaksLocation:[Int]) -> [Int]
    {
        var lowestPeakList = [Acceleration]()
        var lowestPeakLocationList = [Int]()
        for var i=0; i<peaksLocation.count-1; i++
        {
            let peak1Location = peaksLocation[i]
            let peak2Location = peaksLocation[i+1]
            var lowestPeak:Acceleration? = nil
            var lowestPeakLocation:Int? = nil
            if peak2Location - peak1Location < 30
            {
                for var j=peak1Location+1; j<peak2Location;j++
                {
                    if accelerationAbsList[j].getAcceleration() < accelerationAbsList[j-1].getAcceleration() && accelerationAbsList[j].getAcceleration() < accelerationAbsList[j+1].getAcceleration()
                    {
                        if lowestPeak == nil
                        {
                            lowestPeak = accelerationAbsList[j]
                            lowestPeakLocation = j
                        }
                        else
                        {
                            if accelerationAbsList[j].getAcceleration() > lowestPeak?.getAcceleration()
                            {
                                lowestPeak = accelerationAbsList[j]
                                lowestPeakLocation = j
                            }
                        }
                    }
                }
                lowestPeakList.append(lowestPeak!)
                lowestPeakLocationList.append(lowestPeakLocation!)
            }
        }
        return lowestPeakLocationList
    }
    
    public func findMedianBetweenPeaks(lowestPeakLocation:[Int],peaksLocation:[Int]) -> [Int]
    {
        var medianPeaksLocation = [Int]()
        for var i=0;i<lowestPeakLocation.count;i++
        {
            let peakLocation = peaksLocation[i+1]
            let lowestLocation = lowestPeakLocation[i]
            let median = (peakLocation - lowestLocation)/2
            medianPeaksLocation.append(lowestLocation+median)
        }
        return medianPeaksLocation
    }
    
    public func findLowestAttitude(valueList:[Double]) -> Double
    {
        var lowest:Double? = nil
        for var i=0;i<valueList.count;i++
        {
            if lowest == nil
            {
                lowest = valueList[i]
            }
            else
            {
                if valueList[i] < lowest
                {
                    lowest = valueList[i]
                }
            }
        }
        return lowest!
    }
    
    public func findHighestValue(valueList:[Double]) -> Double
    {
        var highest:Double? = nil
        for var i=0;i<valueList.count;i++
        {
            if highest == nil
            {
                highest = valueList[i]
            }
            else
            {
                if valueList[i] > highest
                {
                    highest = valueList[i]
                }
            }
        }
        return highest!
    }
}