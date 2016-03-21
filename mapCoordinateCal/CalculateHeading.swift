//
//  CalulateHeading.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 21/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
import CoreMotion

public class CalculateHeading:CalculateHeadingProtocol
{
    private var motionManager = CMMotionManager()
    private static var calculateHeading = CalculateHeading()
    private let deviceMotionUpdateInterval = 0.04
    private let gravity = 9.08665
    private var timer = NSTimer()
    private var accelerationAbsList = [Acceleration]()
    private var accelerationXList = [Acceleration]()
    private var accelerationYList = [Acceleration]()
    private var accelerationZList = [Acceleration]()
    private var previousAbs = Double?()
    private var previousX = Double?()
    private var previousY = Double?()
    private var previousZ = Double?()
    private var accelerometerGravity = [CMAcceleration]()
    private var attitudeList = [Attitude]()
    private var lastPeakCheckingTime:NSDate? = nil
    private let rotationRange = 0.45 //in rad
    private var isRemoving = false
    var delegate: CalculateHeadingDelegate?
    
    private init()
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
                        self.accelerationAbsList.append(Acceleration(acceleration: self.previousAbs!, time: timeNow))
                        self.accelerationAbsList.append(Acceleration(acceleration: self.previousAbs!, time: timeNow))
                        self.accelerationAbsList.append(Acceleration(acceleration: self.previousAbs!, time: timeNow))
                        self.attitudeList.append(Attitude(attitude: (data?.attitude)!, time: timeNow))
                        self.accelerometerGravity.append((data?.gravity)!)
                    }
                }
            })
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkPeak", userInfo: nil, repeats: true)
    }
    
    public func stopUpdateMotionUpdates()
    {
        motionManager.stopAccelerometerUpdates()
        timer.invalidate()
    }
    
    private func lowPassFilter(previous:Double, now:Double, alpha:Double) -> Double
    {
        return 0.04 * previous + (1.0 - 0.04) * now
    }
    
    private func checkPeak()
    {
        let isRotated = getIsRotated()
        lastPeakCheckingTime = NSDate()
        if isRotated
        {
            isRemoving = true //ensure no data is recoded when removing array
            accelerationAbsList.removeAll()
            accelerationXList.removeAll()
            accelerationYList.removeAll()
            accelerationZList.removeAll()
            attitudeList.removeAll()
            isRemoving = false
            
        }
        else
        {
            let peakHelper = PeakHelper()
            let peakLocation = peakHelper.peakFinding(accelerationAbsList)
            let lowestPeakLocation = peakHelper.findLowestPeak(accelerationAbsList, peaksLocation: peakLocation)
        
            delegate?.calculateHeading(self, didUpdateHeadingValue: 123.123)
        }
        
    }
    
    private func findLowestValueWithStartAndEnd(start:Int,end:Int,accelerationList:[Acceleration]) -> Double
    {
        var lowest:Double? = nil
        for var i=start;i<=end;i++
        {
            if lowest == nil
            {
                lowest = accelerationList[i].getAcceleration()
            }
            else
            {
                if accelerationList[i].getAcceleration() < lowest
                {
                    lowest = accelerationList[i].getAcceleration()
                }
            }
        }
        return lowest!
    }
    
    private func medianFilter(valueList:[Double]) -> Double
    {
        //medianFilter
        return 0
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
            if lastPeakCheckingTime!.compare(attitudeList[i].getTime()) != NSComparisonResult.OrderedDescending && timeNow.compare(attitudeList[i].getTime()) != NSComparisonResult.OrderedAscending
            {
                attitudeListPitchWithinTime.append(attitudeList[i].getAttiude().pitch)
                attitudeListRollWithinTime.append(attitudeList[i].getAttiude().roll)
                attitudeListYawWithinTime.append(attitudeList[i].getAttiude().yaw)
            }
        }
        let pitchRange = isMoreThanRange(peakHelper.findLowestAttitude(attitudeListPitchWithinTime), highest: peakHelper.findHighestValue(attitudeListPitchWithinTime))
        let rollRange = isMoreThanRange(peakHelper.findLowestAttitude(attitudeListRollWithinTime), highest: peakHelper.findHighestValue(attitudeListRollWithinTime))
        let yawRange = isMoreThanRange(peakHelper.findLowestAttitude(attitudeListYawWithinTime), highest: peakHelper.findHighestValue(attitudeListYawWithinTime))
        
        if pitchRange && rollRange && yawRange
        {
            return true
        }
        else
        {
            return false
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
    
    private func decideGravityDirection()
    {
        
    }
}