//
//  MasterViewController.swift
//  APGistExplorer
//
//  Created by Abrar Peer on 20/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import UIKit


class MasterViewController: UITableViewController {
	
	var detailViewController: DetailViewController? = nil
	
	var imageCache = [String: UIImage?]()
	
	var gists = [Gist]() {
		
		didSet {
			
			self.tableView.reloadData()
			
		}
		
	}
	
//	let GitHubAPIManager = GitHubAPIManager.sharedInstance
	
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
		
		loadGists()
		
		log.debug("Finished!")
		
	}
	
	override func viewWillAppear(animated: Bool) {
		
		log.debug("Started!")
		
		self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
		super.viewWillAppear(animated)
		
		log.debug("Finished!")
		
	}
	
	override func viewDidAppear(animated: Bool) {
		
		log.debug("Started!")
		
		super.viewDidAppear(animated)
		
		loadGists()
		
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
								
		if let urlString = gist.ownerAvatarURL {
			
			if let cachedImage = imageCache[urlString] {
				
				cell.imageView?.image = cachedImage
				
			} else {
				
				GitHubAPIManager.sharedInstance.imageFromURLString(urlString, completionHandler: { (image, error) in
					
					
					if let returnedError = error {
						
						log.debug(returnedError.description)
						
					}
					
					if let cellToUpdate = self.tableView?.cellForRowAtIndexPath(indexPath) {
						
						cellToUpdate.imageView?.image = image
						
						cellToUpdate.setNeedsLayout()
						
					}
					
				})

			}

			
		} else {
			
			cell.imageView?.image = nil
			
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

	func loadGists() {
											
		log.debug("Started!")
		
//		GitHubAPIManager.printPublicGists()
		
//		let gist1 = Gist()
//		gist1.description = "The first gist"
//		gist1.ownerLogin = "gist1Owner"
//		let gist2 = Gist()
//		gist2.description = "The second gist"
//		gist2.ownerLogin = "gist2Owner"
//		let gist3 = Gist()
//		gist3.description = "The third gist"
//		gist3.ownerLogin = "gist3Owner"
//		gists = [gist1, gist2, gist3]
//		// Tell the table view to reload
//		self.tableView.reloadData()
				
				
		GitHubAPIManager.sharedInstance.getPublicGists() { result in
			
			guard result.error == nil else {
			
				print(result.error)
			
				// TODO: display error
			
				return
			
			}
			
			if let fetchedGists = result.value {
	
				self.gists = fetchedGists
	
			}
			
		}
		
		log.debug("Finished!")
			
	}
	
}

