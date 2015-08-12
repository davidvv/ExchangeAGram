//
//  FilterViewController.swift
//  ExchangeAGram
//
//  Created by David Vences Vaquero on 12/8/15.
//  Copyright (c) 2015 David. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var thisFeedItem: FeedItem!
    
    //vamos a configurar una UICollectionView en código, sin usar el Storyboard (donde se mostrarán todos los filtros)
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout() //se encarga de decir como se va a ordenar la UICollectionView
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //esto le da bordes a las celdas
        layout.itemSize = CGSize(width: 150.0, height: 150.0) //tamaño de cada celda
        
        //y por ultimo creamos una instancia de UICollectionView (la habíamos declarado como opcional Unwrapped pero no la habíamos instancializado realmente):
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout) //self.view.frame es el tamaño completo de la vista actual
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

}
