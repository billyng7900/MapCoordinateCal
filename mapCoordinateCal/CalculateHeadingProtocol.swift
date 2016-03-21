//
//  CalculateHeadingProtocol.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 21/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

protocol CalculateHeadingProtocol
{
    func startMotionUpdates()
    func stopUpdateMotionUpdates()
}

protocol CalculateHeadingDelegate
{
    func calculateHeading(calculateHeading:CalculateHeadingProtocol, didUpdateHeadingValue: Double)
    func calculateHeading(CalculateHeading:CalculateHeadingProtocol, didRotatedDevice:Bool)
}
