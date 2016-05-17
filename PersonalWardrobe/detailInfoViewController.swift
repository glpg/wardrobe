//
//  detailInfoViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/14/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit
import CoreData


class detailInfoViewController: UIViewController {
    
    let wardrobe = Wardrobe.sharedInstance
    
    
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var fabricLabel: UILabel!
    
    @IBOutlet weak var brandLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var buyFromLabel: UILabel!
    
    @IBOutlet weak var tagLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        
        let item = wardrobe.currentClothes
        
        if (item!.color != "") {
            colorLabel.text = item!.color!
        }
        
        if (item!.fabric != "") {
            fabricLabel.text = item!.fabric!
        }
        
        if (item!.brand != "") {
            brandLabel.text = item!.brand!
        }
        
        if (item!.from != "") {
            buyFromLabel.text = item!.from!
        }
        
        if (item!.tag != "") {
            tagLabel.text = item!.tag!
        }
        
        if (!(item!.price!.doubleValue.isNaN)) {
            
            priceLabel.text = "$" + String(format:"%0.2f", item!.price!.doubleValue)
            
            
        }

    }
    
    @IBAction func showStoreMap(sender: UIButton) {
        if(buyFromLabel.text == "N/A") {
            let alertController = UIAlertController(title: "Wardrobe", message: "No store information exists", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        else {
            let mapController = self.storyboard?.instantiateViewControllerWithIdentifier("mapViewController") as! mapViewController
            mapController.searchText = buyFromLabel.text!
            self.navigationController?.pushViewController(mapController, animated: true)
   
        }
        
        
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showStoreMap") {
            let destvc = segue.destinationViewController as! mapViewController
            destvc.searchText = buyFromLabel.text!
            
        }
    }

    
}
