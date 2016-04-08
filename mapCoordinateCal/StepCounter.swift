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
    private var stepCounter = StepCounter()
    let pedoMeter = CMPedometer()
    let calculateHeading = CalculateHeading()
    var totalDistanceCount:Double = 0.0
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
                            self.calculateHeading.startMotionUpdates()
                        }
                        let pace = data!.currentPace != nil ? data!.currentPace : nil
                        let cadence = data!.currentCadence != nil ? data!.currentCadence : nil
                        let changeDistance = Double(data!.distance!) - self.totalDistanceCount
                        if !self.bearingCollection.isEmpty() && changeDistance > 0
                        {
                            self.timerForHeadingCalculation?.invalidate()
                            let bearingRecord = self.bearingCollection.mapBearingRecordFromDate(NSDate())
                            self.stepCollection.appendStepList(Int(data!.numberOfSteps), distance:changeDistance, startDate: data!.startDate, endDate: data!.endDate, pace: pace, cadence: cadence, bearing: 360 - Double(bearingRecord.getBearing()))
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