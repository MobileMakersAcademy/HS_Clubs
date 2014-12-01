//
//  ClubDetailViewController.swift
//  HSClubs
//
//  Created by Bruce Wayne on 11/24/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

import UIKit

class ClubDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var clubImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var club = PFObject(className: "Club")
    var commentsArray: [PFObject] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        queryForComments()
        let file = club["clubProfileImage"] as PFFile
        file.getDataInBackgroundWithBlock { (data, error) -> Void in
            if error == nil
            {
                self.clubImageView.image = UIImage(data: data)
            }
        }
        title = club["name"] as? String

    }

    func queryForComments()
    {
        let query = PFQuery(className: "Comment")
        query.whereKey("club", equalTo: club)
        query.findObjectsInBackgroundWithBlock { (returnedObjects, returnedError) -> Void in
            if returnedError == nil
            {
                self.commentsArray = returnedObjects as [PFObject]
                self.tableView.reloadData()
            }
            else
            {
                self.showErrorAlert("There was an error loading the Comments", error: returnedError)
            }
        }
    }

    func showErrorAlert(title: String, error: NSError)
    {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveCommentOnTapped(sender: UIButton)
    {
        let comment = PFObject(className: "Comment")
        comment["message"] = commentTextField.text
        comment["club"] = club
        comment["commenter"] = PFUser.currentUser()
        comment.saveInBackgroundWithBlock { (returnedResult, returnedError) -> Void in
            if returnedError == nil
            {
                self.commentsArray.append(comment)
                self.tableView.reloadData()
            }
            else
            {
                self.showErrorAlert("There was an error saving your comment", error: returnedError)
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return commentsArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let comment = commentsArray[indexPath.row] as PFObject
        
        cell.textLabel.text = comment["message"] as? String
        return cell
    }
}
