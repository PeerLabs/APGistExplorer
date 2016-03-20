//
//  ResponseJSONObjectSerializable.swift
//  APGistExplorer
//
//  Created by Abrar Peer on 21/03/2016.
//  Copyright © 2016 peerlabs. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol ResponseJSONObjectSerializable {
	
	init?(json: SwiftyJSON.JSON)
	
}
