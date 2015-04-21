//
//  RequestItemViewController.swift
//  ShoppingWithFriends
//
//  Created by Sylvia Chan on 4/20/15.
//  Copyright (c) 2015 Venkatramanan, Goutam. All rights reserved.
//

import UIKit

class RequestItemViewController: UIViewController {
    
//    @IBOutlet weak var ffwf: UILabel!
//    @IBOutlet weak var aa: UILabel!
    var currentUser: String = ""
    var result:PFObject!
    var itemNames:Array<String> = []
    var itemPrices:Array<Double> = []
    var itemLocations:Array<String> = []
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var priceInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFQuery(className:"newItem")
        query.whereKey("username", equalTo:currentUser)
        result = query.getFirstObject()
        itemNames = result["itemNames"] as Array<String>
        itemPrices = result["itemPrices"] as Array<Double>
        itemLocations = result["itemLocations"] as Array<String>    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Saved the input item into the database */
    
    @IBAction func itemRequestSubmit(sender: AnyObject) {
        itemNames.insert(nameInput.text, atIndex: 0)
        let price = priceInput.text
        let priceDouble:Double = (price as NSString).doubleValue
        itemPrices.insert(priceDouble, atIndex: 0)
        itemLocations.insert(locationInput.text, atIndex: 0)
        result["itemNames"] = itemNames
        result["itemPrices"] = itemPrices
        result["itemLocations"] = itemLocations
        result.save()
        
        var back:Bool = displayAlert()
    }
    
    /* Display an alert to notify user item has been added successfull, then go back to previous VC */
    
    func displayAlert() -> Bool{
        let title = ""
        let message = "Your request has been created successfully"
        let ok = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: ok, style: UIAlertActionStyle.Cancel, handler: { action in
            self.navigationController?.popViewControllerAnimated(true)
            return
        })
        alert.addAction(okButton)
        
        presentViewController(alert, animated: true, completion: nil)
        
        return true
    }
    
    
}
