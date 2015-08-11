//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by David Vences Vaquero on 27/7/15.
//  Copyright (c) 2015 David. All rights reserved.
//

import Foundation
import CoreData

@objc (FeedItem) //esto lo he añadido a mano para que la FeedItem class pueda interactuar con objC

class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData

}