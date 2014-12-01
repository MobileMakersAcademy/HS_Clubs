//
//  ViewController.swift
//  HSClubs
//
//  Created by Bruce Wayne on 11/24/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    var clubsArray: [PFObject] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()

        if PFUser.currentUser() == nil
        {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
        else
        {
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

            if PFUser.currentUser()["firstName"] != nil
            {
                title = PFUser.currentUser()["firstName"] as? String
            }
        }
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        if PFUser.currentUser() != nil
        {
            queryForClubs()
        }
    }

    func queryForClubs()
    {
        if let relation = PFUser.currentUser()["clubs"] as? PFRelation
        {
            let query = relation.query()
            query.findObjectsInBackgroundWithBlock { (returnedObjects, returnedError) -> Void in
                if returnedError == nil
                {
                    self.clubsArray = returnedObjects as [PFObject]
                    self.tableView.reloadData()
                }
                else
                {
                    self.showErrorAlert("We were unable to load your Clubs", error: returnedError)
                }
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

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let club = clubsArray[indexPath.row]
        cell.textLabel.text = club["name"] as? String
        let file = club["clubProfileImage"] as PFFile
        file.getDataInBackgroundWithBlock { (data, error) -> Void in
            if error == nil
            {
                cell.imageView.image = UIImage(data: data)
            }
        }
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return clubsArray.count
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "ClubDetailSegue"
        {
            let clubDetailVC = segue.destinationViewController as ClubDetailViewController
            let indexPath = tableView.indexPathForSelectedRow()
            let selectedClub = clubsArray[indexPath!.row] as PFObject
            clubDetailVC.club = selectedClub
        }
    }





}

