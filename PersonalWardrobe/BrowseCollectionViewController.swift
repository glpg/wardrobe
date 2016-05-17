//
//  BrowseCollectionViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/23/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class BrowseCollectionViewController: UITableViewController {
    
    let wardrobe = Wardrobe.sharedInstance
    var sections : [String]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = Array(wardrobe.browseCollections!.keys)
        sections!.sortInPlace(){$0 < $1}
        
        for item in sections!{
            print(item)
        }
        
    }

   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections!.count
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let count = wardrobe.browseCollections![sections![indexPath.row]]!.count
        
        cell!.textLabel!.text = sections![indexPath.row] + " (" + String(count) +  ")"
        
        return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let itemsVC = self.storyboard?.instantiateViewControllerWithIdentifier("itemsVC") as! ItemsTableViewController
        
        itemsVC.title = sections![indexPath.row]
        itemsVC.type = sections![indexPath.row]
        
        self.navigationController?.pushViewController(itemsVC, animated: true)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView!.reloadData()
              
    }

    
    
    
}
