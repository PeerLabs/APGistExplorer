//
//  MasterViewController.swift
//  APGistExplorer
//
//  Created by Abrar Peer on 20/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import UIKit
import PINRemoteImage

class MasterViewController: UITableViewController {
	
	var detailViewController: DetailViewController? = nil
	
	var imageCache = [String: UIImage?]()
	
	var gists = [Gist]() {
		
		didSet {
			
			self.tableView.reloadData()
			
		}
		
	}
	
	var isLoading = false
	
	var nextPageURLString: String?
	
	var dateFormatter = NSDateFormatter()
	
	override func viewDidLoad() {
		
		log.debug("Started!")
		
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.navigationItem.leftBarButtonItem = self.editButtonItem()
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(MasterViewController.insertNewObject(_:)))
		self.navigationItem.rightBarButtonItem = addButton
		if let split = self.splitViewController {
			let controllers = split.viewControllers
			self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		
		self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
		self.dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
		
		loadGists(nil)
		
		log.debug("Finished!")
		
	}
	
	override func viewWillAppear(animated: Bool) {
		
		log.debug("Started!")
		
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
		
		if (self.refreshControl == nil) {
			
			self.refreshControl = UIRefreshControl()
			self.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
			
		}
		
		super.viewWillAppear(animated)
		
		log.debug("Finished!")
		
	}
	
	override func viewDidAppear(animated: Bool) {
		
		log.debug("Started!")
		
		super.viewDidAppear(animated)
		
		loadGists(nil)
		
		log.debug("Finished!")
		
	}
	
	override func didReceiveMemoryWarning() {
			
		log.debug("Started!")
		
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
		
		log.debug("Finished!")
			
	}
	
	func insertNewObject(sender: AnyObject) {
				
		log.debug("Started!")
		
		let alert = UIAlertController(title: "Not Implemented", message:"Can't create new gists yet, will implement later", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
		
		log.debug("Finished!")
				
	}
	
	// MARK: - Segues
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
					
		log.debug("Started!")
		
		if segue.identifier == "showDetail" {

			if let indexPath = self.tableView.indexPathForSelectedRow {
			
				let gist = gists[indexPath.row] as Gist
				let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
				controller.detailItem = gist
				controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
				controller.navigationItem.leftItemsSupplementBackButton = true
			
			}

		}
		
		log.debug("Finished!")
					
	}
	
	// MARK: - Table View
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		
		log.debug("Started!")
		
		log.debug("Finished!")
		
		return 1
		
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
							
		log.debug("Started!")
		
		log.debug("Finished!")
		
		return gists.count
			
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
								
        log.debug("Started!")
								
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
								
        let gist = gists[indexPath.row]
								
        cell.textLabel!.text = gist.description
								
        cell.detailTextLabel!.text = gist.ownerLogin
		
		cell.imageView?.image = nil
		
		if let urlString = gist.ownerAvatarURL, url = NSURL(string: urlString) {
			
			cell.imageView?.pin_setImageFromURL(url, placeholderImage: UIImage(named: "avatarPlaceholder"))
			
		} else {
			
			cell.imageView?.image = UIImage(named: "avatarPlaceholder")
			
		}
		
		// See if we need to load more gists
		
		let rowsToLoadFromBottom = 5;
		
		let rowsLoaded = gists.count
		
		if let nextPage = nextPageURLString {
			
			if (!isLoading && (indexPath.row >= (rowsLoaded - rowsToLoadFromBottom))) {
				
				self.loadGists(nextPage)
			}
		}
		
        log.debug("Finished!")
								
        return cell
								
	}
	
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
									
		// Return false if you do not want the specified item to be editable.
		
		log.debug("Started!")
		
		log.debug("Finished!")
		
		return false
									
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
										
		log.debug("Started!")
		
		if editingStyle == .Delete {
		
			gists.removeAtIndex(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
		
		} else if editingStyle == .Insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		
		}
			
		log.debug("Finished!")
											
	}

	// MARK: - Pull to Refresh
	func refresh(sender:AnyObject) {
		
		log.debug("Started!")
		
		nextPageURLString = nil // so it doesn't try to append the results
		loadGists(nil)
		
		log.debug("Finished!")
		
	}
	
	// MARK: - LoadGists
	
	func loadGists(urlToLoad: String?) {
		
		log.debug("Started!")
		
		self.isLoading = true
		
		GitHubAPIManager.sharedInstance.getPublicGists(urlToLoad) { (result, nextPage) in
			
			self.isLoading = false
			
			self.nextPageURLString = nextPage
			
			// tell refresh control it can stop showing up now
			if self.refreshControl != nil && self.refreshControl!.refreshing {
				
				self.refreshControl?.endRefreshing()
				
			}
			
			guard result.error == nil else {
				
				print(result.error)
				// TODO: display error
				return
				
			}
			
			if let fetchedGists = result.value {
				
				if self.nextPageURLString != nil {
					
					self.gists += fetchedGists
				
				} else {
				
					self.gists = fetchedGists
				
				}
				
			}
			
			// update "last updated" title for refresh control
			let now = NSDate()
			let updateString = "Last Updated at " + self.dateFormatter.stringFromDate(now)
			self.refreshControl?.attributedTitle = NSAttributedString(string: updateString)
			
			self.tableView.reloadData()
			
		}
		
		log.debug("Finished!")
		
	}
	
}

