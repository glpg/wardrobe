//
//  itemsCollectionController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/10/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit
import CoreData


class itemsCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let wardrobe = Wardrobe.sharedInstance
        
    @IBOutlet weak var browseButton: UIBarButtonItem!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        if wardrobe.currentMainCategory == "Match" {
            browseButton.enabled = false
        }
        
    }

    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if wardrobe.currentMainCategory == "Match" {
            return wardrobe.currentMatchCollection!.count
        }
        else {
            return wardrobe.currentCollection!.count
            
        }
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : thumbnailCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! thumbnailCell
        
                
        if wardrobe.currentMainCategory == "Match" {
            cell.thumbnailImage.image = UIImage(data: wardrobe.currentMatchCollection![indexPath.row].thumbnail!)
            
        }
        else {
            cell.thumbnailImage.image = UIImage(data: wardrobe.currentCollection![indexPath.row].thumbnail!)
        }
        
        cell.layer.backgroundColor = UIColor.whiteColor().CGColor
        
        return cell
     
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if wardrobe.currentMainCategory == "Match" {
            wardrobe.currentMatch = wardrobe.currentMatchCollection![indexPath.row]
            let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("matchDetailVC") as! MatchDetailViewController
            
            self.navigationController?.pushViewController(detailController, animated: true)
            
            
        }
        else{
            wardrobe.currentClothes = wardrobe.currentCollection![indexPath.row]
            let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("detailView") as! detailViewController
            
            self.navigationController?.pushViewController(detailController, animated: true)
            
        }
        
        
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var numColumns = CGFloat(3)
        let cellSpacing = CGFloat(8)
        let leftRightMargin = CGFloat(5)
        let screenWidth = UIScreen.mainScreen().bounds.width
        if screenWidth > 600 && screenWidth <= 800 {
            numColumns = CGFloat(4)
        }
        if screenWidth > 800  {
            numColumns = CGFloat(6)
        }
        
        
        
        let totalCellSpace = cellSpacing * (numColumns - 1)
        
        let width = (screenWidth - leftRightMargin - totalCellSpace) / numColumns
        let height = 1.2 * width
        
        print(width)
        print(height)
        
        return CGSizeMake(width, height);
        
    }
    
    
    
    
    @IBAction func addNewClothes(sender: UIBarButtonItem){
        
        if(wardrobe.currentMainCategory! == "Match") {
            let addNewController = self.storyboard?.instantiateViewControllerWithIdentifier("newmatchVC") as! AddNewMatchViewController
            addNewController.title = "New Match"
            //addNewController.addNewParent = self
            self.navigationController?.pushViewController(addNewController, animated: true)
            
            
        }
        else{
            let addNewController = self.storyboard?.instantiateViewControllerWithIdentifier("editViewController") as! editViewController
            addNewController.title = "New Clothes"
            addNewController.addNewParent = self
            self.navigationController?.pushViewController(addNewController, animated: true)
            
        }
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView!.reloadData()
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
}
