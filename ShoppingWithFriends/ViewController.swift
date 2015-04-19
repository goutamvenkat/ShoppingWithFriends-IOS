import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loginSetup()

        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var username = PFUser.currentUser().username
        var queryToGetUserItems = PFQuery(className: "Items")
        queryToGetUserItems.whereKey("username", equalTo: username)
        var userInItemTable = queryToGetUserItems.getFirstObject()
        
//        var userItems = userInItemTable["MyItems"] as NSDictionary
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        return cell
    }
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLoginWithUsername username: String!, password: String!) -> Bool {
        return (!username.isEmpty || !password.isEmpty)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        if (PFTwitterUtils.isLinkedWithUser(user)) {
            
            var twitterUsername = PFTwitterUtils.twitter()!.screenName
            
            PFUser.currentUser()!.username = twitterUsername
            
            PFUser.currentUser()!.saveEventually(nil)
            
            if (!alreadyAUser(user)) {
                addUserToTables(PFUser.currentUser())
            }
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        println("Failed to login...")
    }
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        if (PFTwitterUtils.isLinkedWithUser(user)) {
            
            var twitterUsername = PFTwitterUtils.twitter().screenName
            
            PFUser.currentUser()!.username = twitterUsername
            
            PFUser.currentUser()!.saveEventually(nil)
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        println(PFUser.currentUser().username)
        if (!alreadyAUser(user)) {
            addUserToTables(PFUser.currentUser())
        }
    }
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        println("Failed to sign up...")
    }
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        println("User cancelled login")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        PFUser.logOut()
        loginSetup()
    }
    
    func alreadyAUser(user : PFUser) -> Bool{
        var query = PFQuery(className:"Friends")
        query.whereKey("username", equalTo:user.username)
        var queried = query.getFirstObject()
        return queried != nil
    }
    
    func addUserToTables(user : PFUser) {
        var friendsTable = PFObject(className: "Friends")
        var allColumns = ["Friends", "FriendsRequested", "FriendsRequestsReceived"]
        for column in allColumns {
            friendsTable[column] = NSArray()
        }
        friendsTable["username"] = user.username
        
        var itemTable = PFObject(className: "Items")
        itemTable["MyItems"] = [String: Double]()
        itemTable["MyReports"] = []
        itemTable["username"] = user.username
        friendsTable.saveEventually({
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                // success in saving
            } else {
                print(error.description)
            }
        })
        itemTable.save()
//        itemTable.saveEventually({
//            (success: Bool, error: NSError!) -> Void in
//            if (success) {
//                // success in saving
//            } else {
//                println(error.description)
//            }
//        })
        
    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "viewFriends"){
//            let friendListTableVC:FriendsTableViewController = segue.destinationViewController as FriendsTableViewController
////            friendListTableVC.currentUser = PFUser.currentUser().username
//            friendListTableVC.currentUser = "hi"
//        }
//    }
//    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewFriends"){
            let friendListTableVC:FriendsTableViewController = segue.destinationViewController as FriendsTableViewController
            //            friendListTableVC.currentUser = PFUser.currentUser().username
            friendListTableVC.currentUser = "hi"
        }
    }

    
    func loginSetup() {
        
        if (PFUser.currentUser() == nil) {
            
            var logInViewController = PFLogInViewController()
            logInViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.Facebook | PFLogInFields.Twitter
            logInViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            
            signUpViewController.delegate = self
            
            logInViewController.signUpController = signUpViewController
            
            self.presentViewController(logInViewController, animated: true, completion: nil)
            
            
        }
        
    }
    
}
