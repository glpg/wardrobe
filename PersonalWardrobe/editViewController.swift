//
//  editViewController.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/19/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import UIKit
import CoreData

class editViewController: UIViewController,  UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let colors = ["Black", "Gray", "White", "Blue", "Green", "Multicolor", "Brown", "Orange", "Yellow", "Red", "Purple", "Pink"]
    
    var addNewParent : itemsCollectionController?
    var editParent : detailViewController?
    var imageChanged  = false
    var colorIndex = 0
    var colorChanged = false
    
    let wardrobe = Wardrobe.sharedInstance
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var fabric: UITextField!
    
    @IBOutlet weak var brand: UITextField!
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var from: UITextField!
    
    @IBOutlet weak var tag: UITextField!
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var selectImageBtn: UIButton!

    @IBOutlet weak var chooseColorBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        itemImage.layer.borderColor = UIColor.blackColor().CGColor
        itemImage.layer.borderWidth = 2.0
        itemImage.layer.backgroundColor = UIColor.whiteColor().CGColor
        
        
        
        selectImageBtn.layer.cornerRadius = 5.0
        
        saveBtn.layer.cornerRadius = 5.0
        chooseColorBtn.layer.cornerRadius = 5.0
        
        fabric.placeholder = "Fabric"
        brand.placeholder = "Brand"
        from.placeholder = "Purchase Store"
        price.placeholder = "Price"
        tag.placeholder = "Customerized Tag"

        
        
        //populate data for edit
        if (editParent != nil) {
            let item = wardrobe.currentClothes
            
            colorLabel.text = item?.color
            fabric.text = item?.fabric
            brand.text = item?.brand
            from.text = item?.tag
            tag.text = item?.tag
            
            if (!(item!.price!.doubleValue.isNaN)) {
                
                price.text = String(format:"%0.2f", item!.price!.doubleValue)
                
                
            }
            
            itemImage.image = UIImage(data: item!.fullsizeImg!.fullsizeimage!)

            
        }
        
        self.fabric.delegate = self;
        self.brand.delegate = self;
        self.from.delegate = self;
        self.tag.delegate = self;
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Black", "Gray", "White", "Blue", "Green", "Multicolor", "Brown", "Orange", "Yellow", "Red", "Purple", "Pink"
        
        if colorChanged {
            colorLabel.text = colors[colorIndex]
            switch(colorLabel.text!) {
            case "Black" :
                colorLabel.textColor = UIColor.blackColor()
            case "Gray" :
                colorLabel.textColor = UIColor.grayColor()
            case "White" :
                colorLabel.textColor = UIColor.whiteColor()
            case "Blue" :
                colorLabel.textColor = UIColor.blueColor()
            case "Green" :
                colorLabel.textColor = UIColor.greenColor()
            case "Brown" :
                colorLabel.textColor = UIColor.brownColor()
            case "Orange" :
                colorLabel.textColor = UIColor.orangeColor()
            case "Yellow" :
                colorLabel.textColor = UIColor.yellowColor()
            case "Red" :
                colorLabel.textColor = UIColor.redColor()
            case "Purple" :
                colorLabel.textColor = UIColor.purpleColor()
            case "Pink" :
                colorLabel.textColor = UIColor.magentaColor()
            default:
                
                colorLabel.textColor = UIColor.blackColor()
                
            }
            
        }
        
    }
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        itemImage.contentMode = .ScaleAspectFit
        itemImage.image = chosenImage
        self.imageChanged = true
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
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


    @IBAction func selectPicPressed(sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func chooseColor(sender: UIButton) {
        
        let colorVC = self.storyboard?.instantiateViewControllerWithIdentifier("colorViewController") as! colorViewController
        
        self.navigationController!.pushViewController(colorVC, animated: true)
                
    }

    
    @IBAction func savePressed(sender: AnyObject){
        
        
        if(addNewParent != nil) {addNewItem()}
        
        if(editParent != nil) {editItem()}
      
        
    }
    
    
    
    func addNewItem(){
       
        //if the image selected (mandatory), save to core data
        
        if(itemImage.image != nil) {
          
            let thumbnail = UIImageJPEGRepresentation(resizeImage(itemImage.image!,toSize:CGSize(width: 200,height: 200)), 1)
            let fullsizeimage = UIImageJPEGRepresentation(itemImage.image!, 1)
            
            wardrobe.createNew(colorLabel.text, fabric: fabric.text, brand:brand.text, price:price.text, from:from.text, tag:tag.text, thumbnail: thumbnail, fullsizeImage:fullsizeimage)
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
            
        //if image not selected, pop out alert
            
        else {
            let alert = UIAlertController(title: "Alert", message: " No image selected ", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
            
            alert.addAction(OKAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
  
    }
        
        
    
    func editItem(){
        
        let item = wardrobe.currentClothes
        
        
            item?.color = colorLabel.text
            item?.fabric = fabric.text
            item?.brand = brand.text
            item?.tag = tag.text
            item?.from = from.text
            
            
            if (price.text != nil) {
                
                item?.price = NSDecimalNumber(string: price.text!)
            }
            
            var thumbnail : NSData?
            var fullsizeimage : NSData?
            
           
            if imageChanged {
                thumbnail = UIImageJPEGRepresentation(resizeImage(itemImage.image!,toSize:CGSize(width: 200,height: 200)), 1)
                fullsizeimage = UIImageJPEGRepresentation(itemImage.image!, 1)
                
            }
            
            wardrobe.edit(thumbnail, fullsizeImage: fullsizeimage)
     
            
            self.navigationController?.popViewControllerAnimated(true)
        
        
            
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return false
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }

   


}
