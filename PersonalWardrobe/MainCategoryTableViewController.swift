//
//  MainCategoryTableViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 4/17/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class MainCategoryTableViewController: UITableViewController {
    
    let wardrobe = Wardrobe.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wardrobe.mainCategories!.count - 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        
        cell!.textLabel!.text = wardrobe.mainCategories![indexPath.row]
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let itemsVC = self.storyboard?.instantiateViewControllerWithIdentifier("categoryItemsVC") as! CategoryItemsViewController
        
        itemsVC.title = wardrobe.mainCategories![indexPath.row]
        wardrobe.fetchMaincategory(wardrobe.mainCategories![indexPath.row])
        
        self.navigationController?.pushViewController(itemsVC, animated: true)
        
        
    }

    


    
}
