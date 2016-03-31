//
//  CorrectionHeadingCollection.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 30/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class CorrectionHeadingCollection
{
    static var correctionHeadingCollection = CorrectionHeadingCollection()
    var correctionHeadingList:[CorrectionHeading] = []
    
    private init(){}
    
    public static func getCorrectionHeadingCollection() -> CorrectionHeadingCollection
    {
        return correctionHeadingCollection
    }
    
    public func appendCorrectionHeading(heading:Double,startTime:NSDate)
    {
        let correctionHeading = CorrectionHeading(heading: heading, startTime: startTime)
        correctionHeadingList.append(correctionHeading)
    }
    
    public func mapCorrectionHeadingtoStepRecord(stepTime:NSDate) -> Double
    {
        var mappedHeading = correctionHeadingList.first
        if mappedHeading == nil
        {
            return 0.0
        }
        for correctionHeading in correctionHeadingList
        {
            if correctionHeading.startTime.compare(stepTime) != NSComparisonResult.OrderedDescending
            {
                if mappedHeading!.startTime.compare(correctionHeading.startTime) != NSComparisonResult.OrderedDescending
                {
                    mappedHeading = correctionHeading
                }
            }
        }
        return (mappedHeading?.heading)!
    }
}