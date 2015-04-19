//
//  FriendListTableViewController.swift
//  ShoppingWithFriends
//
//  Created by Sylvia Chan on 4/18/15.
//  Copyright (c) 2015 Venkatramanan, Goutam. All rights reserved.
//

import UIKit

class FriendListTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var currentUser: String = ""
    var result: PFObject!
    var friends: Array<String> = []
    var filteredFriends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className:"Friends")
        query.whereKey("username", equalTo:currentUser)
        result = query.getFirstObject()
        friends = result["Friends"] as Array<String>
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterContentForSearchText(searchText:String){
        self.filteredFriends = self.friends.filter({(friendUser: String)-> Bool in
            let stringMatch = friendUser.rangeOfString(searchText)
            return stringMatch != nil ? true : false
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath) as UITableViewCell
        var alreadyFriends: String
        if tableView == self.searchDisplayController!.searchResultsTableView {
            alreadyFriends = filteredFriends[indexPath.row]
            cell.textLabel?.text = alreadyFriends
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        if(friends.count==0){
            cell.textLabel?.text = "You currently do not have any friends"
        }
        else{
            alreadyFriends = friends[indexPath.row]
            cell.textLabel?.text = alreadyFriends
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredFriends.count
        }
        if(friends.count==0){
            return 1
        }
        return friends.count
    }
    
    // Prepared to transfer current User information to FindFriendTableVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "searchForFriends"){
            let findFriendTableVC:FindFriendsTableViewController = segue.destinationViewController as FindFriendsTableViewController
            findFriendTableVC.currentUserObject = PFUser.currentUser()
            findFriendTableVC.currentUser = PFUser.currentUser().username
        }
    }
}
