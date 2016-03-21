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
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode == 200
            {
                do
                {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                    if let predictions = json["predictions"] as? [[String: AnyObject]]
                    {
                        for prediction in predictions
                        {
                            if let description = prediction["description"] as? String
                            {
                                if let placeId = prediction["place_id"] as? String
                                {
                                    let searchResult = SearchResult(description: description, placeId: placeId)
                                    self.searchResultList.append(searchResult)
                                }
                            }
                        }
                    }
                }
                catch let parseError
                {
                    
                }
            }
        }
        task.resume()
        /*let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler({response, _ in
            guard let response = response
            else
            {
                return
            }
            self.resultItems = response.mapItems
            self.tableView.reloadData()
        })*/
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let selectedItem = searchResultList[indexPath.row]
        cell.textLabel?.text = selectedItem.description
        cell.detailTextLabel?.text = selectedItem.formattedAddress
        return cell
    }
}
