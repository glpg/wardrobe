//
//  browseMainViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/19/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class browseMainViewController: UITableViewController {
    
    let wardrobe = Wardrobe.sharedInstance
    let types = ["Color", "Brand", "Fabric", "Price range"]
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sortTypeCell")
        
        cell!.textLabel!.text = types[indexPath.row]
        
        return cell!
    }


    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
                
        wardrobe.fetchBrowseCollections(types[indexPath.row])
        
        let bcVC = self.storyboard?.instantiateViewControllerWithIdentifier("browseCollectionVC") as! BrowseCollectionViewController
        
        bcVC.title = types[indexPath.row]
      
        self.navigationController?.pushViewController(bcVC, animated: true)

        
        
    }
    
    
}
