//
//  TableViewController.swift
//  Currency Rates
//
//  Created by Adam Kaufman on 9/6/16.
//  Copyright © 2016 Adam Kaufman. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    //A struct of the currency conversion data
    //keeps the related currency type and conversion rate together in a simple way
    struct currencyConvert{
        var currencyType: String
        var conversionRate: Double
    }
    
    //the list that is used to display the data in the tableview
    var list = [currencyConvert]()
    //the idctionary the rates are initially put into
    var Rates: NSDictionary = [:]
    
    //calls to the api before the view appears so that it automatically gets put onto the page
    override func viewWillAppear(animated: Bool) {
        getListOfRates()
    }

    override func viewDidLoad() {
        navBarTitle.title = "Loading"
        self.tableView.scrollEnabled = false
        super.viewDidLoad()
    }
    
    //MARK: Data Retrieval
    
    //gets list of conversion rates from api
    func getListOfRates(){
        //set up post request here
        let path = "https://api.fixer.io/latest?base=USD"
        let url = NSURL(string: path)
        
        let apirequest = NSMutableURLRequest(URL: url!)
        
        apirequest.HTTPMethod = "GET"
        
        //gets the conversion rates from the api in json  format
        let task = NSURLSession.sharedSession().dataTaskWithRequest(apirequest){
            data, response, error in
            
            if error != nil{    //catches an error if anything went wrong retrieving from the api
                print("Error!")
                let err = currencyConvert(currencyType: "Error!" + error!.localizedDescription, conversionRate: 0.0)
                self.list += [err]
                return
            }
            
            do{
                if let convertedInitialJson = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary{
                    //puts the json into a dictionary if the above passes as true
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.Rates = convertedInitialJson["rates"] as! NSDictionary
                        self.addRatesToList() })
                }
            } catch let error as NSError {  //catches an error if there anything went wrong converting the json to a dictionary
                    print(error.localizedDescription)
                    let err = currencyConvert(currencyType: "Error!" + error.localizedDescription, conversionRate: 0.0)
                    self.list += [err]
                    return
                }
            }
        
        task.resume()
    }
    
    //goes through the dictionary of rates and adds them all to the viewing list
    func addRatesToList(){
        print(self.Rates)
        for (key, value) in self.Rates{
            let rate = currencyConvert(currencyType: key as! String, conversionRate: Double(value as! NSNumber))
            list += [rate]
        }
        self.tableView.reloadData()
        
        navBarTitle.title = "USD"
        
    }
    
    //MARK: Standard TableView Functions

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "ConversionTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ConversionTableViewCell
        
        let rate = list[indexPath.row]
        
        cell.currencyType.text = rate.currencyType
        cell.conversionRate.text =  String(rate.conversionRate)
        self.tableView.scrollEnabled = true
        return cell
    }
    
    //MARK: Actions
    
    //refreshes the table when the user hits the refresh button
    @IBAction func refreshTable(sender: UIBarButtonItem) {
        list.removeAll()
        navBarTitle.title = "Loading"
        self.tableView.scrollEnabled = false
        self.tableView.reloadData()
        getListOfRates()
    }
    

}
