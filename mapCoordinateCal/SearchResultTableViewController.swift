//
//  SearchResultTableViewController.swift
//  mapCoordinateCal
//
//  Created by 伍裕濬 on 17/3/2016.
//  Copyright © 2016年 billyng. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import SystemConfiguration

class SearchResultTableViewController: UITableViewController{
    var resultItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var searchResultList = [SearchResult]()
    var timer: NSTimer? = nil
    var handleSearchMapDelegate:HandleMapSearch? = nil
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = searchResultList[indexPath.row]
        handleSearchMapDelegate?.dropPinZommIn(selectedItem)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        })else
        {
            return false
        }
        var flags:SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags)
        {
            return false
        }
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }

}
extension SearchResultTableViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text
        else
        {
            return
        }
        timer?.invalidate()
        if isConnectedToNetwork()
        {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "getText:", userInfo: searchBarText, repeats: false)
        }
    }
    
    func getText(timer: NSTimer)
    {
        let searchBarTextEncode = timer.userInfo!.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let requestURL: NSURL = NSURL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(searchBarTextEncode)&key=AIzaSyC-Nx-rs9WG01HZ-peeCvq-NqPAMxILTAE")!
        let data=NSData(contentsOfURL:requestURL)
        do
        {
            searchResultList.removeAll()
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            if let predictions = json["predictions"] as? [[String: AnyObject]]
            {
                for prediction in predictions
                {
                    let searchResult = SearchResult(prediction: prediction)
                    self.searchResultList.append(searchResult)
                }
                self.tableView.reloadData()
            }
        }
        catch
        {
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let selectedItem = searchResultList[indexPath.row]
        cell.textLabel?.text = selectedItem.description
        cell.detailTextLabel?.text = selectedItem.formattedAddress
        return cell
    }
}
