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
    var currentUser: String = ""
    var notFriends: Array<String> = []
    var filteredNotFriends = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var count:Int = 0
        var query = PFQuery(className:"Friends")
        //query.whereKey("username", equalTo:"sylvia")
        var notFriendsPFObject = query.findObjects() as [PFObject]
        for user in notFriendsPFObject { // message is of PFObject type
            var notFriendName:String = user["username"] as String
            if notFriendName != currentUser {
                notFriends.insert(notFriendName, atIndex: count++)
                println(notFriendName)
            }
        }
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
        var notYetFriends: String
        if tableView == self.searchDisplayController!.searchResultsTableView {
            notYetFriends = filteredNotFriends[indexPath.row]
        }
        else{
            notYetFriends = self.notFriends[indexPath.row]
        }
        if(self.notFriends.count==0){
            cell.textLabel?.text = "You currently do not have any friends"
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
    
}
