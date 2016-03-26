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

class SearchResultTableViewController: UITableViewController{
    var resultItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var searchResultList = [SearchResult]()
    
    func getAddress(selectedItem:MKPlacemark) -> String
    {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressText = String(
            format: "%@%@%@%@%@%@%@",
            //street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            //street name
            selectedItem.thoroughfare ?? "",
            comma,
            //city
            selectedItem.locality ?? "",
            secondSpace,
            //state
            selectedItem.administrativeArea ?? ""
        )
        return addressText
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
        let searchBarTextEncode = searchBarText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
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
        cell.detailTextLabel?.text = selectedItem.placeId
        return cell
    }
}
