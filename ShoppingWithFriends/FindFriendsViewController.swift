//
//  FindFriendsViewController.swift
//  ShoppingWithFriends
//
//  Created by Sylvia Chan on 4/19/15.
//  Copyright (c) 2015 Venkatramanan, Goutam. All rights reserved.
//

import UIKit

class FindFriendsTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate  {
    
    var currentUserObject: PFObject!
    var result: PFObject!
    var currentUser: String = ""
    var notFriends: Array<String> = []
    var friends: Array<String> = []
    var actualNotFriend: Array<String> = []
    var filteredNotFriends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        notFriends = []
        friends = []
        actualNotFriend = []
        filteredNotFriends = []
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        var count:Int = 0
        var query = PFQuery(className:"Friends")
        var notFriendsPFObject = query.findObjects() as [PFObject]
        for user in notFriendsPFObject { // message is of PFObject type
            var notFriendName:String = user["username"] as String
            if notFriendName != currentUser {
                notFriends.insert(notFriendName, atIndex: count++)
            }
        }
        println("before delete")
        for notFriendUser in notFriends{
            println(notFriendUser)
        }
        var query2 = PFQuery(className:"Friends")
        query2.whereKey("username", equalTo:currentUser)
        result = query2.getFirstObject()
        friends = result["Friends"] as Array<String>
        var added:Bool = true
        for notFriendUser in notFriends{
            added = true
            var outerCount = 0
            for friendUser in friends{
                if(notFriendUser==friendUser){
                    added = false
                }
            }
            if(added){
                actualNotFriend.insert(notFriendUser, atIndex: 0)
            }
            outerCount++
        }
        notFriends = actualNotFriend
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* filter the notfriends array based on searchText (which is the search string entered by the user),
    and will put the results in the filteredNotFriends array. */
    func filterContentForSearchText(searchText:String, scope: String = "All"){
        self.filteredNotFriends = self.notFriends.filter({(notFriendUser: String)-> Bool in
            var categoryMatch = (scope == "All") || (notFriendUser == scope)
            var stringMatch = notFriendUser.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    /*  runs the text filtering function whenever the user changes the search string in the search bar. */
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    /* handle the changes in the Scope Bar input. */
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    /* tests to see if the currently displayed tableView is the search table or the normal table. If it is indeed the search table, the data is taken from the filteredNotFriends array. Otherwise, the data comes from the full list of items. */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("searchFriendCell") as UITableViewCell
        var notYetFriends: String = ""
        if tableView == self.searchDisplayController!.searchResultsTableView {
            notYetFriends = filteredNotFriends[indexPath.row]
        }
        else if(self.notFriends.count==0){
            cell.textLabel?.text = "no aviliable users for adding"
        }
        else{
            notYetFriends = self.notFriends[indexPath.row]
        }
        if(self.notFriends.count==0){
            cell.textLabel?.text = "no aviliable users for adding"
        }
        else{
            cell.textLabel?.text = notYetFriends
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredNotFriends.count
        }
        else if(self.notFriends.count==0){
            return 1
        }
        else{
            return notFriends.count
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var pass:Bool = true
        if(notFriends.count==0){
            pass = false
        }
        if(pass){
        self.performSegueWithIdentifier("userDetail", sender: tableView)
        }
    }
    
    // Prepared to transfer current User information to FindFriendTableVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "userDetail"){
            let userProfileVC:UserProfileViewController = segue.destinationViewController as UserProfileViewController
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                let destinationTitle = self.filteredNotFriends[indexPath.row]
                userProfileVC.displayUser = destinationTitle
                userProfileVC.currentUser = self.currentUser
            } else {
                let indexPath = self.tableView.indexPathForSelectedRow()!
                let destinationTitle = self.notFriends[indexPath.row]
                userProfileVC.displayUser = destinationTitle
                userProfileVC.currentUser = self.currentUser
            }
        }
    }
    
}
