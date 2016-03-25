//
//  GitHubAPIManager.swift
//  APGistExplorer
//
//  Created by Abrar Peer on 20/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GitHubAPIManager {
	
	static let sharedInstance = GitHubAPIManager()
	
	var alamofireManager:Alamofire.Manager
	
	let clientID: String = "1234567890"
	let clientSecret: String = "abcdefghijkl"
	
	let headers = ["Accept": "application/json"]
	
	init () {
		
		log.debug("Started!")
		
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		alamofireManager = Alamofire.Manager(configuration: configuration)
		
		log.debug("Finished!")
		
	}
	
	func imageFromURLString(imageURLString: String, completionHandler: (UIImage?, NSError?) -> Void ) {
		
		log.debug("Started!")
		
		alamofireManager.request(.GET, imageURLString).response {
			
			(request, response, data, error) in
				
				if data == nil {
					
					completionHandler(nil, nil)
					log.debug("Finished!")
					return
				}
				
				let image = UIImage(data: data! as NSData)
				
				completionHandler(image, nil)
			
			
		}
		
		log.debug("Finished!")

	}
	
	
	func printPublicGists() {
		
		log.debug("Started!")
		
		Alamofire.request(GistRouter.GetPublic()) .responseString {
			
			response in
			
			if let receivedString = response.result.value {
				
				print(receivedString)
				
			}
		}
		
		log.debug("Finished!")
		
	}
	
	func getPublicGists(completionHandler: (Result<[Gist], NSError>) -> Void){
		
		log.debug("Started!")
		
		Alamofire.request(GistRouter.GetPublic())
			
			.responseArray { (response: Response<[Gist], NSError>) -> Void in
			
			completionHandler(response.result)
			
		}
		
		
		log.debug("Finished!")
		
	}
	
}
