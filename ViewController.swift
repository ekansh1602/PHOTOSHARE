//
//  ViewController.swift
//  PHOTOSHARE
//
//  Created by Ekansh Anand Srivastava on 12/03/19.
//  Copyright © 2019 Avi Srivastava. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        let comment=PFObject(className: "Comment")
        comment["text"]="Nice Photo!"
        comment.saveInBackground { (success, error) in
            if(success==true){
                print("save successful")
            }
            else{
                print("not successfull")
            }
        }
 
        let query=PFQuery(className: "Comment")
        query.getObjectInBackground(withId: "say0HNFYFp") { (object, error) in
            if let comment=object{
               // print(comment)
                //TO GET ONLY COMMENT
                if let text=comment["text"]{
                    print(text)
                    
                //UPDATE DATA
                    comment["text"]="Rubbhish Photo!"
                    comment.saveInBackground(block: { (success, error) in
                        if(success==true){
                            print("update successfull")
                        }
                        else{
                            print("not successfull")
                        }
                    })
                }
            }
        }
 
        
        let tweet=PFObject(className: "tweet")
        tweet["text"]="Hello Ekansh Here"
        tweet.saveInBackground { (success, error) in
            if(success==true){
                print("saved successfully")
            }
            else{
                print("not successfull")
            }
        }
        let query=PFQuery(className: "tweet")
        query.getObjectInBackground(withId: "2VFQVYxZCm") { (object, error) in
            if let tweet=object{
                print(tweet)
            }
            if let text=tweet["text"]{
                print(text)
            }
        }
 
 */
        
    }
    

    var signupModeActive=true
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signuporlogin: UIButton!
    @IBOutlet weak var switchbutton: UIButton!
    @IBAction func signuporlogin(_ sender: Any) {
        
        if(email.text=="" || password.text==""){
            
            let alertController=UIAlertController(title: "Error occurs", message: "Username or Pwassword is incorrect", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                print("ok button pressed")
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            
            //SPINNER CODE
            let activityIndicator=UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center=self.view.center
            activityIndicator.hidesWhenStopped=true
            activityIndicator.style=UIActivityIndicatorView.Style.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()

            
            print("signing up....")
            
        if(signupModeActive){

        let user = PFUser()
        user.username = email.text
        user.password = password.text
        user.email = email.text
        user.signUpInBackground(block: {
            (success , error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if let error = error {
                //let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                
                let alertController=UIAlertController(title: "Could not Sign-Up", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    print("ok button pressed")
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
                
                
                print(error)
            }
            
            if((self.password.text?.count)!<5){
                
                let alertController=UIAlertController(title: "Credentials Error", message: "Check the length of Username or Password", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    print("ok button pressed")
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            
            else {
                // Hooray! Let them use the app now.
                print("signed up")
                self.performSegue(withIdentifier: "showUserTable", sender: self)
            }
            
            
        })

    }
        else{
            PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user, error) in
                
                if( user != nil){
                    print("login successful")
                    self.performSegue(withIdentifier: "showUserTable", sender: self)
                }
                else{
                    
                    var errortext="Unknown error present"
                    
                    if error != nil {
                        errortext=(error!.localizedDescription)
                    }
                    
                    
                    let alertController=UIAlertController(title: "Could not Sign-Up", message: errortext, preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        print("ok button pressed")
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
            }
            
    }
    }
    @IBAction func switchbutton(_ sender: Any) {
        if(signupModeActive==true){
            signupModeActive=false
            signuporlogin.setTitle("Login", for: [])
            switchbutton.setTitle("Signup", for: [])
        }
        else{
            signupModeActive=true
            signuporlogin.setTitle("Signup", for: [])
            switchbutton.setTitle("Login", for: [])
        }
        
    }
    //THIRD SEGUE WHEN USER IS ALREADY LOGGED IN (SEGUE CANNOT BE PERFORMED UNTIL VIEW IS LOADED)
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil{
            self.performSegue(withIdentifier: "showUserTable", sender: self)
        }

        self.navigationController?.navigationBar.isHidden=true
    }
}

