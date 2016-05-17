//
//  CategoryItemsViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 4/17/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class CategoryItemsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let wardrobe = Wardrobe.sharedInstance
    var selected = [Clothes]()
    
    @IBOutlet weak var itemsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTable.dataSource = self
        itemsTable.delegate = self
        itemsTable.allowsMultipleSelection = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wardrobe.currentCollection!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ItemTableViewCell
        let items = wardrobe.currentCollection
        
        cell.itemImageView?.image = UIImage(data: items![indexPath.row].thumbnail!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        selected.append(wardrobe.currentCollection![indexPath.row])
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        let index = selected.indexOf(wardrobe.currentCollection![indexPath.row])
        selected.removeAtIndex(index!)
    }

    

    @IBAction func doneSelection(sender: AnyObject) {
        
        let index = self.navigationController!.viewControllers.indexOf(self)
        let newmatchVC = self.navigationController!.viewControllers[index!-2] as! AddNewMatchViewController
        
        newmatchVC.matchArray.appendContentsOf(selected)
        self.navigationController!.popToViewController(newmatchVC, animated: true)
        
        
    }
    
    
    
}
