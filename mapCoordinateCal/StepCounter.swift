//
//  StepCounter.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 8/4/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
import CoreMotion

public class StepCounter
{
    let pedoMeter = CMPedometer()
    let calculateHeading = CalculateHeading.getCalculateHeading()
    func startStepCounter()
    {
        if CMPedometer.isStepCountingAvailable()
        {
            pedoMeter.startPedometerUpdatesFromDate(NSDate(), withHandler: {(data:CMPedometerData?, error:NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil)
                    {
                        if !self.calculateHeading.isHeadCalculationEnabled()
                        {
                            //self.isHeadingCalculationEnabled = true
                            self.calculateHeading.startMotionUpdates()
                        }
                        let changeDistance = Double(data!.distance!) - self.totalDistanceCount
                        if !self.bearingCollection.isBearingListEmpty() && changeDistance > 0
                        {
                            self.timerForHeadingCalculation?.invalidate()
                            let bearingRecord = self.bearingCollection.mapBearingRecordFromDate(NSDate())
                            self.stepCollection.appendStepList(changeDistance, endDate: data!.endDate, bearing: 360 - Double(bearingRecord.getBearing()))
                            if self.calculateLocation!.isLocationUpdateStopped() && self.isAllowedToDrawLine
                            {
                                self.drawWalkingLine()
                            }
                            self.timerForHeadingCalculation = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "stopHeadingCalculation", userInfo: nil, repeats: false)
                        }
                        self.totalDistanceCount = Double(data!.distance!)
                    }
                })
            })
        }
        
    }

}