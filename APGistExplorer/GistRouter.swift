//
//  GistRouter.swift
//  APGistExplorer
//
//  Created by Abrar Peer on 20/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import Foundation
import Alamofire

enum GistRouter : URLRequestConvertible {
	
	static let baseURLString = "https://api.github.com"
	
	case GetPublic() // GET https://api.github.com/gists/public
	
	var URLRequest: NSMutableURLRequest {
		
		var method: Alamofire.Method {
			
			switch self {
				
			case .GetPublic:
				
				return .GET
				
			}
			
		}
		
		let result : (path: String, parameters: [String : AnyObject]?) = {
			
			switch self {
				
			case .GetPublic:
				
				return ("/gists/public", nil)
				
			}
			
		}()
		
		let URL = NSURL(string: GistRouter.baseURLString)!
		
		let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
		URLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
		
		
		let encoding = Alamofire.ParameterEncoding.JSON
		
		let (encodedRequest, _) = encoding.encode(URLRequest, parameters: result.parameters)
		
		encodedRequest.HTTPMethod = method.rawValue
		
		return encodedRequest
		
	}
	
}



