//
//  GravityCal.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 28/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation

public protocol GravityCal
{
    var angle:Double {get}
    var hAcceleration:Double {get}
    var vAcceleration:Double {get}
    
    func getVerticalAcceleration() -> Double
    
    func getHorizontalAcceleartion() -> Double

}