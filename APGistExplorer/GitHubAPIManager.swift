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

class GitHubManager {
	
	//    static let sharedInstance = GitHubAPIManager()
	
	class var sharedInstance: GitHubManager {
		
		log.debug("Started!")
		
		struct Singleton {
			
			static let instance = GitHubManager()
			
		}
		
		log.debug("Finished!")
		
		return Singleton.instance
		
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
