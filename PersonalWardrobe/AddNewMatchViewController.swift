//
//  AddNewMatchViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 4/16/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit

class AddNewMatchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var matchCollection: UICollectionView!
    
    @IBOutlet weak var descrInput: UITextField!
    
    @IBOutlet weak var matchImage: UIImageView!
    
    //var matchImage:UIImage?
    var matchArray=[Clothes]()
    let picker = UIImagePickerController()
    
    let wardrobe = Wardrobe.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        matchCollection.delegate = self
        matchCollection.dataSource = self
        matchCollection.allowsMultipleSelection = true
        descrInput.placeholder = "Description"
        
        self.descrInput.delegate = self
        
        
    }

    @IBAction func addClothes(sender: AnyObject) {
        let categoryTableVC = self.storyboard?.instantiateViewControllerWithIdentifier("categoryTableVC") as! MainCategoryTableViewController
        categoryTableVC.title = "Main Categories"
        self.navigationController?.pushViewController(categoryTableVC, animated: true)
        
    }
    
    
    @IBAction func removeClothes(sender: AnyObject) {
        let indexPaths : NSArray = matchCollection.indexPathsForSelectedItems()!
        var indices = [Int]()
        for ip in indexPaths {
            indices.append(ip.row)
        }
        
        let keepIndices = Set(matchArray.indices).subtract(indices)
        var tmpArray = [Clothes]()
        for index in keepIndices {
            tmpArray.append(matchArray[index])
        }
        
        matchArray = tmpArray
        //matchArray = Array(PermutationGenerator(elements: matchArray, indices: keepIndices))
        
        //print("current size : \(matchArray.count)")
        
        matchCollection.reloadData()
      
    }
    
    
    
    
    @IBAction func saveMatch(sender: AnyObject) {
        
        if matchImage.image != nil || matchArray.count > 0 {
            if matchImage.image == nil {
                //if no image set, using the collectionview as the image
                
                UIGraphicsBeginImageContext(matchCollection.frame.size)
                
                matchCollection.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                
                matchImage.image = UIGraphicsGetImageFromCurrentImageContext()
                
            }
            
            
            let thumbnail = UIImageJPEGRepresentation(resizeImage(matchImage.image!,toSize:CGSize(width: 200,height: 200)), 1)
            
            let fullsizeimage = UIImageJPEGRepresentation(matchImage.image!, 1)
            wardrobe.createNewMatch(descrInput.text, clothes: matchArray, thumbnail: thumbnail, fullsizeImage: fullsizeimage)
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
        else {
            let alert = UIAlertController(title: "Alert", message: " No clothes and no image to save ", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
            
            alert.addAction(OKAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }

        
        
        

        
        
    }
    
    
    func resizeImage(image: UIImage, toSize newSize: CGSize) -> UIImage {
        
        let size = image.size
        let widthRatio = size.width / newSize.width
        let heightRatio = size.height / newSize.height
        
        let newHeight :CGFloat
        let newWidth : CGFloat
        
        if widthRatio > heightRatio {
            newHeight = size.height / widthRatio
            newWidth = 200
        }
        else {
            newHeight = 200
            newWidth = size.width / heightRatio
        }
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print("image resized successfully")
        
        return newImage
    }

    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matchArray.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ClothesCell", forIndexPath: indexPath) as! thumbnailCell
        
        cell.thumbnailImage.image = UIImage(data: matchArray[indexPath.row].thumbnail!)
        cell.layer.backgroundColor = UIColor.whiteColor().CGColor
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell!.backgroundColor = UIColor.orangeColor()
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell!.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        matchCollection.reloadData()
        
    }
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        matchImage.contentMode = .ScaleAspectFit
        matchImage.image = chosenImage
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func addImage(sender: AnyObject) {
        
        
        
        let takePic = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            
            self.picker.sourceType = .Camera
            
            self.presentViewController(self.picker, animated: true, completion: nil)
            
        }
        
       
        let seleFromLib = UIAlertAction(title: "Select from photo library", style: UIAlertActionStyle.Default) { (action) -> Void in
            
            self.picker.allowsEditing = false
            self.picker.sourceType = .PhotoLibrary
            self.presentViewController(self.picker, animated: true, completion: nil)

            
        }
        
        
        
        
        let dismissAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        //add all actions to the actionsheet
        
        let actionSheet = UIAlertController(title: "", message: "Add an image for the match", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        
        actionSheet.addAction(takePic)
        actionSheet.addAction(seleFromLib)
        
        actionSheet.addAction(dismissAction)
        actionSheet.popoverPresentationController?.sourceView = self.view
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return false
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
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
        
        let width = (screenWidth - leftRightMargin - totalCellSpace - 20) / numColumns
        let height = width * 1.2
        
        
        return CGSizeMake(width, height);
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.matchCollection?.collectionViewLayout.invalidateLayout()
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }


   
    
}
