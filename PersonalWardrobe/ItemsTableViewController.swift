//
//  ItemsTableViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/23/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    let wardrobe = Wardrobe.sharedInstance
    var type : String?

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wardrobe.browseCollections![type!]!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell", forIndexPath: indexPath) as! ItemTableViewCell
        let items = wardrobe.browseCollections![type!]

        // Configure the cell...
        cell.itemImageView?.image = UIImage(data: items![indexPath.row].thumbnail!)

        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let itemDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("detailView") as! detailViewController
        
        
        wardrobe.currentClothes = wardrobe.browseCollections![type!]![indexPath.row]
        
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if wardrobe.currentChanged {
            wardrobe.fetchBrowseCollections(wardrobe.sortType!)
            self.tableView!.reloadData()
            
        }
        
        
    }

}
