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
    
    var context:CIContext = CIContext(options: nil)
    
    var filters:[CIFilter] = []

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
        
        filters = photoFilters()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UICollectionviewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:FilterCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as! FilterCell
        
//        cell.imageView.image = UIImage(named: "Placeholder")
        
        cell.imageView.image = filteredImageFromImage(thisFeedItem.image, filter: filters[indexPath.row])
        
        return cell
    }
    
    //Helper Function
    
    func photoFilters() -> [CIFilter] {
        
        let blur = CIFilter(name: "CIGaussianBlur")
        
        let instant = CIFilter(name: "CIPhotoEffectInstant")
        
        let noir = CIFilter(name: "CIPhotoEffectNoir")
        
        let transfer = CIFilter(name: "CIPhotoEffectTransfer")
            
        let unsharpen = CIFilter(name: "CIPhotoUnsharpMask")
        
        let monochrome = CIFilter(name: "CIColorMonochrome")
        
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
        
        //podemos incluso combinar tres veces:
        let vignette = CIFilter(name: "CIVignette")
        vignette.setValue(composite.outputImage, forKey: kCIInputImageKey)
        vignette.setValue(kIntensity * 2, forKey: kCIInputIntensityKey)
        vignette.setValue(kIntensity * 30, forKey: kCIInputRadiusKey)
        
        return [blur, instant, noir, transfer, unsharpen, monochrome, colorContorls, sepia, colorClamp, composite, vignette]
    }
    
    func filteredImageFromImage (imageData: NSData, filter: CIFilter) -> UIImage {
        // vamos a crear una instancia bastante "cara", así que será una constante. Se encarga de hacer el proceso del filtro en una imagen. Se trata de una CIContextInstance (la vamos a crear como Property dentro de FilterViewController. La segunda va a ser una CIImage, que va a tener todos los datos de imagen, y luego la convertiremos en UIImage
        
    
        
        //lo primero que haremos será convertir nuestros datos en CIImage:
        let unfilteredImage = CIImage(data: imageData) //el imageData viene de nuestro FeedItem
        filter.setValue(unfilteredImage, forKey: kCIInputImageKey) //le pasamos un filtro
        let filteredImage: CIImage = filter.outputImage
        
        let extent = filteredImage.extent() //extent() nos da un rectangulo del tamaño de la filteredImage
        let cgImage:CGImageRef = context.createCGImage(filteredImage, fromRect: extent) //genera una imagen optimizada del tamaño de extent basandose en la imagen filtrada
        let finalImage = UIImage(CGImage: cgImage) //la convierte en UIImage
        
        return finalImage!
    }
    
    
    
    
    
    

}
