//
//  HomeViewController.swift
//  ParseInstagramCP
//
//  Created by Eric Suarez on 3/12/17.
//  Copyright © 2017 Eric Suarez. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var captions = [String]()
    var users = [String]()
    var imageFiles = [PFFile]()
    
    var posts = [PFObject]()
    
    func displayAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        })))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        var query = PFQuery(className: "Post")
        query.limit = 20
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if(posts != nil)
            {
                self.posts = posts!
                
                self.tableView.reloadData()
            }
            else
            {
                self.displayAlert("Error Loading Posts", message: (error?.localizedDescription)!)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.count != 0 {
            return posts.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "InstaCell", for: indexPath) as! InstaCell
        
        var instaImage = posts[indexPath.row]["imageFile"] as! PFFile
        
        instaImage.getDataInBackground{ (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                myCell.postedImage.image = downloadedImage
                
            }
            
        }
        
        var userId = posts[indexPath.row]["userId"] as! String
        
        var userQuery = PFUser.query()
        
        var user: PFUser?
        
        do {
            user = try userQuery?.getObjectWithId(userId) as! PFUser?
            
            myCell.usernameLabel.text = user?.username
        } catch {
            print(error)
        }
        
        
        
        myCell.captionLabel.text = posts[indexPath.row]["caption"] as! String?
        
        return myCell
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        PFUser.logOutInBackground { (error: Error?) in
            // PFUser.currentUser() will now be nil
            
            var currentUser = PFUser.current()
            print(currentUser)
            
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
        }
        
    }
    
    func onRefresh() {
        var query = PFQuery(className: "Post")
        query.limit = 20
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if(posts != nil)
            {
                self.posts = posts!
                
                self.tableView.reloadData()
            }
            else
            {
                self.displayAlert("Error Loading Posts", message: (error?.localizedDescription)!)
            }
            
        }

        self.refreshControl?.endRefreshing()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
