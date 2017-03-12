//
//  PostViewController.swift
//  ParseInstagramCP
//
//  Created by Eric Suarez on 3/12/17.
//  Copyright © 2017 Eric Suarez. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var imageToPost: UIImageView!
    
    var activityIndicator = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        })))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = true
        
        self.present(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageToPost.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageToPost.image = image
        } else{
            print("Something went wrong")
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func postImage(_ sender: Any) {
    
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "Post")
        
        post["caption"] = captionField.text
        
        post["userId"] = PFUser.current()!.objectId!
        post["owningUserId"] = PFUser.current()!
        
        //resize(image: imageToPost.image!, newSize: CGSize())
        
        let imageData = UIImagePNGRepresentation(imageToPost.image!)
        
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackground{ (success, error) -> Void in
            
            self.activityIndicator.stopAnimating()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error == nil {
                
                self.displayAlert(title: "Image Posted", message: "Your image has been posted successfully")
                
                self.imageToPost.image = nil
                
                self.captionField.text = ""
                
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                self.displayAlert(title: "Could not post image", message: "Please try again later")
                
            }
            
        }

        
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
