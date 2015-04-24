import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITableViewDataSource{
    @IBOutlet weak var continerView: UIView!
    
    var result:PFObject!
    var friends:Array<String> = []
    var itemNames:Array<String> = []
    var itemPrices:Array<Double> = []
    var itemLocations:Array<String> = []
    
    @IBOutlet var tableView: UITableView!
    
    var itemNamesTotal:Array<String> = []
    var itemPricesTotal:Array<Double> = []
    var itemLocationsTotal:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loginSetup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var query = PFQuery(className:"Friends")
        var queryForUserItems = PFQuery(className: "newItem")
        if (PFUser.currentUser() != nil) {
            query.whereKey("username", equalTo:PFUser.currentUser()!.username!)
            queryForUserItems.whereKey("username", equalTo:PFUser.currentUser()!.username!)
            result = query.getFirstObject()
            var userItemPF: PFObject! = queryForUserItems.getFirstObject()
            friends = result["Friends"] as! Array<String>
            for user in friends{
                var friendQuery = PFQuery(className:"newReport")
                friendQuery.whereKey("username", equalTo:user)
                result = friendQuery.getFirstObject()
                itemNames = result["itemNames"] as! Array<String>
                itemPrices = result["itemPrices"] as! Array<Double>
                itemLocations = result["itemLocations"] as! Array<String>
                var userItemNames: Array<String> = userItemPF["itemNames"] as! Array<String>
                var userItemPrices: Array<Double> = userItemPF["itemPrices"] as! Array<Double>
                var count = 0
                if(itemNames.count>0){
                    for name in itemNames {
                        if foundNameAndPrice(name, count: count, userItemNames: userItemNames, userItemPrices: userItemPrices) {
                            itemNamesTotal.insert(itemNames[count], atIndex: 0)
                            itemPricesTotal.insert(itemPrices[count], atIndex: 0)
                            itemLocationsTotal.insert(itemLocations[count], atIndex: 0)

                        }
                        count++
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func foundNameAndPrice(name: String, count: Int, userItemNames: Array<String>, userItemPrices: Array<Double>) -> Bool {
        var reportedPrice: Double = itemPricesTotal[count]
        var index: Int = 0
        for n in userItemNames {
            if name == n && userItemPrices[index] > reportedPrice {
                return true
            }
            index++
        }
        return false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemNamesTotal.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("mainCell", forIndexPath: indexPath) as! UITableViewCell
        var items: String = ""
        if(self.itemNamesTotal.count==0){
            cell.textLabel?.text = "Your friends have not found any items"
        }
        else{
            var priceString:String = String(format:"%.1f", self.itemPricesTotal[indexPath.row])
            items = "Name: " + self.itemNamesTotal[indexPath.row] + "   Max $: " + priceString
            cell.textLabel?.text = items
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
//        if(self.itemNamesTotal.count==0){
//            cell.textLabel?.text = "Your friends have not found any items"
//        }
//        else{
//            cell.textLabel?.text = items
//            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        }
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
                addUserToTables(PFUser.currentUser()!)
            }
        }
//        else if (PFFacebookUtils.isLinkedWithUser(user)) {
//            var permissions = ["public_profile", "email", "user_friends"]
//            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user: PFUser?, error: NSError?) -> Void in
//                if let user = user {
//                    if user.isNew {
//                        self.addUserToTables(user)
//                        println("User signed up and logged in through Facebook!")
//                    } else {
//                        println("User logged in through Facebook!")
//                    }
//                } else {
//                    println("Uh oh. The user cancelled the Facebook login.")
//                }
//            })
//        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        println("Failed to login...")
    }
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        if (PFTwitterUtils.isLinkedWithUser(user)) {
            
            var twitterUsername = PFTwitterUtils.twitter()!.screenName!
            
            PFUser.currentUser()!.username = twitterUsername
            
            PFUser.currentUser()!.saveEventually(nil)
            
        }
//        else if (PFFacebookUtils.isLinkedWithUser(user)) {
//            var permissions = ["public_profile", "email", "user_friends"]
//            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user: PFUser?, error: NSError?) -> Void in
//                if let user = user {
//                    if user.isNew {
//                        self.addUserToTables(user)
//                        println("User signed up and logged in through Facebook!")
//                    } else {
//                        println("User logged in through Facebook!")
//                    }
//                } else {
//                    println("Uh oh. The user cancelled the Facebook login.")
//                }
//            })
//        }
        self.dismissViewControllerAnimated(true, completion: nil)
        if (!alreadyAUser(user)) {
            addUserToTables(PFUser.currentUser()!)
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
        query.whereKey("username", equalTo:user.username!)
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
        
//        var itemTable = PFObject(className: "Items")
//        itemTable["MyItems"] = [String: Double]()
//        itemTable["MyReports"] = []
//        itemTable["username"] = user.username
        friendsTable.save()
//        itemTable.save()
        
        var newItemTable = PFObject(className: "newItem")
        newItemTable["itemPrices"] = []
        newItemTable["username"] = user.username
        newItemTable["itemNames"] = []
        newItemTable.save()
        
        var newReportTable = PFObject(className: "newReport")
        newReportTable["itemPrices"] = []
        newReportTable["username"] = user.username
        newReportTable["itemLocations"] = []
        newReportTable["itemNames"] = []
        newReportTable.save()
    }
    
    // Prepared to transfer User information to FriendListTableVC
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if(segue.identifier == "viewFriends"){
//            let friendListTableVC:FriendListTableViewController = segue.destinationViewController as! FriendListTableViewController
////            friendListTableVC.currentUser = PFUser.currentUser()!.username!
//            println(PFUser.currentUser()!.username!)
//            println("go to friend success")
//        }
//        if(segue.identifier == "requestItem"){
//            let requestItemVC:RequestItemViewController = segue.destinationViewController as! RequestItemViewController
//            requestItemVC.currentUser = PFUser.currentUser()!.username!
//            println("go to request item VC")
//        }
//    }
    

    @IBAction func addAction(sender: AnyObject) {
        var alert = UIAlertController(title: "Item or Report?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Item", style: UIAlertActionStyle.Default, handler: { action in self.performSegueWithIdentifier("requestItem", sender: self) }))
        alert.addAction(UIAlertAction(title: "Report", style: UIAlertActionStyle.Default, handler: {action in self.performSegueWithIdentifier("reportItem", sender: self)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
