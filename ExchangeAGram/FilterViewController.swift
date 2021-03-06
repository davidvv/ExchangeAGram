
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
    
    let placeHolderImage = UIImage(named: "Placeholder")
    
    let tmp = NSTemporaryDirectory()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //la collectionView anterior, la hicimos desde el Storyboard, ahora vamos a generar una enteramente con código.
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
        
        
        cell.imageView.image = placeHolderImage
        
        //creamos una cola
        let filterQueue:dispatch_queue_t = dispatch_queue_create("filter queue", nil)
        //para decirle a la cola qué código corre en ella:
        dispatch_async(filterQueue, { () -> Void in
            //cogemos la imagen de la cache:
            let filterImage = self.getCachedImage(indexPath.row)
            
            //mandamos a la linea principal la actualización de la interfaz, haciendo que se presente la imagen en la celda
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.imageView.image = filterImage
            })
        })
        
        
        return cell
    }
    
    
    //UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let filterImage = self.filteredImageFromImage(self.thisFeedItem.image, filter: self.filters[indexPath.row]) //aplicamos el filtro, sobre la imagen, la de verdad, no el thumbnail, porque queremos guardarla con buena calidad!
        
        //ahora necesitamos crear imageData:
        let imageData = UIImageJPEGRepresentation(filterImage, 1.0)
        
        //y lo guardamos en nuestro "thisFeedItem
        self.thisFeedItem.image = imageData
        
        //y tb creamos nuestro thumbNailData:
        let thumbNailData = UIImageJPEGRepresentation(filterImage, 0.1)
        
        //y lo aplicamos a thisFeedItem:
        self.thisFeedItem.thumbNail = thumbNailData
        
        //Guardamos en CoreData:
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        //activamos la animación al mostrar el ViewController:
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func justHideComments() {
        //creo una función solo para poder ocultar un montón de código que está comentado y no quiero ver
        
        
        
        
        
        
    //Helper Function
    
//    func photoFilters() -> [CIFilter] {
//        
//        let blur = CIFilter(name: "CIGaussianBlur")
//        
//        let instant = CIFilter(name: "CIPhotoEffectInstant")
//        
//        let noir = CIFilter(name: "CIPhotoEffectNoir")
//        
//        let transfer = CIFilter(name: "CIPhotoEffectTransfer")
//            
//        let unsharpen = CIFilter(name: "CIPhotoUnsharpMask")
//        
//        let monochrome = CIFilter(name: "CIColorMonochrome")
//        
////        let colorContorls = CIFilter(name: "CIColorcontrols")
////        colorContorls.setValue(0.5, forKey: kCIInputSaturationKey) //cambia la saturación a 0.5. El valor puede cambiar entre 0 y 1
//        
//        let sepia = CIFilter(name: "CISepiaTone")
//        sepia.setValue(kIntensity, forKey: kCIInputIntensityKey)
//        
//        let colorClamp = CIFilter(name: "CIColorClamp")
//        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "InputMaxComponents")
//        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
//        //he actuado sobre los máximos y minimos valores posibles del RGB
//        
//        //Hacemos un filtro compuesto:
//        let composite = CIFilter(name: "CIHardLightBlendMode")
//        composite.setValue(sepia.outputImage, forKey: kCIInputImageKey) //lo que hago es aplicar el filtro sepia que he creado, y a la imagen que sale, le aplico el CIHardLightBlendMode
//        
//        //podemos incluso combinar tres veces:
//        let vignette = CIFilter(name: "CIVignette")
//        vignette.setValue(composite.outputImage, forKey: kCIInputImageKey)
//        vignette.setValue(kIntensity * 2, forKey: kCIInputIntensityKey)
//        vignette.setValue(kIntensity * 30, forKey: kCIInputRadiusKey)
//        
//        return [blur, instant, noir, transfer, unsharpen, monochrome, /*colorContorls,*/ sepia, colorClamp, composite, vignette]
//    }
    }
    
    //he comentado mi código porque mis comentarios están ahí y pueden ser interesantes. He debido escribir el nombre de algun filtro mal, por lo que me da error. Copio y pego el código de Eliot:
    
    func photoFilters () -> [CIFilter] {
        
        let blur = CIFilter(name: "CIGaussianBlur")
        
        let instant = CIFilter(name: "CIPhotoEffectInstant")
        
        let noir = CIFilter(name: "CIPhotoEffectNoir")
        
        let transfer = CIFilter(name: "CIPhotoEffectTransfer")
        
        let unsharpen = CIFilter(name: "CIUnsharpMask")
        
        let monochrome = CIFilter(name: "CIColorMonochrome")
        
        let colorControls = CIFilter(name: "CIColorControls")
        
        colorControls.setValue(0.5, forKey: kCIInputSaturationKey)
        
        let sepia = CIFilter(name: "CISepiaTone")
        
        sepia.setValue(kIntensity, forKey: kCIInputIntensityKey)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        
        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
        
        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
        
        let composite = CIFilter(name: "CIHardLightBlendMode")
        
        composite.setValue(sepia.outputImage, forKey: kCIInputImageKey)
        
        let vignette = CIFilter(name: "CIVignette")
        
        vignette.setValue(composite.outputImage, forKey: kCIInputImageKey)
        
        vignette.setValue(kIntensity * 2, forKey: kCIInputIntensityKey)
        
        vignette.setValue(kIntensity * 30, forKey: kCIInputRadiusKey)
        
        return [blur, instant, noir, transfer, unsharpen, monochrome, colorControls, sepia, colorClamp, composite, vignette]
        
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
    
    // caching functions
    
    func cacheImage(imageNumber: Int) {
        //imageNumber es el imagePath.row específico de cada imagen)
        let fileName = "\(imageNumber)"
        let uniquePath = tmp.stringByAppendingPathComponent(fileName)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(fileName) { // ! significa "not", se llama "bang". Comprobamos si existe el archivo con ese nombre, en caso de que no, que es lo que estamos mirando, lo creamos:
            
            let data = self.thisFeedItem.thumbNail
            let filter = self.filters[imageNumber]
            let image = filteredImageFromImage(data, filter: filter)
            UIImageJPEGRepresentation(image, 1.0).writeToFile(uniquePath, atomically: true)
        }
    }
    
    func getCachedImage (imageNumber: Int) -> UIImage {
        let fileName = "\(imageNumber)"
        let uniquePath = tmp.stringByAppendingPathComponent(fileName)
        
        var image:UIImage
        if NSFileManager.defaultManager().fileExistsAtPath(uniquePath) {
            image = UIImage(contentsOfFile: uniquePath)! //si existe la caché, genera una imagen a partir de ella
        } else {
            self.cacheImage(imageNumber)
            image = UIImage(contentsOfFile: uniquePath)! //si no existe la caché, genera una caché, y genera la imagen a partir de ella con la función que hemos creado justo antes
        }
        
        return image
    }
    

}
