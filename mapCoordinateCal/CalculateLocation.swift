//
//  CalculateLocation.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 24/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public class CalculateLocation
{
    var stepCollection = StepCollection.getStepCollection()
    var mapView:MKMapView
    var lastGPSLocation:CLLocationCoordinate2D?
    var locationUpdateisStopped = false
    var locationStoppedTime:NSDate?
    
    init(mapView:MKMapView)
    {
        self.mapView = mapView
    }
    
    func startLocationCal(lastGPSLocation:CLLocationCoordinate2D, locationStoppedTime:NSDate)
    {
        locationUpdateisStopped = true
        self.lastGPSLocation = lastGPSLocation
        self.locationStoppedTime = locationStoppedTime
        mapView.showsUserLocation = false
        addUserLastMapAnnotation()
    }
    
    func stopLocationCal()
    {
        locationUpdateisStopped = false
        self.lastGPSLocation = nil
        self.locationStoppedTime = nil
        removeAnnotationWithoutUserLocation()
        mapView.showsUserLocation = true

    }
    
    func isLocationUpdateStopped() -> Bool
    {
        return locationUpdateisStopped
    }
    
    func addUserLastMapAnnotation()
    {
        removeAnnotationWithoutUserLocation()
        let locationPin = Annotation(coordinate: lastGPSLocation!, title: "Last Accurate User Location", subtitle: "This Location is retrieved by GPS", type: AnnotationType.AnnotationUserLastLocation)
        locationPin.coordinate = (lastGPSLocation)!
        self.mapView.addAnnotation(locationPin)
        
    }
    
    func removeAnnotationWithoutUserLocation()
    {
        var annotationsToBeRemoved = [MKAnnotation]()
        for annotation in self.mapView.annotations
        {
            if !(annotation is MKUserLocation)
            {
                annotationsToBeRemoved.append(annotation)
            }
        }
        self.mapView.removeAnnotations(annotationsToBeRemoved)
    }
    
    func convertStepListToCoordinate() -> [CLLocationCoordinate2D]
    {
        let stepListAfterStopped = stepCollection.findStepRecordAfterDate(locationStoppedTime!)
        var coordinateWalkArray:[CLLocationCoordinate2D] = []
        coordinateWalkArray.append(lastGPSLocation!)
        for step in stepListAfterStopped
        {
            var oldLocation: CLLocationCoordinate2D
            
            if coordinateWalkArray.count == 0
            {
                oldLocation = (lastGPSLocation)!
            }
            else
            {
                oldLocation = coordinateWalkArray[coordinateWalkArray.count-1]
            }
            var newCoord:CLLocationCoordinate2D
            newCoord = getNextCoordinate(oldLocation, distanceMeters: CommonFunction.pythThm(step.altitudeChange, c: step.distance), bearing: step.bearing)
            coordinateWalkArray.append(newCoord)
        }
        return coordinateWalkArray
    }
    
    func getNextCoordinate(orginCoord:CLLocationCoordinate2D, distanceMeters:Double,bearing:Double)->CLLocationCoordinate2D
    {
        let distanceInRadians:Double = distanceMeters/6371000.0;//earth's radius
        let bearingInRadians:Double = CommonFunction.radiansFromDegrees(bearing);
        let orginCoordLatitudeRadians = CommonFunction.radiansFromDegrees(orginCoord.latitude)
        let orginCoordLongitudeRadians = CommonFunction.radiansFromDegrees(orginCoord.longitude)
        //print(orginCoord.latitude)
        //print(orginCoord.longitude)
        //haversine formula
        let newCoordLatitudeRadains = asin(sin(orginCoordLatitudeRadians) * cos(distanceInRadians) + cos(orginCoordLatitudeRadians) * sin(distanceInRadians) * cos(bearingInRadians))
        var newCoordLongitudeRadians = orginCoordLongitudeRadians + atan2(sin(bearingInRadians) * sin(distanceInRadians) * cos(orginCoordLongitudeRadians), cos(distanceInRadians) - sin(orginCoordLongitudeRadians) * sin(orginCoordLongitudeRadians))
        
        newCoordLongitudeRadians = fmod((newCoordLongitudeRadians + 3*M_PI),(2*M_PI)) - M_PI
        let newCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(CommonFunction.degreesFromRadians(newCoordLatitudeRadains)), CLLocationDegrees(CommonFunction.degreesFromRadians(newCoordLongitudeRadians)))
        //print(degreesFromRadians(newCoordLatitudeRadains))
        //(degreesFromRadians(newCoordLongitudeRadians))
        return newCoord
        
    }

}