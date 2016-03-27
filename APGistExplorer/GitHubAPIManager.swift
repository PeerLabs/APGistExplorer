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
	
	//MARK: Public Methods
	
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
	
	func getPublicGists(pageToLoad: String?, completionHandler: (Result<[Gist], NSError>, String?) -> Void) {
		
		log.debug("Started!")
		
		if let urlString = pageToLoad {
			
			getGists(GistRouter.GetAtPath(urlString), completionHandler: completionHandler)
			
		} else {
			
			getGists(GistRouter.GetPublic(), completionHandler: completionHandler)
			
		}
		
		log.debug("Finished!")
		
	}
	

//	func getPublicGists(completionHandler: (Result<[Gist], NSError>, String?) -> Void){
//		
//		log.debug("Started!")
//		
//		alamofireManager.request(GistRouter.GetPublic()).validate().responseArray { (response: Response<[Gist], NSError>) -> Void in
//				
//			guard response.result.error == nil,
//				
//				let gists = response.result.value else {
//					
//					print (response.result.error)
//					
//					completionHandler(response.result, nil)
//					
//					return
//					
//				}
//			
//			let next = self.getNextPageFromHeaders(response.response)
//			
//			completionHandler(.Success(gists), next)
//
//		}
//
//		log.debug("Finished!")
//		
//	}
	
	func getGists(urlRequest: URLRequestConvertible, completionHandler: (Result<[Gist], NSError>, String?) -> Void) {
		
		log.debug("Started!")
		
		alamofireManager.request(urlRequest).validate().responseArray { ( response: Response<[Gist], NSError>) in
			
			guard response.result.error == nil,	let gists = response.result.value else {
					
				print (response.result.error)
				
				completionHandler(response.result, nil)
				
				return
					
			}
			
			let next = self.getNextPageFromHeaders(response.response)
			
			completionHandler(.Success(gists), next)
			
		}
		
		log.debug("Finished!")

		
	}
	
	//MARK: Private Methods
	
	private func getNextPageFromHeaders(response: NSHTTPURLResponse?) -> String?	{
		
		log.debug("Started!")
		
		// First we get the headers from the response to our request
		
		if let linkHeader = response?.allHeaderFields["Link"] as? String {
			
			/* looks like:
			<https://api.github.com/user/20267/gists?page=2>; rel="next", <https://api.github.com/\
			user/20267/gists?page=6>; rel="last"
			*/
			
			// so split on "," then on ";"
			let components = linkHeader.characters.split {$0 == ","}.map {String($0)}
			
			log.debug("\(components)")
			
			for item in components {
				
				let rangeOfNext = item.rangeOfString("rel=\"next\"", options: [])
				
				log.debug("\(rangeOfNext)")
				
				if rangeOfNext != nil {
					
					let rangeOfPaddedURL = item.rangeOfString("<(.*)>;", options: .RegularExpressionSearch)
					
					if let range = rangeOfPaddedURL {
						
						let nextURL = item.substringWithRange(range)
						
						let startIndex = nextURL.startIndex.advancedBy(1)
						
						let endIndex = nextURL.endIndex.advancedBy(-2)
						
						let urlRange = startIndex..<endIndex
						
						log.debug("Returning Next Page From Header Response: " + nextURL.substringWithRange(urlRange))
						
						return nextURL.substringWithRange(urlRange)

					}
					
					
				}
				
			}

		}
		
		log.debug("Finished!")
		
		return nil
		
	}
	
}
