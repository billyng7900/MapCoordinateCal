//
//  CalulateHeading.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 21/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
import CoreMotion

public class CalculateHeading:NSObject, CalculateHeadingProtocol
{
    private var motionManager = CMMotionManager()
    private static var calculateHeading = CalculateHeading()
    private let deviceMotionUpdateInterval = 0.04
    private let gravity = 9.80665
    private var timer = NSTimer()
    private var accelerationAbsList = [Acceleration]()
    private var accelerationXList = [Acceleration]()
    private var accelerationYList = [Acceleration]()
    private var accelerationZList = [Acceleration]()
    private var previousAbs = Double?()
    private var previousX = Double?()
    private var previousY = Double?()
    private var previousZ = Double?()
    private var attitudeList = [Attitude]()
    private var lastPeakCheckingTime:NSDate? = nil
    private let rotationRange = 0.45 //in rad
    private var isRemoving = false
    private var gravityX = Double?()
    private var gravityY = Double?()
    private var gravityZ = Double?()
    private var gravityXList = [Double]()
    private var gravityYList = [Double]()
    private var gravityZList = [Double]()
    private var updatedCount = 0
    private var previousHeading:Double = 0
    private var startTime = NSDate?()
    private var isFirstPeakDetected = false
    var delegate: CalculateHeadingDelegate?
    
    override init()
    {
        
    }
    
    public static func getCalculateHeading() -> CalculateHeading
    {
        return calculateHeading
    }
    
