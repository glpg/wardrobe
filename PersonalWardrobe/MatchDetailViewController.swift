//
//  MatchDetailViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 4/17/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit
import Social

class MatchDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let wardrobe = Wardrobe.sharedInstance
    
    var theMatch : Matches?
    var clothes : [Clothes]?
    
    @IBOutlet weak var matchName: UILabel!
    @IBOutlet weak var matchCollection: UICollectionView!

    @IBOutlet weak var matchImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theMatch = wardrobe.currentMatch
        
        if theMatch!.name != "" {
            matchName.text = theMatch!.name
        }
        
        
        clothes = theMatch!.clothes!.allObjects as? [Clothes]
        matchImage.image = UIImage(data: theMatch!.image!.fullsizeimage!)
        
        matchCollection.delegate = self
        matchCollection.dataSource = self
        
        if theMatch!.clothes == nil || theMatch!.clothes!.count == 0 {
            matchCollection.hidden = true;
        }
        

    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return clothes!.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! thumbnailCell
        
        cell.thumbnailImage.image = UIImage(data: clothes![indexPath.row].thumbnail!)
        cell.layer.backgroundColor = UIColor.whiteColor().CGColor
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        wardrobe.currentClothes = clothes![indexPath.row]
        let detailController = self.storyboard?.instantiateViewControllerWithIdentifier("detailView") as! detailViewController
        
        self.navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    
    
    
    @IBAction func shareMatch(sender: AnyObject) {
        // Configure a new action for sharing the note in Twitter.
        
        let shareOnTwitter = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterComposeVC.addImage(self.matchImage.image)
                self.presentViewController(twitterComposeVC, animated: true, completion: nil)
                
            }
            else {
                self.showAlertMessage("You are not logged into your Twitter account.")
            }
            
            
        }
        
        
        // Configure a new action to share on Facebook.
        let shareOnFacebook = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.Default) { (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposeVC.addImage(self.matchImage.image)
                
                self.presentViewController(facebookComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged into your Facebook account.")
            }
            
        }
        
        
        // Configure a new action to share on Sina weibo.
        let shareOnSinaWeibo = UIAlertAction(title: "Share on Sina Weibo", style: UIAlertActionStyle.Default) { (action) -> Void in
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeSinaWeibo) {
                let sinaWeiboComposeVC = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
                sinaWeiboComposeVC.addImage(self.matchImage.image)
                
                self.presentViewController(sinaWeiboComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged into your Sina Weibo account.")
            }
            
        }
        
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        //add all actions to the actionsheet
        
        let actionSheet = UIAlertController(title: "", message: "Share your match", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        actionSheet.addAction(shareOnTwitter)
        actionSheet.addAction(shareOnFacebook)
        actionSheet.addAction(shareOnSinaWeibo)
        actionSheet.addAction(dismissAction)
        
        actionSheet.popoverPresentationController?.sourceView = self.view
        
        presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "Wardrobe Share", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }

    

    @IBAction func deleteMatch(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Wardrobe", message: "Do you want to delete the match? ", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
            if self.wardrobe.deleteMatch() {
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            else {
                let failAlert = UIAlertController(title: "Wardrobe", message: "failed to delete the match", preferredStyle: UIAlertControllerStyle.Alert)
                failAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(failAlert, animated: true, completion: nil)
                
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
}
