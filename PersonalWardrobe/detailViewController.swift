//
//  detailViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/11/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit
import CoreData
import Social

class detailViewController: UIViewController {
    
    let wardrobe = Wardrobe.sharedInstance
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var detailSegmentControl: UISegmentedControl!
    
    weak var detailImageController: detailImageViewController?
    weak var detailInfoController: detailInfoViewController?
    
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        //initialize image and info view controllers
        
        self.detailImageController = self.storyboard?.instantiateViewControllerWithIdentifier("detailImage") as? detailImageViewController
        
        
        
        self.addChildViewController(self.detailImageController!)
        
        self.detailInfoController = self.storyboard?.instantiateViewControllerWithIdentifier("detailInfo") as? detailInfoViewController
        
        
        self.addChildViewController(self.detailInfoController!)
        
       //load the image view controller into container
        self.detailImageController!.view.frame = self.container.bounds
        self.container.addSubview(self.detailImageController!.view)
    
    }
    
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        
        switch detailSegmentControl.selectedSegmentIndex
        {
        case 0:
            
            
            self.detailInfoController!.view.removeFromSuperview()
            self.container.addSubview(self.detailImageController!.view)
            
            
            
            
        case 1:
            self.detailImageController!.view.removeFromSuperview()
            self.detailInfoController!.view.frame = self.container.bounds
            self.container.addSubview(self.detailInfoController!.view)


        default:
            break; 
        }
    }

    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        
        
        var transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
            
        if sender.direction == UISwipeGestureRecognizerDirection.Left {
            transitionOptions = UIViewAnimationOptions.TransitionFlipFromLeft
        }
        
        //set the animation style
        //let transitionOptions = UIViewAnimationOptions.TransitionFlipFromRight
        
        var views = (frontView: self.detailImageController!.view, backView: self.detailInfoController!.view)
        
        //change the segmentedcontrol index
        if (detailSegmentControl.selectedSegmentIndex == 0){
            detailSegmentControl.selectedSegmentIndex = 1
            
        }
            
        else {
            
            detailSegmentControl.selectedSegmentIndex = 0
            views = (frontView: self.detailInfoController!.view, backView: self.detailImageController!.view)
        }
        
        //switch between views
        
        UIView.transitionWithView(self.container, duration: 1.0, options: transitionOptions, animations: {
            
            views.frontView.removeFromSuperview()
            views.backView.frame = self.container.bounds
            self.container.addSubview(views.backView)
            
            }, completion: { finished in})

        
        
        
    }
    
    @IBAction func rotationGesture(sender:UIRotationGestureRecognizer) {
        self.navigationController?.popToRootViewControllerAnimated(true);
    }
    
    
    
    
    @IBAction func share(sender: UIBarButtonItem) {
        
        // Configure a new action for sharing the note in Twitter.
        
        let shareOnTwitter = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterComposeVC.addImage(self.detailImageController?.fullsizeImage.image)
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
                facebookComposeVC.addImage(self.detailImageController?.fullsizeImage.image)
                
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
                sinaWeiboComposeVC.addImage(self.detailImageController?.fullsizeImage.image)
                
                self.presentViewController(sinaWeiboComposeVC, animated: true, completion: nil)
            }
            else {
                self.showAlertMessage("You are not logged into your Sina Weibo account.")
            }
            
        }

        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        //add all actions to the actionsheet
        
        let actionSheet = UIAlertController(title: "", message: "Share your clothes", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
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
    
    
    @IBAction func deleteItem(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Wardrobe", message: "Do you want to delete the item? ", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            
            if self.wardrobe.delete() {
                self.navigationController?.popViewControllerAnimated(true)
                
            }
            else {
                let failAlert = UIAlertController(title: "Wardrobe", message: "Cannot delete the clothes, please delete all related matches first", preferredStyle: UIAlertControllerStyle.Alert)
                failAlert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(failAlert, animated: true, completion: nil)
                
            }
                
                        
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)

        
        
    }
    
    
    @IBAction func editItem(sender: UIBarButtonItem) {
        let editController = self.storyboard?.instantiateViewControllerWithIdentifier("editViewController") as! editViewController
        
        editController.editParent = self
        self.navigationController?.pushViewController(editController, animated: true)
    }
    
    
    
    

}
