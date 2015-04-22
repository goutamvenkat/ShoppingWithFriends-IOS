//
//  UserProfileViewController.swift
//  ShoppingWithFriends
//
//  Created by Sylvia Chan on 4/19/15.
//  Copyright (c) 2015 Venkatramanan, Goutam. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var friendButton: UIButton!
    var alreadyFriendBool:Bool = false;
    var currentUser:String = ""
    var displayUser:String = ""
    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        username.text="Username: "+displayUser
        var alreadyFriends:Bool
        alreadyFriends = alreadyFriend(currentUser, friendName: displayUser)
        if(alreadyFriends){
            friendButton.setTitle("Delete Friend", forState: .Normal)
        }
        else{
            friendButton.setTitle("Add as Friend", forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Given the currentUser as username, and the displayUser as friendName, the function
    will return true if display user is already friend with current user.  False otherwise */
    func alreadyFriend(username:String, friendName:String)->Bool{
        var queryToGetUserItems = PFQuery(className: "Friends")
        queryToGetUserItems.whereKey("username", equalTo: username)
        var userInItemTable: PFObject = queryToGetUserItems.getFirstObject()!
        var friendList:Array<String> = userInItemTable["Friends"] as! Array<String>
        for item in friendList{
            if(item==friendName){
                alreadyFriendBool = true
                return true
            }
        }
        alreadyFriendBool = false
        return false
    }
    
    /* When clicked, display user will either be add or deleted as a friend base on it's current friend status with the current user */
    
    @IBAction func friendButtonClick(sender: AnyObject) {
        var queryToGetUserItems = PFQuery(className: "Friends")
        queryToGetUserItems.whereKey("username", equalTo: currentUser)
        var userInItemTable:PFObject = queryToGetUserItems.getFirstObject()!
        var friendList:Array<String> = userInItemTable["Friends"] as! Array<String>
        println("i reach here 1")
        if(alreadyFriendBool){
            println("i reach here 2")
            var count=0
            var toRemove=0
            for item in friendList{
                if(item==displayUser){
                    toRemove=count
                    friendList.removeAtIndex(count)
                }
                count++;
            }
            friendButton.setTitle("Add as Friend", forState: .Normal)
            alreadyFriendBool = false
        }
        else{
            friendList.insert(displayUser, atIndex: 0)
            friendButton.setTitle("Delete Friend", forState: .Normal)
            alreadyFriendBool = true
        }
        userInItemTable["Friends"]=friendList
        userInItemTable.save()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
