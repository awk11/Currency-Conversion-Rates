//
//  TableViewController.swift
//  Currency Rates
//
//  Created by Adam Kaufman on 9/6/16.
//  Copyright © 2016 Adam Kaufman. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    struct currencyConvert{
        var currencyType: String
        var conversionRate: Double
    }
    
    var list = [currencyConvert]()
    var Rates: NSDictionary = [:]
    
    override func viewWillAppear(animated: Bool) {
        getListOfRates()
    }

    override func viewDidLoad() {
        navBarTitle.title = "Loading"
        super.viewDidLoad()
    }
    
    //gets list of conversion rates from api
    func getListOfRates(){
        //set up post request here
        let path = "https://api.fixer.io/latest?base=USD"
        let url = NSURL(string: path)
        
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                print("Error!")
                let err = currencyConvert(currencyType: "Error!" + error!.localizedDescription, conversionRate: 0.0)
                self.list += [err]
                return
            }
            
            do{
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary{
                    //print(convertedJsonIntoDict)
                    
                    self.Rates = convertedJsonIntoDict["rates"] as! NSDictionary
                    //print(self.Rates)
                    self.addRatesToList()
                }
                } catch let error as NSError {
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
        
        while list.count == 0{
            
        }
        
            let rate = list[indexPath.row]
        
            cell.currencyType.text = rate.currencyType
            cell.conversionRate.text =  String(rate.conversionRate)
        
        //tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        return cell
    }
    
    @IBAction func refreshTable(sender: UIBarButtonItem) {
        list.removeAll()
        navBarTitle.title = "Loading"
        self.tableView.reloadData()
        getListOfRates()
    }
    

}
