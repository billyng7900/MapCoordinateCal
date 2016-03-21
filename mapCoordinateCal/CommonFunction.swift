//
//  commonFunction.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 10/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
public class CommonFunction
{
    public static func formatNSDateToSecond(date:NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let formattedDate = formatter.stringFromDate(date)
        return formattedDate
    }
}