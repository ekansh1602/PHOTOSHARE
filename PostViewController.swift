//
//  PostViewController.swift
//  PHOTOSHARE
//
//  Created by Ekansh Anand Srivastava on 06/05/19.
//  Copyright © 2019 Avi Srivastava. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var comment: UITextField!
    @IBAction func postImage(_ sender: Any) {
        
        if let image = imageToPost.image{
        
        let post = PFObject(className: "Post")
        post["message"] = comment.text
        post["userId"] = PFUser.current()?.objectId
        //A FILE SHOULD BE CREATED OF THE IMAGE TO SEND IT TO THE DATABASE
        
            if let imageData = image.pngData(){
                
                //SPINNER CODE
                let activityIndicator=UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                
                activityIndicator.center=self.view.center
                activityIndicator.hidesWhenStopped=true
                activityIndicator.style=UIActivityIndicatorView.Style.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let imageFile = PFFile(name: "image.png", data: imageData)
                post["imageFile"] = imageFile
                
                post.saveInBackground { (success, error) in
                    
                    //WHEN DONE SPINNER STOPS
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if success {
                        self.displayAlert(title: "image posted", message: "your message posted successfully")
                        
                        
                        //ONCE UPLOADED REMOVING THE COMMENT AND IMAGE FROM THE TEXT FIELD AND THE IMAGE VIEW
                        self.comment.text = ""
                        self.imageToPost.image=nil
                    }
                    else{
                        self.displayAlert(title: "image not posted", message: "your message not posted because of an error")
                    }
                }
                
            }
            
        
        }

        
    }
    @IBAction func chooseImage(_ sender: Any) {
        let imagePickerController=UIImagePickerController()
        imagePickerController.delegate=self
        imagePickerController.sourceType=UIImagePickerController.SourceType.photoLibrary
        //FOR CAMERA imagePickerController.sourceType=UIImagePickerController.SourceType.camera
        imagePickerController.allowsEditing=false //NOT ALLOWS THE USER TO EDIT BEFORE UPLOAD
        self.present(imagePickerController, animated: true, completion: nil)//DISPLAYS THE MENU TO SELECT THE PHOTO
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]as? UIImage{
            imageToPost.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(title:String,message:String){
        let alertController=UIAlertController(title: "Error occurs", message: "Username or Pwassword is incorrect", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            print("ok button pressed")
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    

}
