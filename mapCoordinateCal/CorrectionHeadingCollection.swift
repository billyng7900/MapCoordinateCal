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
        if correctionHeadingList.count == 0
        {
            return 0.0
        }
        var mappedHeading = correctionHeadingList.first
        var mappedHeadingNumber:Double = 0.0
        for correctionHeading in correctionHeadingList
        {
            if correctionHeading.startTime.compare(stepTime) != NSComparisonResult.OrderedDescending
            {
                if mappedHeading!.startTime.compare(correctionHeading.startTime) != NSComparisonResult.OrderedDescending
                {
                    mappedHeading = correctionHeading
                    mappedHeadingNumber = correctionHeading.heading
                }
            }
        }
        return mappedHeadingNumber
    }
}