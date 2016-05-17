//
//  BottomsViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 4/14/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class BottomsViewController: UIViewController {

    
    let wardrobe = Wardrobe.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func buttonPressed(sender: UIButton) {
        
        
        let itemsVC = self.storyboard?.instantiateViewControllerWithIdentifier("itemsCollectionController") as! itemsCollectionController
        
        wardrobe.currentSubCategory = wardrobe.subCategories[wardrobe.currentMainCategory!]![sender.tag]
        
        //fetch items
        wardrobe.fetchSubcategory(wardrobe.currentSubCategory!)
        
        itemsVC.title = wardrobe.currentSubCategory!
        self.navigationController?.pushViewController(itemsVC, animated: true)
        
    }

}