    public func startMotionUpdates()
    {
        if motionManager.deviceMotionAvailable
        {
            motionManager.deviceMotionUpdateInterval = deviceMotionUpdateInterval//25Hz
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkPeak", userInfo: nil, repeats: true)
            motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(data,error) -> Void in
                let timeNow = NSDate()
                let accelerationX = (data?.userAcceleration.x)! * self.gravity
                let accelerationY = (data?.userAcceleration.y)! * self.gravity
                let accelerationZ = (data?.userAcceleration.z)! * self.gravity
                let accelerationAbs = abs(accelerationX)+abs(accelerationY)+abs(accelerationZ)
                if self.previousAbs == nil
                {
                    self.previousAbs = 0
                    self.previousX = 0
                    self.previousY = 0
                    self.previousZ = 0
                }
                else
                {
                    self.previousAbs = accelerationAbs
                    self.previousX = self.lowPassFilter(self.previousX!, now: accelerationX, alpha: 0.04)
                    self.previousY = self.lowPassFilter(self.previousY!, now: accelerationY, alpha: 0.04)
                    self.previousZ = self.lowPassFilter(self.previousZ!, now: accelerationZ, alpha: 0.04)
                    if !self.isRemoving
                    {
                        self.accelerationAbsList.append(Acceleration(acceleration: self.previousAbs!, time: timeNow))
                        self.accelerationXList.append(Acceleration(acceleration: self.previousX!, time: timeNow))
                        self.accelerationYList.append(Acceleration(acceleration: self.previousY!, time: timeNow))
                        self.accelerationZList.append(Acceleration(acceleration: self.previousZ!, time: timeNow))
                        self.attitudeList.append(Attitude(attitude: (data?.attitude)!, time: timeNow))
                        self.gravityX = (data?.gravity.x)!
                        self.gravityXList.append(self.gravityX! * self.gravity)
                        self.gravityY = (data?.gravity.y)!
                        self.gravityYList.append(self.gravityY! * self.gravity)
                        self.gravityZ = (data?.gravity.z)!
                        self.gravityZList.append(self.gravityZ! * self.gravity)
                    }
                }
            })
        }
        
    }
    
    public func stopUpdateMotionUpdates()
    {
        motionManager.stopAccelerometerUpdates()
        accelerationAbsList.removeAll()
        accelerationXList.removeAll()
        accelerationYList.removeAll()
        accelerationZList.removeAll()
        attitudeList.removeAll()
        timer.invalidate()
    }
    
    private func lowPassFilter(previous:Double, now:Double, alpha:Double) -> Double
    {
        return 0.04 * previous + (1.0 - 0.04) * now
    }
    
    public func checkPeak()
    {
        let gravityXWhenChecking = gravityX
        let gravityYWhenChecking = gravityY
        let gravityZWhenChecking = gravityZ
        timer.invalidate()
        if accelerationAbsList.isEmpty
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkPeak", userInfo: nil, repeats: true)
            return
        }
        var isRotated = false
        if lastPeakCheckingTime != nil
        {
            isRotated = getIsRotated()
        }
        lastPeakCheckingTime = NSDate()
        if isRotated
        {
            isRemoving = true //ensure no data is recoded when removing array
            accelerationAbsList.removeAll()
            accelerationXList.removeAll()
            accelerationYList.removeAll()
            accelerationZList.removeAll()
            attitudeList.removeAll()
            if updatedCount >= 5
            {
                delegate?.calculateHeading(self, didRotatedDevice: true, previousHeading: previousHeading,previousStartTime: startTime!)
            }
            else
            {
                delegate?.calculateHeading(self, didRotatedDevice: false, previousHeading: previousHeading,previousStartTime: startTime!)
            }
            isRemoving = false
            updatedCount = 0
            isFirstPeakDetected = false
            startTime = NSDate()
        }
        else
        {
            let peakHelper = PeakHelper()
            let peakLocation = peakHelper.peakFinding(accelerationAbsList)
            if peakLocation.count >= 1
            {
                if !isFirstPeakDetected
                {
                    isFirstPeakDetected = true
                    startTime = NSDate()
                }
                let gravity = decideGravityDirection(gravityXWhenChecking!, y: gravityYWhenChecking!, z: gravityZWhenChecking!)
                
                let lowestPeakLocation = peakHelper.findLowestPeak(accelerationAbsList, peaksLocation: peakLocation)
                var degree = Double()
                    degree = gravity.getDegree(lowestPeakLocation,peaksLocation: peakLocation, accelerationListX: accelerationXList, accelerationListY: accelerationYList, accelerationListZ: accelerationZList, gravityXList: gravityXList, gravityYList: gravityYList, gravityZList: gravityZList)
                let (xVector,yVector) = gravity.getVector()
                delegate?.calculateHead(self, didVectorUpdated: xVector, secondVector: yVector, headingValue: degree)
                updatedCount++
                if updatedCount == 5
                {
                    delegate?.calculateHeading(self, didUpdateHeadingValue: degree, startTime: startTime!)
                    previousHeading = degree
                }
            }
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkPeak", userInfo: nil, repeats: true)
    }
    
    private func sorting(v1:Double,v2:Double) -> Bool
    {
        return v1 < v2
    }
    
    private func toMedianFilter(valueList:[Double]) -> Double
    {
        var result = Double()
        if valueList.count == 1
        {
            result = valueList[0]
            return result
        }
        var extensionList = [Double]()
        for var i=0;i<valueList.count;i++
        {
            extensionList.append(valueList[i])
        }
        extensionList.insert(valueList[extensionList.count-1], atIndex: extensionList.count-1)
        extensionList.insert(valueList[0], atIndex: 0)
        
        var resultArray = medianFilter(extensionList)
        let finalArray = resultArray.sort(sorting)
        if finalArray.count % 2 == 0
        {
            result = (Double(finalArray[finalArray.count/2]) + Double(finalArray[finalArray.count/2 - 1]))/2
        }
        else
        {
            result = Double(finalArray[finalArray.count/2])
        }
        return result
    }
    
    private func medianFilter(valueList:[Double]) -> [Double]
    {
        //medianFilter
        var resultList = [Double]()
        for var i=1; i<valueList.count-1; i++
        {
            var result = [Double]()
            for var j=i-1;j<i+2;j++
            {
                result.append(valueList[j])
            }
            let resultSorted = result.sort(sorting)
            resultList.append(resultSorted[resultSorted.count/2])
        }
        return resultList
    }
    
    private func getIsRotated() -> Bool
    {
        let peakHelper = PeakHelper()
        let timeNow = NSDate()
        var attitudeListPitchWithinTime = [Double]()
        var attitudeListRollWithinTime = [Double]()
        var attitudeListYawWithinTime = [Double]()
        for var i=0;i<attitudeList.count;i++
        {
            //if lastPeakCheckingTime!.compare(attitudeList[i].getTime()) != NSComparisonResult.OrderedDescending && timeNow.compare(attitudeList[i].getTime()) != NSComparisonResult.OrderedAscending
            //{
                attitudeListPitchWithinTime.append(attitudeList[i].getAttiude().pitch)
                attitudeListRollWithinTime.append(attitudeList[i].getAttiude().roll)
                attitudeListYawWithinTime.append(attitudeList[i].getAttiude().yaw)
            //}
        }
        let pitchRange = isMoreThanRange(peakHelper.findLowestAttitude(attitudeListPitchWithinTime), highest: peakHelper.findHighestValue(attitudeListPitchWithinTime))
        let rollRange = isMoreThanRange(peakHelper.findLowestAttitude(attitudeListRollWithinTime), highest: peakHelper.findHighestValue(attitudeListRollWithinTime))
        let yawRange = isMoreThanRange(peakHelper.findLowestAttitude(attitudeListYawWithinTime), highest: peakHelper.findHighestValue(attitudeListYawWithinTime))
        
        if !pitchRange && !rollRange && !yawRange
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    private func isMoreThanRange(lowest:Double,highest:Double) -> Bool
    {
        if highest - lowest > rotationRange
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    private func decideGravityDirection(x:Double,y:Double,z:Double) -> Gravity
    {
        let Absx = abs(x)
        let Absy = abs(y)
        let Absz = abs(z)
        var gravity:Gravity
        if Absx > Absy && Absx > Absz
        {
            gravity = GravityX(isPositive:x > 0)
        }
        else if Absy > Absx && Absy > Absz
        {
            gravity = GravityY(isPositive:y > 0)
        }
        else
        {
            gravity = GravityZ(isPositive:z > 0)
        }
        
        return gravity
    }
}