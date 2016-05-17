//
//  MenuViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 5/3/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {
    
    var parent : MainViewController?

    @IBAction func showFb(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        let fbVC = self.storyboard?.instantiateViewControllerWithIdentifier("fbVC") as! FeedbackViewController
        parent!.navigationController?.pushViewController(fbVC, animated: false)
   
        
    }
    @IBAction func showAbout(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        let aboutVC = self.storyboard?.instantiateViewControllerWithIdentifier("aboutVC")
        parent!.navigationController?.pushViewController(aboutVC!, animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

   }
