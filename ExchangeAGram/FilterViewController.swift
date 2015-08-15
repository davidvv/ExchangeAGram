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
    
    let kIntensity = 0.7 //El valor sepia

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
        //le decimos al FilterViewController que tiene que utilizar la celda que hemos creado:
        collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "MyCell")
        
        
        
        
        self.view.addSubview(collectionView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UICollectionviewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:FilterCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as! FilterCell
        
        cell.imageView.image = UIImage(named: "Placeholder")
        
        return cell
    }
    
    //Helper Function
    
    func photoFilters() -> [CIFilter] {
        
        let blur = CIFilter(name: "CIGaussianBlur")
        
        let instant = CIFilter(name: "CIPhotoEffectInstant")
        
        let noir = CIFilter(name: "CIPhotoEffectNoir")
        
        let transfer CIFilter(name: "CIPhotoEffectTransfer")
            
        let unsharpen = CIFilter(name: "CIPhotoUnsharpMask")
        
        let monocrome = CIFilter(name: "CIColorMonochrome")
        
        let colorContorls = CIFilter(name: "CIColorcontrols")
        colorContorls.setValue(0.5, forKey: kCIInputSaturationKey) //cambia la saturación a 0.5. El valor puede cambiar entre 0 y 1
        
        let sepia = CIFilter(name: "CISepiaTone")
        sepia.setValue(kIntensity, forKey: kCIInputIntensityKey)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "InputMaxComponents")
        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
        //he actuado sobre los máximos y minimos valores posibles del RGB
        
        //Hacemos un filtro compuesto:
        let composite = CIFilter(name: "CIHardLightBlendMode")
        composite.setValue(sepia.outputImage, forKey: kCIInputImageKey) //lo que hago es aplicar el filtro sepia que he creado, y a la imagen que sale, le aplico el CIHardLightBlendMode
        
        

        
        return []
    }
    
    
    
    
    
    
    

}
