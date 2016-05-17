//
//  colorViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/19/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class colorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func colorSelected(sender: UIButton) {
        
        let index = self.navigationController?.viewControllers.indexOf(self)
            
        let parentVC = self.navigationController!.viewControllers[index!-1] as! editViewController
            
        parentVC.colorIndex = sender.tag
        parentVC.colorChanged = true
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    
    
}
