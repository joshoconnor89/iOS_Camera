//
//  ViewController.swift
//  Camera
//
//  Created by Joshua O'Connor on 2/4/15.
//  Copyright (c) 2015 Joshua O'Connor. All rights reserved.
//

import UIKit
//controls all hardware, including movie, video camera, sound.  Crucial we import MobileCoreServices
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    //variable to see whether pic is from camera or gallery
    //OPTIONAL DECLARATION
    //? is crucial, makes value optionally declared (when error that something isn't initialized).  Without the ? we have an error Otherwise, we can do var newMedia:Bool = false
    //false is may not be the case, so not recommended.  use ?
    var newMedia:Bool?
    
//USE THE CAMERA
    @IBAction func useCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            let imagePicker = UIImagePickerController()
            //declare delegation for image picker as self
            //self is this class, this controller.  delegation for this variable is this calss
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            // kuTType - allows us to call it wheter its jpeg, gif, etc.  Mostly jpeg
            imagePicker.mediaTypes = [kUTTypeImage as NSString]
            //do not allow editing
            imagePicker.allowsEditing = false
            //present the controller that we dont even see right now.  The controller is the UIImagePicker controller
            //controller waiting for a delegate to call it
            //call own class (self)
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            //the  picture is a new pic from the camera
            newMedia = true
        }
    }
    
    

    @IBAction func useCameraRoll(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            //declare delegation for image picker as self
            //self is this class, this controller.  delegation for this variable is this class
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            // kuTType - allows us to call it wheter its jpeg, gif, etc.  Mostly jpeg
            imagePicker.mediaTypes = [kUTTypeImage as NSString]
            //do not allow editing
            imagePicker.allowsEditing = false
            //present the controller that we dont even see right now.  The controller is the UIImagePicker controller
            //controller waiting for a delegate to call it
            //call own class (self)
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            //the picture is not a new pic from the camera (rather from camera roll)
            newMedia = false
        }
    
    }
    


        //What happens after the picture is chosen
    func imagePickerController(picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject:AnyObject]){
        //cast image as a string
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        self.dismissViewControllerAnimated(true, completion: nil)
        //if the mediaType it actually is an image (jpeg)
        if mediaType.isEqualToString(kUTTypeImage as NSString){
            let image = info[UIImagePickerControllerOriginalImage] as UIImage
            imageView.image = image
            //image:didFinish.. if we arent able to save, pass to contextInfo in Error Handling
            if (newMedia == true){
                UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
                
            }
        }
    }
    
    
    //ERROR HANDLING
    //method tells what to do with the image
    //if there is an error, NSErrorPointer will tell us the error
    //NS is objective C
    //contextInfo: tells us why it didnt save
    func image(image:UIImage,didFinishSavingWithError error:NSErrorPointer,contextInfo:UnsafePointer<Void>){
        //this tells us if and why we cant save a pic
        if error != nil {
            //alert when something messes up
            let alert = UIAlertController(title: "Save Failed", message: "Failed to Save Image", preferredStyle:UIAlertControllerStyle.Alert)
            //create a button for that alert, with value OK
            let cancelAction = UIAlertAction(title:"OK", style: .Cancel, handler:nil)
            alert.addAction(cancelAction)
            //present same view controller again
            self.presentViewController(alert, animated: true, completion: nil)
            //what happens after this is up to you.  Most likely gets dismissed
        }
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

