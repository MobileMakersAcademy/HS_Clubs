//
//  NewClubViewController.swift
//  HSClubs
//
//  Created by Bruce Wayne on 11/24/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

import UIKit

class NewClubViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var clubNameTextField: UITextField!
    @IBOutlet weak var clubDescriptionTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!

    let imagePicker = UIImagePickerController()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }

    @IBAction func openImagePickerOnTapped(sender: UITapGestureRecognizer)
    {
        let actionSheet = UIAlertController(title: "Choose way to add photo", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (action) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        actionSheet.addAction(cameraAction)
        let photoRollAction = UIAlertAction(title: "Photo Roll", style: .Default) { (action) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        actionSheet.addAction(photoRollAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        presentViewController(actionSheet, animated: true, completion: nil)
    }


    @IBAction func createClubOnTapped(sender: UIButton)
    {
        let club = PFObject(className: "Club")
        club["name"] = clubNameTextField.text
        club["description"] = clubDescriptionTextField.text
        let data = UIImagePNGRepresentation(profileImageView.image)
        club["clubProfileImage"] = PFFile(data: data)
        club["createdBy"] = PFUser.currentUser()
        club.saveInBackgroundWithBlock { (returnedResult, returnedError) -> Void in
            if returnedError == nil
            {
                let relation = PFUser.currentUser().relationForKey("clubs")
                relation.addObject(club)
                PFUser.currentUser().saveInBackgroundWithBlock({ (returnedResult, error) -> Void in
                    if error == nil
                    {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else
                    {
                        self.showErrorAlert("Sorry we had an issue", error: error)
                    }
                })


            }
            else
            {
                self.showErrorAlert("Sorry there was an issue saving your club", error: returnedError)
            }
        }
    }

    func showErrorAlert(title: String, error: NSError)
    {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.profileImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        })
    }
}
