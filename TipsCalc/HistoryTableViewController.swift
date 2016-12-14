//
//  HistoryTableViewController.swift
//  TipsCalc
//
//  Created by Linh Le on 12/13/16.
//  Copyright © 2016 Linh Le. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController{
    
    var array1 = [String]()
    var defaults = UserDefaults.standard
    var billNumber = (UserDefaults.standard.integer(forKey: "billNumber"))
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log.info("line29 \(billNumber)")
        return billNumber
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        log.info(String(indexPath.row+1))
        array1 = (defaults.array(forKey: "bill No."+String(indexPath.row+1)) ?? ["","","","",""]) as! [String]

        // Instantiate a cell
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "HistoryCell")
        
        // Adding the informations
        cell.textLabel?.text = array1[4]//restaurant name
        cell.detailTextLabel?.text = "total: \(utilities.numberToCurrency(Double(array1[2])!))   tip: \(utilities.numberToCurrency(Double(array1[1])!))"//bill info
        cell.imageView?.image = UIImage(named: "waiter")
        
        // Returning the cell
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: - Action
    
    @IBAction func ClearHistory(_ sender: UIBarButtonItem) {
        for bill in 0...billNumber {
            defaults.removeObject(forKey: "bill No."+String(bill))
        }
        defaults.setValue(0, forKey: "billNumber")
        billNumber = 0

        tableView.reloadData()
    }

}
