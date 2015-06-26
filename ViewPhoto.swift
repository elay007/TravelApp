//
//  ViewPhoto.swift
//  TravelApp
//
//  Created by internet on 4/6/15.
//  Copyright (c) 2015 dmancilla. All rights reserved.
//

import UIKit
import Photos
import CoreData

let reuseIdentifier = "PhotoCell"
let albumName = "TravelApp Folder"            //App specific folder name

class ViewPhoto: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var albumFound : Bool = false
    var assetCollection: PHAssetCollection!
    var photosAsset: PHFetchResult!
    var assetThumbnailSize:CGSize!
    
    var index: Int? = 0
    
    var sIndex : String? = ""
    
    var travelPhoto : Travel!
    var activityPhoto : Activity!
    
    @IBOutlet var imgView : UIImageView!
       
    
    //Actions & Outlets
    @IBAction func btnCamera(sender : AnyObject) {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            //load the camera interface
            var picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            //no camera available
            var alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alertAction)in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    @IBAction func btnPhotoAlbum(sender : AnyObject) {
        var picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
  
    //@Export photo
    @IBAction func btnExport(sender : AnyObject) {
        println("Export")
    }
    
    //@Remove photo from Collection
    @IBAction func btnTrash(sender : AnyObject) {
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .Default,
            handler: {(alertAction)in
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                    //Delete Photo
                    let request = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
                    request.removeAssets([self.photosAsset[self.index!]])
                    },
                    completionHandler: {(success, error)in
                        NSLog("\nDeleted Image -> %@", (success ? "Success":"Error!"))
                        alert.dismissViewControllerAnimated(true, completion: nil)
                        if(success){
                            // Move to the main thread to execute
                            dispatch_async(dispatch_get_main_queue(), {
                                self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
                                if(self.photosAsset.count == 0){
                                    println("No Images Left!!")
                                    self.navigationController?.popToRootViewControllerAnimated(true)
                                }else{
                                    if(self.index >= self.photosAsset.count){
                                        self.index = self.photosAsset.count - 1
                                    }
                                    self.displayPhoto()
                                }
                            })
                        }else{
                            println("Error: \(error)")
                        }
                })
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {(alertAction)in
            //Do not delete photo
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    /*
        //Recovery this INDEX Photo
        self.sIndex = activityPhoto.valueForKey("urlPicture") as? String
        if self.sIndex != nil {
            self.index = self.sIndex?.toInt()
        }
      */
        //Check if the folder exists, if not, create it
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject{
            //found the album
            self.albumFound = true
            self.assetCollection = first_Obj as? PHAssetCollection
        }else{
            //Album placeholder for the asset collection, used to reference collection in completion handler
            var albumPlaceholder:PHObjectPlaceholder!
            //create the folder
            NSLog("\nFolder \"%@\" does not exist\nCreating now...", albumName)
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumName)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
                },
                completionHandler: {(success:Bool, error:NSError!)in
                    if(success){
                        println("Successfully created folder")
                        self.albumFound = true
                        if let collection = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([albumPlaceholder.localIdentifier], options: nil){
                            self.assetCollection = collection.firstObject as PHAssetCollection
                        }
                    }else{
                        println("Error creating folder")
                        self.albumFound = false
                    }
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        println("ViewWillAppear")
        
        self.navigationController?.hidesBarsOnTap = true    //!!Added Optional Chaining
        
        self.displayPhoto()
        
        /*
        override func viewWillAppear(animated: Bool) {
        println("ViewWillAppear")
        
        // Get size of the collectionView cell for thumbnail image
        let scale:CGFloat = UIScreen.mainScreen().scale
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
        let cellSize = layout.itemSize
        self.assetThumbnailSize = CGSizeMake(cellSize.width, cellSize.height)
        }
        
        //fetch the photos from collection
        self.navigationController?.hidesBarsOnTap = false   //!! Use optional chaining
        self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)
        
        if let photoCnt = self.photosAsset?.count{
        if(photoCnt == 0){
        self.noPhotosLabel.hidden = false
        }else{
        self.noPhotosLabel.hidden = true
        }
        }
        self.collectionView.reloadData()
        }
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func displayPhoto(){
        // Set targetSize of image to iPhone screen size
        imgView.image = UIImage(data: self.activityPhoto.picture)
        if self.index != 0{
            
            let screenSize: CGSize = UIScreen.mainScreen().bounds.size
            let targetSize = CGSizeMake(screenSize.width, screenSize.height)
            
            let imageManager = PHImageManager.defaultManager()
            var ID = imageManager.requestImageForAsset(self.photosAsset[self.index!] as PHAsset, targetSize: targetSize, contentMode: .AspectFit, options: nil, resultHandler: {
                (result, info)->Void in
                self.imgView.image = result
            })
        }
        
    }
    
    //UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
           
            //Implement if allowing user to edit the selected image
      
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), {
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                    let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                    let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
                    let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset)
                    albumChangeRequest.addAssets([assetPlaceholder])
                    }, completionHandler: {(success, error)in
                        dispatch_async(dispatch_get_main_queue(), {
                            NSLog("Adding Image to Library -> %@", (success ? "Sucess":"Error!"))
                            picker.dismissViewControllerAnimated(true, completion: nil)
                        })
                })
                
            })
            
            self.activityPhoto.picture = UIImageJPEGRepresentation(image, 1)
            
            imgView.image = UIImage(data: self.activityPhoto.picture)
            
            imgView.image = image
            
        }
    
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
