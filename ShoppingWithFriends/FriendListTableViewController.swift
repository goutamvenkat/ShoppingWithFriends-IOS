//
//  FriendListTableViewController.swift
//  ShoppingWithFriends
//
//  Created by Sylvia Chan on 4/18/15.
//  Copyright (c) 2015 Venkatramanan, Goutam. All rights reserved.
//

import UIKit

class FriendListTableViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var currentUser: String = PFUser.currentUser()!.username!
    var result: PFObject!
    var friends: Array<String> = []
    var filteredFriends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        friends=[]
        filteredFriends=[]
        var query = PFQuery(className:"Friends")
        query.whereKey("username", equalTo:currentUser)
        result = query.getFirstObject()
        friends = result["Friends"] as! Array<String>
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* filter the friends array based on searchText (which is the search string entered by the user),
    and will put the results in the filteredFriends array. */
    func filterContentForSearchText(searchText:String){
        self.filteredFriends = self.friends.filter({(friendUser: String)-> Bool in
            let stringMatch = friendUser.rangeOfString(searchText)
            return stringMatch != nil ? true : false
        })
    }
    
    /* runs the text filtering function whenever the user changes the search string in the search bar. */
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    /* handle the changes in the Scope Bar input.  */
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    /* tests to see if the currently displayed tableView is the search table or the normal table. If it is indeed the search table, the data is taken from the filteredFriends array. Otherwise, the data comes from the full list of items. */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath) as! UITableViewCell
        var alreadyFriends: String = ""
        if tableView == self.searchDisplayController!.searchResultsTableView {
            alreadyFriends = filteredFriends[indexPath.row]
        }
        else if(friends.count==0){
            cell.textLabel?.text = "You currently do not have any friends"
        }
        else{
            alreadyFriends = friends[indexPath.row]
        }
        if(friends.count==0){
            cell.textLabel?.text = "You currently do not have any friends"
        }
        else{
            cell.textLabel?.text = alreadyFriends
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredFriends.count
        }
        else if(friends.count==0){
            return 1
        }else{
            return friends.count
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var pass:Bool = true
        if(friends.count==0){
            pass = false
        }
        if(pass){
            self.performSegueWithIdentifier("userDetail", sender: tableView)
        }
    }
    
    // Prepared to transfer current User information to FindFriendTableVC
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "searchForFriends"){
            let findFriendTableVC:FindFriendsTableViewController = segue.destinationViewController as! FindFriendsTableViewController
            findFriendTableVC.currentUserObject = PFUser.currentUser()
            findFriendTableVC.currentUser = PFUser.currentUser()!.username!
            findFriendTableVC.friends = self.friends
        }
            if(segue.identifier == "userDetail"){
                let userProfileVC:UserProfileViewController = segue.destinationViewController as! UserProfileViewController
                if sender as! UITableView == self.searchDisplayController!.searchResultsTableView {
                    let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                    let destinationTitle = self.filteredFriends[indexPath.row]
                    userProfileVC.displayUser = destinationTitle
                } else {
                    let indexPath = self.tableView.indexPathForSelectedRow()!
                    let destinationTitle = self.friends[indexPath.row]
                    userProfileVC.displayUser = destinationTitle
                    userProfileVC.currentUser = self.currentUser
                    
                }
            }
        
    }
}
