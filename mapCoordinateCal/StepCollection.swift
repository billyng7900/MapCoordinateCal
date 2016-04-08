//
//  StepCollection.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 10/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public class StepCollection
{
    static private var stepCollection = StepCollection()
    var stepList = [Step]()
    private init()
    {
        
    }
    
    public static func getStepCollection() -> StepCollection
    {
        return stepCollection
    }
    
    public func appendStepList(distance:Double, endDate:NSDate, bearing:Double)
    {
        var altitudeChange:Double
        let altitudeCollection = AltitudeCollection.getAltitudeCollection()
        if altitudeCollection.isAltitudeListEmpty()
        {
            altitudeChange = 0.0
        }
        else if stepList.isEmpty//no last step record
        {
            //should determine the start time of user first step, then the last step
            altitudeChange = 0.0
        }
        else
        {
            altitudeChange = altitudeCollection.getAccumulatedAltitudeChange((stepList.last?.getEndDate())!, timeEnd: endDate)
        }
        let step:Step = Step(distance: distance, endDate: endDate, altitudeChange: altitudeChange, bearing: bearing)
        stepList.append(step)
    }
    
    func findStepRecordAfterDate(targetDate:NSDate) -> [Step]
    {
        var stepRecordAfterDate = [Step]()
        
        for step in stepList
        {
            if targetDate.compare(step.getEndDate()) != NSComparisonResult.OrderedDescending//if step record after or equal to the target date
            {
                stepRecordAfterDate.append(step)
            }
        }
        return stepRecordAfterDate
    }
    
    func isStepListEmpty() -> Bool
    {
        return stepList.isEmpty
    }
}