//
//  EjercicioOrdenarVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 10/7/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

class EjercicioOrdenarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /*
     Por hacer:
 */

    @IBOutlet weak var preguntaTextView: UITextView!
    
    
    var color : UIColor! = UIColor.red
    var counter : Int = 0
    let palabras = Utils.palabrasRandom()
    var etiquetas: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preguntaTextView.text = Utils.preguntaRandom()
        for palabra in palabras{
            etiquetas.append(nuevaLabel(palabra))
        }
    }
    
    var arreglos: [[String]] = [["uno","dos"],["alpha", "beta", "teta"]]

    
    func nuevaLabel(_ titulo: String = "world") -> UILabel{
        let label = UILabel()
        label.text = titulo
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = color
        
        label.adjustsFontForContentSizeCategory = false
        label.adjustsFontSizeToFitWidth = false

        label.sizeToFit()
        label.bounds.size.width += 20
        label.bounds.size.height += 20
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        return label
    }
    // MARK:- CollectionView thingies
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return arreglos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arreglos[section].count
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.section == 1 ){ // de abajo hacia arriba
            arreglos[0].append(arreglos[1].popLast()!)
            collectionView.moveItem(at: IndexPath(item: arreglos[1].count, section: 1), to: IndexPath(item: 0, section: 0))
            
        }
        else {// de arriba hacia abajo
            arreglos[1].append(arreglos[0].popLast()!)
            collectionView.moveItem(at: IndexPath(item: arreglos[0].count, section: 0), to: IndexPath(item: 0, section: 1))

        }
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return nuevaLabel(arreglos[indexPath.section][indexPath.item]).bounds.size//tiquetas[indexPath.row].frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: 200, height: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath)
        let label = nuevaLabel(arreglos[indexPath.section][indexPath.item])//nuevaLabel()//etiquetas[indexPath.row]//nuevaLabel(palabras[indexPath.row])
        celda.contentView.addSubview(label)
        celda.frame.size = label.bounds.size
        return celda
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collection_footer", for: indexPath)
        let header = UIView()
        header.bounds.size.height = 1
        header.bounds.size.width = self.view.frame.size.width - 20
        header.sizeToFit()
        header.backgroundColor = UIColor.darkGray
        supView.addSubview(header)
        return supView;
    }
    
}
