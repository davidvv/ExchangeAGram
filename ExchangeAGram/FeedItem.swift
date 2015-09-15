//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by David Vences Vaquero on 28/8/15.
//  Copyright (c) 2015 David. All rights reserved.
//

import Foundation
import CoreData

class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData
    @NSManaged var thumbNail: NSData

}
