//
//  ViewPhotoCoreData.swift
//  TravelApp
//
//  Created by internet on 5/6/15.
//  Copyright (c) 2015 dmancilla. All rights reserved.
//

import UIKit
import Photos
import CoreData

class ViewPhotoCoreData: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
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

    
    //@Remove photo from Collection
    @IBAction func btnTrash(sender : AnyObject) {
        
        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { alertAction in
            
            let aux: NSData = NSData()
            
            self.activityPhoto.picture = aux
            
            self.displayPhoto()
            
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: {(alertAction)in
            //Do not delete photo
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        println("ViewWillAppear")
        
        self.navigationController?.hidesBarsOnTap = true    //!!Added Optional Chaining
        
    
        self.displayPhoto()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func displayPhoto(){
        // Set targetSize of image to iPhone screen size
        imgView.image = UIImage(data: self.activityPhoto.picture)
        
    }
    
    //UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            picker.dismissViewControllerAnimated(true, completion: nil)
            
            self.activityPhoto.picture = UIImageJPEGRepresentation(image, 1)
            
            imgView.image = UIImage(data: self.activityPhoto.picture)
            
            imgView.image = image
            
        }
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
