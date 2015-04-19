//
//  FriendListTableViewController.swift
//  ShoppingWithFriends
//
//  Created by Sylvia Chan on 4/18/15.
//  Copyright (c) 2015 Venkatramanan, Goutam. All rights reserved.
//

import UIKit

class FriendListTableViewController: UITableViewController {

    var currentUser: String = ""
    var result: PFObject!
    var friends: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var query = PFQuery(className:"Friends")
        query.whereKey("username", equalTo:currentUser)
        result = query.getFirstObject()
        friends = result["Friends"] as Array<String>
        //var hi:String = friends[1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath) as UITableViewCell
        for(var index = 0; index < friends.count; index++){
            var hi = friends[indexPath.row]
            cell.textLabel?.text = hi
            
        }
        //cell.textLabel?.text = currentUser
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return friends.count
//        return 1
    }
    
    
//    tableView
//    tableView
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
}
