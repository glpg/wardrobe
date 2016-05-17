//
//  FeedbackViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 5/3/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: UIViewController,MFMailComposeViewControllerDelegate {

    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if MFMailComposeViewController.canSendMail(){
            let picker = MFMailComposeViewController()
            
            
            picker.mailComposeDelegate = self
            picker.setSubject("[Wardrobe feedback]")
            picker.setToRecipients(["yxuecs@gmail.com"])
            picker.title = "Feedback"
            presentViewController(picker, animated: true, completion: nil)

            
        }
        
        else {
            let alert = UIAlertController(title: "Alert", message: " No email account has been set up on the device ", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
            
            alert.addAction(OKAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            infoLabel.text = "Please set up your email account to leave feedback."
        }
        
  
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        var prompt = ""
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue, MFMailComposeResultSaved.rawValue:
            prompt = "You do not want leave a feedback ?"
            
        case MFMailComposeResultSent.rawValue:
            prompt = "Thanks for your feedback."
        case MFMailComposeResultFailed.rawValue:
            prompt = "You feedback did not send out succesfully, please check your email settings."
        default:
            break
        }
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
        
        infoLabel.text = prompt
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    

    
}
