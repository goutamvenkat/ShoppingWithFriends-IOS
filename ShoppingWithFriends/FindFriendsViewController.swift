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
    
    func filterContentForSearchText(searchText:String){
        self.filteredNotFriends = self.notFriends.filter({(notFriendUser: String)-> Bool in
            let stringMatch = notFriendUser.rangeOfString(searchText)
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("searchFriendCell", forIndexPath: indexPath) as UITableViewCell
        var notYetFriends: String
        if tableView == self.searchDisplayController!.searchResultsTableView {
            notYetFriends = filteredNotFriends[indexPath.row]
            cell.textLabel?.text = notYetFriends
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        if(self.notFriends.count==0){
            cell.textLabel?.text = "You currently do not have any friends"
        }
        else{
            notYetFriends = self.notFriends[indexPath.row]
            cell.textLabel?.text = notYetFriends
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredNotFriends.count
        }
        if(self.notFriends.count==0){
            return 1
        }
        return notFriends.count
    }
    
}
