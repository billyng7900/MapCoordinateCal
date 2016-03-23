//
//  BearingList.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 10/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class BearingCollection
{
    static var bearingCollection = BearingCollection()
    var bearingList = [Bearing]()
    
    private init()
    {
        
    }
    
    public static func getBearingCollection() -> BearingCollection
    {
        return bearingCollection
    }
    
    public func appendBearingList(bearing:Double, time:NSDate)
    {
        let bearing = Bearing(bearing: bearing, time: time)
        bearingList.append(bearing)
    }
    
    public func mapBearingRecordFromDate(time:NSDate) -> Bearing
    {
        let timeDateString = CommonFunction.formatNSDateToSecond(time)//HH:mm:ss
        for bearing in bearingList
        {
            let bearingDateString = CommonFunction.formatNSDateToSecond(bearing.getDate())
            if bearingDateString == timeDateString
            {
                return bearing
            }
        }
        return bearingList.last!
    }
    
    public func isEmpty() -> Bool
    {
        return bearingList.isEmpty
    }
}