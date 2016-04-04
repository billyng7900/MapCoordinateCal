//
//  ViewController.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 30/1/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//
//Google API Key:AIzaSyDRNWEe1ndTkt5lmPU-T6pD7xS47TwJuRo//

import UIKit
import MapKit
import CoreLocation
import CoreMotion

enum PlaceType
{
    case GreenLine
    case GreenDot
}

class ViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIToolbar!
    var searchResultViewController: UISearchController? = nil
    var calculateLocation:CalculateLocation?
    
    var locationManager = CLLocationManager()
    let activityManager = CMMotionActivityManager()
    let defaults = NSUserDefaults.standardUserDefaults()
    let pedoMeter = CMPedometer()
    var magneticBearing:NSNumber = 0
    var totalDistanceCount:Double = 0.0
    var overLay:MKOverlay?
    var timersecond = 0 // for testing purpose
    var altimeter = CMAltimeter()
    var lastAltitude:Double = 0.0
    var altitudeChange = Double()
    var stepCollection:StepCollection = StepCollection.getStepCollection()
    var bestGPSLocation = CLLocationCoordinate2D?()
    var GPSAccuracyAllowRange:Double = 35
    var GPSTimeAllowRange:Int = 15
    var placeType:String?
    var bearingCollection:BearingCollection = BearingCollection.getBearingCollection()
    var altitudeCollection = AltitudeCollection.getAltitudeCollection()
    var gpsCoordinateCollection = GPSCoordinateCollection.getGPSCoordinateCollection()
    var correctionHeadingCollection = CorrectionHeadingCollection.getCorrectionHeadingCollection()
    var locationStopedTime:NSDate = NSDate()
    var enableTestLocationAlert = false
    var isFirstTimeLocated = true
    var calculateHeading = CalculateHeading.getCalculateHeading()
    var selectedPin:SearchResult? = nil
    var isHeadingCalculationEnabled = false
    var timerForHeadingCalculation:NSTimer? = nil
    var isAllowedToDrawLine = false
    var calculatedLocation:CLLocationCoordinate2D? = nil
    
    enum motion
    {
        case walking
        case running
        case other
    }
    var currentActivity: motion?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        calculateHeading.delegate = self
        mapView.delegate = self
        let gesture = UILongPressGestureRecognizer(target: self, action: "revealRegionDetailsWithLongPressOnMap:")
        mapView.addGestureRecognizer(gesture)
        var timer = NSTimer()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "recordBearing", userInfo: nil, repeats: true)
        startStepCounter()
        startAltimeter()
        startMonitorActivity()
        setUpSearch()
        calculateLocation = CalculateLocation(mapView: mapView)
        if let savedPlaceType = defaults.stringForKey("Place Type")
        {
            placeType = savedPlaceType
        }
        else
        {
            placeType = "Green Line"
        }
    }
    
    func setUpSearch()
    {
        let searchResultTable = storyboard!.instantiateViewControllerWithIdentifier("SearchResultTable") as! SearchResultTableViewController
        searchResultViewController = UISearchController(searchResultsController: searchResultTable)
        searchResultViewController?.searchResultsUpdater = searchResultTable
        let searchBar = searchResultViewController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Places"
        navigationItem.titleView = searchResultViewController?.searchBar
        searchResultViewController?.hidesNavigationBarDuringPresentation = false
        searchResultViewController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        searchResultTable.mapView = mapView
        searchResultTable.handleSearchMapDelegate = self
    }
    
    /*func testAltitude()
    {
        let timeNow = NSDate()
        altitudeCollection.appendAltitude(0.2, time: timeNow.dateByAddingTimeInterval(3))
        altitudeCollection.appendAltitude(0.4, time: timeNow.dateByAddingTimeInterval(6))
        altitudeCollection.appendAltitude(0.2, time: timeNow.dateByAddingTimeInterval(-2))
        altitudeCollection.appendAltitude(0.2, time: timeNow.dateByAddingTimeInterval(4))
        altitudeCollection.getAccumulatedAltitudeChange(timeNow, timeEnd: timeNow.dateByAddingTimeInterval(5))
    }
    func testCoordinate()
    {
        var accuracy = 58.0
        var dateSecond = -15.0
        for var i=0;i<15;i++
        {
            gpsCoordinateCollection.appendGPSCoordinateList(123, latitude: 123, accuracy: accuracy, time: NSDate().dateByAddingTimeInterval(dateSecond))
            accuracy++
            dateSecond++
        }
        //gpsCoordinateCollection.findOutMostRecentAccurateLocation(GPSAccuracyAllowRange, timeLimit: NSDate().dateByAddingTimeInterval(-15))
    }*/
    
    func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer)
    {
        if sender.state != UIGestureRecognizerState.Began
        {
            return
        }
        let touchedLocation = sender.locationInView(mapView)
        let locationCoordinate = mapView.convertPoint(touchedLocation, toCoordinateFromView: mapView)
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            var placeMark:CLPlacemark!
            placeMark = placemarks?.first
            if let locationName = placeMark.addressDictionary!["Name"] as? String
            {
                var annotationsToBeRemoved = [MKAnnotation]()
                for annotation in self.mapView.annotations
                {
                    if !(annotation is MKUserLocation)
                    {
                        if let customAnnotation = annotation as? Annotation
                        {
                            if customAnnotation.type == AnnotationType.AnnotationDefault
                            {
                                annotationsToBeRemoved.append(annotation)
                            }
                        }
                    }
                }
                self.mapView.removeAnnotations(annotationsToBeRemoved)
                let coordinate = placeMark.location?.coordinate
                let annotation = Annotation(coordinate: coordinate!, title: locationName, subtitle: placeMark.country!, type: AnnotationType.AnnotationDefault)
                self.mapView.addAnnotation(annotation)
            }
        })
    }
    
    /*func testNSDateAdd(string:String) -> NSDate
    {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "HH:mm:ss"
        let d = dateStringFormatter.dateFromString(string)
        return d!
    }

    func testStepRecordAdd()
    {
        let timeNow = NSDate()
        altitudeCollection.appendAltitude(0.2, time: timeNow.dateByAddingTimeInterval(3))
        altitudeCollection.appendAltitude(0.4, time: timeNow.dateByAddingTimeInterval(6))
        altitudeCollection.appendAltitude(0.3, time: timeNow.dateByAddingTimeInterval(-2))
        altitudeCollection.appendAltitude(0.6, time: timeNow.dateByAddingTimeInterval(4))
        stepCollection.appendStepList(12, distance: 1, startDate: NSDate(), endDate: timeNow.dateByAddingTimeInterval(3), pace: nil, cadence: nil, bearing: 123)
        stepCollection.appendStepList(12, distance: 1, startDate: NSDate(), endDate: timeNow.dateByAddingTimeInterval(7), pace: nil, cadence: nil, bearing: 123)
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startMonitorActivity()
    {
        if CMMotionActivityManager.isActivityAvailable()
        {
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue()) { data in if let data = data {
                dispatch_async(dispatch_get_main_queue()){
                    if data.walking == true
                    {
                        self.currentActivity = motion.walking
                    }
                    else if data.running == true
                    {
                        self.currentActivity = motion.running
                    }
                    else
                    {
                        self.currentActivity = motion.other
                    }
                }
                }
            }

        }
    }
    
    func recordBearing()
    {
        bearingCollection.appendBearingList(Double(magneticBearing), time: NSDate())
    }
    
    func startAltimeter()
    {
        if CMAltimeter.isRelativeAltitudeAvailable()
        {
            altimeter.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(data, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(error == nil)
                {
                    self.altitudeChange = Double(data!.relativeAltitude) - self.lastAltitude
                    self.altitudeCollection.appendAltitude(self.altitudeChange, time: NSDate())
                    self.lastAltitude = Double(data!.relativeAltitude)
                }
                })
            })
        }
    }
    
    func startStepCounter()
    {
        if CMPedometer.isStepCountingAvailable()
        {
            pedoMeter.startPedometerUpdatesFromDate(NSDate(), withHandler: {(data:CMPedometerData?, error:NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if(error == nil)
                    {
                        if !self.isHeadingCalculationEnabled
                        {
                            self.isHeadingCalculationEnabled = true
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
    
    func stopHeadingCalculation()
    {
        if calculateLocation!.isLocationUpdateStopped()
        {
            drawWalkingLine()
        }
        isHeadingCalculationEnabled = false
        calculateHeading.stopUpdateMotionUpdates()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse
        {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
            mapView.showsUserLocation = true
        }
        else
        {
            
        }
    }
    
    func checkLocationService()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .NotDetermined, .Restricted, .Denied:
                let settingAction = UIAlertAction(title: "Setting", style: .Default, handler: {(_) -> Void in
                    let settingURL = NSURL(string: "prefs:root=LOCATION_SERVICES")
                    if let url = settingURL
                    {
                        UIApplication.sharedApplication().openURL(url)
                    }
                })
                let alertController = UIAlertController(title: "Location Service Denied", message: "Unable to determine your location", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(settingAction)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            case .AuthorizedAlways, .AuthorizedWhenInUse: break
            }
        }
        else
        {
            let settingAction = UIAlertAction(title: "Setting", style: .Default, handler: {(_) -> Void in
                let settingURL = NSURL(string: "prefs:root=LOCATION_SERVICES")
                if let url = settingURL
                {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            let alertController = UIAlertController(title: "Location Service Denied", message: "Unable to determine your location", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(settingAction)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func repeatTimer()
    {
        timersecond++
        var bearing:Double = 360 - 41
        if timersecond > 8
        {
            bearing = 360 - 10
        }
        if timersecond > 18
        {
            bearing = 20
        }
        if calculateLocation!.isLocationUpdateStopped()
        {
            stepCollection.appendStepList(2, distance: 4, startDate: NSDate(), endDate: NSDate(), pace: nil, cadence: nil, bearing: bearing)
            drawWalkingLine()
        }
    }
    
    @IBAction func searchLocation(sender: AnyObject) {
        checkLocationService()
        if calculateLocation!.isLocationUpdateStopped()
        {
            if calculatedLocation != nil
            {
                //calculatedLocation = nil
                let region = MKCoordinateRegionMakeWithDistance(calculatedLocation!, 300, 300)
                mapView.setRegion(region, animated: true)
            }
            //calculateLocation?.stopLocationCal()
            //mapView.showsUserLocation = true
        }
        else
        {
            if let coordinate = mapView.userLocation.location?.coordinate {
                let region = MKCoordinateRegionMakeWithDistance(coordinate, 300, 300)
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
    @IBAction func stopUpdateLocation(sender: AnyObject) {
        if !calculateLocation!.isLocationUpdateStopped()
        {
            bestGPSLocation = CLLocationCoordinate2DMake(22.336672, 114.174293)
            calculateLocation?.startLocationCal(mapView.userLocation.coordinate, locationStoppedTime: NSDate())
            //mapView.showsUserLocation = false
            //var timer = NSTimer()
            //timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "repeatTimer", userInfo: nil, repeats: true)
        }
    }
    
    

}

extension ViewController:MKMapViewDelegate,CLLocationManagerDelegate
{
    
    func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager) -> Bool {
        return true
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if isFirstTimeLocated
        {
            let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
            mapView.setRegion(region, animated: true)
            isFirstTimeLocated = false
        }
        if !mapView.overlays.isEmpty
        {
            mapView.removeOverlays(mapView.overlays)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation:CLLocation = locations.last!
        gpsCoordinateCollection.appendGPSCoordinateList(newLocation.coordinate.longitude, latitude: newLocation.coordinate.latitude, accuracy: newLocation.horizontalAccuracy, time: newLocation.timestamp)
        //distanceLabel.text = "\(newLocation.course)"
        if enableTestLocationAlert
        {
            let alertController = UIAlertController(title: "Location Service Event", message: "Accuracy:\(newLocation.horizontalAccuracy)", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)

        }
        if Double(newLocation.horizontalAccuracy) >= GPSAccuracyAllowRange && !calculateLocation!.isLocationUpdateStopped()
        {
            let lastAccurateLocation = gpsCoordinateCollection.findOutMostRecentAccurateLocation(GPSAccuracyAllowRange, timeLimit: NSDate().dateByAddingTimeInterval(-15),timeUpLimit: NSDate())
            if lastAccurateLocation != nil
            {
                bestGPSLocation = CLLocationCoordinate2DMake((lastAccurateLocation?.latitude)!, (lastAccurateLocation?.longitude)!)
                locationStopedTime = (lastAccurateLocation?.time)!
                calculateLocation?.startLocationCal(bestGPSLocation!, locationStoppedTime: locationStopedTime)
                //mapView.showsUserLocation = false
            }
        }
        else if Double(newLocation.horizontalAccuracy) < GPSAccuracyAllowRange
        {
            if calculateLocation!.isLocationUpdateStopped()
            {
                calculateLocation?.stopLocationCal()
                mapView.showsUserLocation = true
                calculatedLocation = nil
                //isHeadingCalculationEnabled = false
                //calculateHeading.stopUpdateMotionUpdates()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        magneticBearing = newHeading.trueHeading
    }
    
    func drawWalkingLine()
    {
        
        var coordinateWalkArray:[CLLocationCoordinate2D] = (calculateLocation?.convertStepListToCoordinate())!
        calculatedLocation = coordinateWalkArray.last
        if !coordinateWalkArray.isEmpty
        {
            if placeType == "Green Line"
            {
                mapView.removeOverlays(mapView.overlays)
                let myPolyLine = MKPolyline(coordinates: &coordinateWalkArray , count: coordinateWalkArray.count)
                mapView.addOverlay(myPolyLine)
            }
            else
            {
                mapView.removeOverlays(mapView.overlays)
                removeCalPin()
                drawGreenDot(calculatedLocation!)
                let myCircle = MKCircle(centerCoordinate: calculatedLocation!, radius: 40)
                mapView.addOverlay(myCircle)
            }
        }
    }
    
    func drawGreenDot(calLocation:CLLocationCoordinate2D)
    {
        let calPin = Annotation(coordinate: calLocation, title: "Calculate User Location", subtitle: "This Location is calculated by the algorithm", type: AnnotationType.AnnotationCalUserLocation)
        calPin.coordinate = (calLocation)
        self.mapView.addAnnotation(calPin)
    }
    
    func removeCalPin()
    {
        var annotationsToBeRemoved = [MKAnnotation]()
        for annotation in self.mapView.annotations
        {
            if !(annotation is MKUserLocation)
            {
                if let customAnnotation = annotation as? Annotation
                {
                    if customAnnotation.type == AnnotationType.AnnotationCalUserLocation
                    {
                        annotationsToBeRemoved.append(annotation)
                    }
                }
            }
        }
        self.mapView.removeAnnotations(annotationsToBeRemoved)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKPolyline
        {
            let lineView = MKPolylineRenderer(overlay:overlay)
            lineView.strokeColor = UIColor.greenColor()
            lineView.alpha = 0.4
            lineView.lineWidth = 5
            return lineView
        }
        else if overlay is MKCircle
        {
            let circleView = MKCircleRenderer(overlay: overlay)
            circleView.fillColor = UIColor.greenColor()
            circleView.alpha = 0.2
            circleView
            return circleView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation)
        {
            return nil
        }
        let annotationView = UserLastAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        annotationView.canShowCallout = true
        return annotationView
    }
}

extension ViewController
{
    @IBAction func unwindSaveOption(segue:UIStoryboardSegue)
    {
        if let settingController = segue.sourceViewController as? SettingsTableViewController
        {
            placeType = settingController.option!
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "settingSegue"
        {
            if let naviController = segue.destinationViewController as? UINavigationController
            {
                if let settingController = naviController.topViewController as? SettingsTableViewController
                {
                    settingController.option = placeType
                }
            }
        }
    }
    
    @IBAction func testLocationEvent(sender: AnyObject)
    {
        if !enableTestLocationAlert
        {
            enableTestLocationAlert = true
        }
        else
        {
            enableTestLocationAlert = false
        }
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue)
    {
        
    }
}

extension ViewController:CalculateHeadingDelegate
{
    func calculateHeading(calculateHeading: CalculateHeadingProtocol, didUpdateHeadingValue: Double, startTime:NSDate) {
        let heading = didUpdateHeadingValue
        correctionHeadingCollection.appendCorrectionHeading(heading, startTime: startTime)
        if calculateLocation!.isLocationUpdateStopped()
        {
            drawWalkingLine()
        }
        isAllowedToDrawLine = true
    }
    
    func calculateHeading(CalculateHeading: CalculateHeadingProtocol, didRotatedDevice isAccurateHeadPushed: Bool, previousHeading: Double, previousStartTime:NSDate) {
        isAllowedToDrawLine = false
        if !isAccurateHeadPushed
        {
            correctionHeadingCollection.appendCorrectionHeading(previousHeading, startTime: previousStartTime)
        }
    }
    
    func checkCorrectedHeading(correctedHeading:Double) -> Double
    {
        var finalHeading = correctedHeading
        if correctedHeading <= 15 || correctedHeading >= 345
        {
            finalHeading = 0
        }
        else if correctedHeading <= 105 && correctedHeading >= 75
        {
            finalHeading = 90
        }
        else if correctedHeading <= 195 && correctedHeading >= 165
        {
            finalHeading = 180
        }
        else if correctedHeading <= 285 && correctedHeading >= 255
        {
            finalHeading = 270
        }
        return finalHeading
    }
    func calculateHead(calculateHeading: CalculateHeadingProtocol, didVectorUpdated: Double, secondVector: Double, headingValue:Double) {
    }
}

extension ViewController: HandleMapSearch
{
    func dropPinZommIn(result: SearchResult) {
        var annotationsToBeRemoved = [MKAnnotation]()
        for annotation in self.mapView.annotations
        {
            if !(annotation is MKUserLocation)
            {
                if let customAnnotation = annotation as? Annotation
                {
                    if customAnnotation.type == AnnotationType.AnnotationDefault
                    {
                        annotationsToBeRemoved.append(annotation)
                    }
                }
            }
        }
        self.mapView.removeAnnotations(annotationsToBeRemoved)

        selectedPin = result
        let coordinate = result.getPlaceCoordinate()
        let annotation = Annotation(coordinate: coordinate, title: result.description, subtitle: result.formattedAddress, type: AnnotationType.AnnotationDefault)
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

