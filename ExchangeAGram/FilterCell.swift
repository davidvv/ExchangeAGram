//
//  FilterCell.swift
//  ExchangeAGram
//
//  Created by David Vences Vaquero on 12/8/15.
//  Copyright (c) 2015 David. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    //necesitamos un custom initializer para que se cree nuestra celda con una imagen. Como no tenemos un storyboard con una collectionview y una prototypecell, necesitamos meterlo en código:
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView=UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)) // la imagen ocupa al completo el ancho y el alto de nuestra filter cell
        contentView.addSubview(imageView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
