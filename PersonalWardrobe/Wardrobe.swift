//
//  Wardrobe.swift
//  PersonalWardrobe
//
//  Created by Yi Xue on 3/21/16.
//  Copyright © 2016 Yi Xue. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Wardrobe {
    
    class var sharedInstance: Wardrobe {
        struct Singleton {
            
            static let instance = Wardrobe()
        }
        
        return Singleton.instance
        
    }
    
  

    var currentClothes : Clothes?
    var currentCollection : [Clothes]?
    var currentMatch : Matches?
    var currentMatchCollection : [Matches]?
    
    var browseCollections : [String : [Clothes]]?
    var mainCategories : [String]?
    var colors : [String]?
    var subCategories = [String:[String]]()
    var context : NSManagedObjectContext?
    var currentMainCategory : String?
    var currentSubCategory : String?
    var currentChanged = false
    var sortType : String?
    
    init(){
        mainCategories = ["Hat", "Scarf", "Bag", "Tops", "Bottoms", "Skirt", "Dress", "Shoe", "Match"]
        
        subCategories["Tops"] = ["Blouse","Tshirts/tanks","Outerwear", "Sweater", "Cardigans"]
        subCategories["Bottoms"] = ["Jeans","Pants","Shorts"]
        
        colors = ["Black", "Gray", "White", "Blue", "Green", "Multicolor", "Brown", "Orange", "Yellow", "Red","Purple","Pink"]
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDel.managedObjectContext
        
    }
    
    //fetch collections of main category
    func fetchMaincategory(maincategory: String) {
        
        if (maincategory == "Match"){
            let fetchRequest = NSFetchRequest(entityName: "Matches")
                        
            do {
                currentMatchCollection = try context!.executeFetchRequest(fetchRequest) as? [Matches]
                
            }
            catch {
                print("failed to fetch items")
                
            }

            
        }
        
        else {
            let fetchRequest = NSFetchRequest(entityName: "Clothes")
            
            fetchRequest.predicate = NSPredicate(format: "category == %@", maincategory)
            
            do {
                currentCollection = try context!.executeFetchRequest(fetchRequest) as? [Clothes]
                
            }
            catch {
                print("failed to fetch items")
                
            }

            
        }
        
        
        
    }
    
    
    // fetch collecions of subcategory
    func fetchSubcategory(subcategory: String) {
        
        let fetchRequest = NSFetchRequest(entityName: "Clothes")
        
        fetchRequest.predicate = NSPredicate(format: "subcategory == %@", subcategory)
        
        do {
            currentCollection = try context!.executeFetchRequest(fetchRequest) as? [Clothes]
            
        }
        catch {
            print("failed to fetch items")
            
        }

    }
    
    
    //create new match
    func createNewMatch(description : String?, clothes: [Clothes], thumbnail : NSData?, fullsizeImage: NSData?) ->Bool
    {
        
        let newMatch = NSEntityDescription.insertNewObjectForEntityForName("Matches", inManagedObjectContext: context!) as! Matches
        
        let fImage = NSEntityDescription.insertNewObjectForEntityForName("MatchImages", inManagedObjectContext:context!) as! MatchImages
        fImage.match = newMatch
        fImage.fullsizeimage = fullsizeImage
        
        newMatch.image = fImage
        newMatch.thumbnail = thumbnail
        newMatch.name = description
        
        newMatch.clothes = NSSet().setByAddingObjectsFromArray(clothes)
                
        currentMatchCollection?.append(newMatch)
        
        
        do {
            try
                context!.save()
            return true
            
        } catch {
            print("failed to save to core data")
            return false
        }
        
    }
    
    //delete current match item
    func deleteMatch()-> Bool {
        if currentMatch!.clothes != nil || currentMatch!.clothes!.count > 0 {
            
            for item in currentMatch!.clothes! {
                let temp = item as! Clothes
                temp.mutableSetValueForKey("matches").removeObject(currentMatch!)
            
            }
            
        }
        
        currentMatchCollection!.removeAtIndex(currentMatchCollection!.indexOf(currentMatch!)!)
        
        
        context!.deleteObject((currentMatch?.image)!)
        context!.deleteObject(currentMatch!)
        
        
        currentMatch = nil
        
        do {
            try context!.save()
            
            return true
        } catch let error {
            print("Could not delete the match \(error)")
            return false
        }
        
    }

    

    
    
    
    //create new item
    func createNew(color: String?, fabric: String?, brand: String? , price: String?, from: String?, tag: String?, thumbnail : NSData?, fullsizeImage: NSData?) ->Bool
    {
        
        let newClothes = NSEntityDescription.insertNewObjectForEntityForName("Clothes", inManagedObjectContext: context!) as! Clothes
        
        let fImage = NSEntityDescription.insertNewObjectForEntityForName("FullsizeImages", inManagedObjectContext:context!) as! FullsizeImages
        fImage.clothes = newClothes
        fImage.fullsizeimage = fullsizeImage
        
        newClothes.fullsizeImg  = fImage
        newClothes.color  =  color
        newClothes.brand  =  brand
        newClothes.fabric =  fabric
        newClothes.from = from
        if let p = price {
            newClothes.price = NSDecimalNumber(string: p)
        }
        
        newClothes.tag = tag
        newClothes.thumbnail = thumbnail
        
        newClothes.category = currentMainCategory
        if currentMainCategory == "Tops" || currentMainCategory == "Bottoms" {
            newClothes.subcategory = currentSubCategory
        }
        
        
        currentCollection?.append(newClothes)
        
        
        do {
            try
                context!.save()
            currentChanged = true
            return true
            
        } catch {
            print("failed to save to core data")
            return false
        }

    }
    
    //edit current item
    func edit(thumbnail : NSData?, fullsizeImage :NSData?)-> Bool{
        
        if (fullsizeImage != nil) {
            //delete old image
            context!.deleteObject(currentClothes!.fullsizeImg! as NSManagedObject)
            
            let fImage = NSEntityDescription.insertNewObjectForEntityForName("FullsizeImages", inManagedObjectContext:context! ) as! FullsizeImages
            
            fImage.clothes = currentClothes
            fImage.fullsizeimage = fullsizeImage
            
            currentClothes!.thumbnail = thumbnail
            currentClothes!.fullsizeImg  = fImage
            
        }
        
        do {
            try
                context!.save()
            currentChanged = true
            return true
            
        } catch {
            print("failed to save to core data")
            return false
        }

    }
    
    //delete current item
    func delete()-> Bool {
        if currentClothes!.matches != nil && currentClothes!.matches!.count > 0{
            print (currentClothes!.matches!.count)
            return false
        }
            
        
        
        currentCollection!.removeAtIndex(currentCollection!.indexOf(currentClothes!)!)
        
        
        context!.deleteObject((currentClothes?.fullsizeImg)!)
        context!.deleteObject(currentClothes!)
        
        
        currentClothes = nil
        
        do {
            try context!.save()
            
            currentChanged = true
            return true
        } catch let error {
            print("Could not cache the response \(error)")
            return false
        }
        
    }
    
    
    
    
    
    
    //retrieve the browse collections
    func fetchBrowseCollections(keyword : String){
        
        currentChanged = false
        sortType = keyword
        
        switch (sortType!) {
            case "Color": sortByColor()
            case "Brand": sortByBrand()
            case "Fabric": sortByFabric()
            case "Price range": sortByPrice()
            default: print("invalid sort keyword")
        }
            
        
    }
    
        
    func sortByColor(){
        //set up a dic pair for color not set items
        browseCollections = [String : [Clothes]]()
        
        
        for item in currentCollection! {
            
            if item.color! == "" {
                
              if !browseCollections!.keys.contains("others") {
                browseCollections!["others"] = [Clothes]()
              }
                browseCollections!["others"]?.append(item as Clothes)
                continue
            }
            
            if (browseCollections!.keys.contains(item.color!.lowercaseString)){
                browseCollections![item.color!.lowercaseString]!.append(item as Clothes)
                
            }
            
            else {
                browseCollections![item.color!.lowercaseString] = [Clothes]()
                browseCollections![item.color!.lowercaseString]!.append(item as Clothes)
                
            }
            
            
        }
        print(browseCollections!.keys.count)
    }
    
    func sortByBrand(){
        browseCollections = [String : [Clothes]]()
       
        for item in currentCollection! {
            
            if item.brand! == "" {
                if !browseCollections!.keys.contains("others") {
                    browseCollections!["others"] = [Clothes]()
                    
                }
              
                browseCollections!["others"]!.append(item as Clothes)
           }
             
            else {
                
                if !browseCollections!.keys.contains(item.brand!.lowercaseString){
                    
                    browseCollections![item.brand!.lowercaseString] = [Clothes]()
                }
                browseCollections![item.brand!.lowercaseString]!.append(item as Clothes)
            }
            
            
        }
        
    }

    
    func sortByFabric(){
        browseCollections = [String : [Clothes]]()
        
        
        for item in currentCollection! {
            if item.fabric! == "" {
                
                if !browseCollections!.keys.contains("others") {
                    browseCollections!["others"] = [Clothes]()
                    
                }
                browseCollections!["others"]!.append(item as Clothes)
                
                continue
            }
            
            
            
            else {
                
                if !browseCollections!.keys.contains(item.fabric!.lowercaseString){
                    
                    browseCollections![item.fabric!.lowercaseString] = [Clothes]()
                }
                browseCollections![item.fabric!.lowercaseString]!.append(item as Clothes)
            }
            
            
        }

        
    }
    
    func sortByPrice(){
        browseCollections = [String : [Clothes]]()
        
        
        if currentCollection!.count > 0 {
            browseCollections!["unpriced"] = [Clothes]()
            browseCollections!["$ 0 - 20"] = [Clothes]()
            browseCollections!["$ 2O - 50"] = [Clothes]()
            browseCollections!["$ 50 - 200"] = [Clothes]()
            browseCollections!["> $ 200"] = [Clothes]()
   
        }
        
        
        for item in currentCollection! {
            
            
            if (item.price!.doubleValue.isNaN) {
                
                browseCollections!["unpriced"]?.append(item as Clothes)
                continue
             
            }

            if (item.price!.doubleValue < 20) {
                browseCollections!["$ 0 - 20"]?.append(item as Clothes)
                continue

            }
            
            if (item.price!.doubleValue >= 20 && item.price!.doubleValue < 50) {
                browseCollections!["$ 2O - 50"]?.append(item as Clothes)
                continue
                
            }
            
            if (item.price!.doubleValue >= 50 && item.price!.doubleValue < 200) {
                browseCollections!["$ 50 - 200"]?.append(item as Clothes)
                continue
                
            }
            if (item.price!.doubleValue >= 200) {
                browseCollections!["> $ 200"]?.append(item as Clothes)
                continue
                
            }
            
            
        }

        
        
    }
    
    
}