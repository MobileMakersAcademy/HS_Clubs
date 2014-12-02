//
//  ClubsViewController.swift
//  HSClubs
//
//  Created by Bruce Wayne on 12/2/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

import UIKit

class ClubsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    var clubsArray : [PFObject] = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
        queryForClubs()
    }

    func queryForClubs()
    {
        let query = PFQuery(className: "Club")
        query.findObjectsInBackgroundWithBlock { (returnedObjects, returnedError) -> Void in
            if returnedError == nil
            {
                self.clubsArray = returnedObjects as [PFObject]
                self.tableView.reloadData()
            }
            else
            {
                let alert = UIAlertController(title: "Network Error", message: returnedError.localizedDescription, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let club = clubsArray[indexPath.row]
        cell.textLabel.text = club["name"] as? String
        let file = club["clubProfileImage"] as PFFile
        file.getDataInBackgroundWithBlock { (returnedData, returnedError) -> Void in
            if returnedError == nil
            {
                let image = UIImage(data: returnedData)
                cell.imageView.image = image
            }
            //TODO: add a default image if there is an error
        }

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return clubsArray.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let club = clubsArray[indexPath.row]
        let alert = UIAlertController(title: "Do you want to join this club?", message: nil, preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "YES", style: .Default) { (theAction) -> Void in
            let relation = PFUser.currentUser().relationForKey("clubs")
            relation.addObject(club)
            PFUser.currentUser().saveInBackgroundWithBlock({ (returnedResult, returnedError) -> Void in
                if returnedError != nil
                {
                    //TODO: Show network error alert
                }
            })
        }
        alert.addAction(yesAction)
        let noAction = UIAlertAction(title: "NO", style: .Cancel, handler: nil)
        alert.addAction(noAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}













