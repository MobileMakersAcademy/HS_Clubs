//
//  EditProfileViewController.swift
//  HSClubs
//
//  Created by Bruce Wayne on 11/24/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if PFUser.currentUser()["profileImage"] != nil
        {
            let file = PFUser.currentUser()["profileImage"] as PFFile
            file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if error == nil
                {
                    self.profileImageView.image = UIImage(data: data)
                }
            })
        }
    }

    func setupTextFields()
    {
        let user = PFUser.currentUser()
        if user["firstName"] == nil
        {
            firstNameTextField.text = ""
        }
        else
        {
            firstNameTextField.text = user["firstName"] as String
        }

        if user["email"] == nil
        {
            emailTextField.text = ""
        }
        else
        {
            emailTextField.text = user["email"] as String
        }
    }

    @IBAction func openImagePickerOnTapped(sender: UITapGestureRecognizer)
    {
        let actionSheet = UIAlertController(title: "Choose photo selections source", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        actionSheet.addAction(cameraAction)
        let libraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (action) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        actionSheet.addAction(libraryAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func saveChangesOnTapped(sender: UIButton)
    {
        let user = PFUser.currentUser()
        user["firstName"] = firstNameTextField.text
        user["email"] = emailTextField.text
        let data = UIImagePNGRepresentation(profileImageView.image)
        user["profileImage"] = PFFile(data: data)
        user.saveInBackgroundWithBlock { (returnedResult, returnedError) -> Void in
            if returnedError == nil
            {

            }
            else
            {
                let alert = UIAlertController(title: "Sorry changes were not saved", message: returnedError.localizedDescription, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        imagePicker.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.profileImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        })
    }
}
