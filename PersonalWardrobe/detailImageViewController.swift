//
//  detailImageViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/14/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class detailImageViewController: UIViewController {

    @IBOutlet weak var fullsizeImage: UIImageView!
    
    let wardrobe = Wardrobe.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
               
    }
    
    override func viewWillAppear(animated: Bool) {
        fullsizeImage.image = UIImage(data: wardrobe.currentClothes!.fullsizeImg!.fullsizeimage!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
