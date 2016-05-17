//
//  mainViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/21/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let wardrobe = Wardrobe.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func buttonClicked(sender: UIButton) {
        
        wardrobe.currentMainCategory = wardrobe.mainCategories![sender.tag]
        print(sender.tag)
        
        switch(wardrobe.currentMainCategory!) {
        case "Tops" :
            
            let topsVC = self.storyboard?.instantiateViewControllerWithIdentifier("topsViewController") as! topsViewController
            topsVC.title = "Tops"
            self.navigationController?.pushViewController(topsVC, animated: true)
            
        case "Bottoms" :
            
            let bottomsVC = self.storyboard?.instantiateViewControllerWithIdentifier("bottomsViewController") as! BottomsViewController
            bottomsVC.title = "Bottoms"
            self.navigationController?.pushViewController(bottomsVC, animated: true)
           
        default:
            let itemsVC = self.storyboard?.instantiateViewControllerWithIdentifier("itemsCollectionController") as! itemsCollectionController
            
            wardrobe.fetchMaincategory(wardrobe.currentMainCategory!)
            
            itemsVC.title = wardrobe.currentMainCategory!
            self.navigationController?.pushViewController(itemsVC, animated: true)
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "menuPopoverSegue" {
            let menuVC = segue.destinationViewController as! MenuViewController
            menuVC.parent = self
            menuVC.modalPresentationStyle = UIModalPresentationStyle.Popover
            menuVC.popoverPresentationController!.delegate = self
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
}
