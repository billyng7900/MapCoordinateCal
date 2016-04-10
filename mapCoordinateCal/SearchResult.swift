//
//  searchResult.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 19/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
import CoreLocation
public class SearchResult
{
    private var description:String
    private var formattedAddress:String
    private var placeId:String
    
    public func getPlaceCoordinate() -> CLLocationCoordinate2D
    {
        var coordinate = CLLocationCoordinate2D()
        let requestURL: NSURL = NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=AIzaSyC-Nx-rs9WG01HZ-peeCvq-NqPAMxILTAE")!
        let data=NSData(contentsOfURL:requestURL)
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            if let result = json["result"] as? [String: AnyObject]
            {
                if let geometry = result["geometry"] as? [String: AnyObject]
                {
                    if let location = geometry["location"] as? [String: AnyObject]
                    {
                        if let lat = location["lat"] as? Double
                        {
                            if let lng = location["lng"] as? Double
                            {
                                coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lng))
                            }
                        }
                    }
                    
                }
            }
        }
        catch
        {
            
        }
        return coordinate
    }
    
    init(prediction:Dictionary<String,AnyObject>)
    {
        var terms = [[String: AnyObject]]()
        var place = String()
        if let term = prediction["terms"] as? [[String: AnyObject]]
        {
            terms = term
        }
        if let placeId = prediction["place_id"] as? String
        {
            place = placeId
        }
        var formattedAddress = ""
        self.description = (terms[0]["value"] as? String)!
        for var i=1;i<terms.count;i++
        {
            if i == 1
            {
                formattedAddress = formattedAddress + (terms[i]["value"] as? String)!
            }
            else
            {
                formattedAddress = formattedAddress + ", " + (terms[i]["value"] as? String)!
            }
        }
        self.placeId = place
        self.formattedAddress = formattedAddress
    }
    
    public func getDescription() -> String
    {
        return description
    }
    
    public func getFormattedAddress() -> String
    {
        return formattedAddress
    }
    
    public func getPlaceId() -> String
    {
        return placeId
    }
}
