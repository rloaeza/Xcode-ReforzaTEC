//
//  EjercicioOrdenarVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 10/7/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit
// TODO:- Bugs
//      1. Prevenir que palabras cortas puedan irse a filas que ya estan marcadas como llenas
//      2. Puede que mas de una palabra pueda recorrerse al hacer espacio en una fila

class EjercicioOrdenarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    struct Fila{
        static let EspacioMinimoEntreCeldas = CGFloat(5)
        static var LargoMax: CGFloat?
        
        var palabras: [UILabel] {
            didSet{
                largo = 0
                for p in palabras{
                    largo += p.frame.size.width + Fila.EspacioMinimoEntreCeldas
                }
            }
        }
        
        var largo: CGFloat
        let contiene: String
        
        init (tipo: String){
            palabras = []
            largo = 0
            contiene = tipo
        }
        
        func puedeCotnener(otra label: UILabel) -> Bool {
            if(contiene == "opciones"){
                return true
            }else {// respuestas
                return Fila.LargoMax! > (largo + label.frame.size.width)
            }
        }
    }

    @IBOutlet weak var preguntaTextView: UITextView!
    @IBOutlet weak var BotonRevisar: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var IndiceSeccionDeOpciones: Int!
    
    var AltoDeEtiqueta: CGFloat!
    
    var color : UIColor! = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    
    let respuesta: String = "Esto es un texto de prueba que escribo para probar como funciona mi algoritmo."
    let relleno: String = "uno dos tres"
    
    var dataSource: [Fila] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AltoDeEtiqueta = nuevaLabel().frame.size.height
        Fila.LargoMax = collectionView.frame.size.width
        
        preguntaTextView.text = Utils.preguntaRandom()
        // calcular el numero de secciones para asi mostrar parrafos 
        // basandonos en el ancho de cada etiqueta mas el espacio entre ellas
        // y agregarlos como secciones vacias al principio del datasource
        
        // iniciando boton
        BotonRevisar.addTarget(self, action: #selector(revisar), for: .touchDown)
        BotonRevisar.layer.cornerRadius = 10
        BotonRevisar.layer.borderWidth = 1.5
        BotonRevisar.layer.borderColor = color.cgColor
        
        // inicializar data source
        // con seccion de opciones
        var seccionDeOpciones = Fila(tipo: "opciones")
        let opcionesDeRespuesta = (respuesta + " " + relleno).components(separatedBy: " ")
        for palabra in opcionesDeRespuesta{
            let etiqueta = nuevaLabel(palabra)
            seccionDeOpciones.palabras.append(etiqueta)
        }
        
        // agregar secciones/renglones en blanco para poner respuestas
        let filasParaRespuestas = Int(seccionDeOpciones.largo / Fila.LargoMax!)
        for _ in 0...filasParaRespuestas{
            dataSource.append(Fila(tipo: "respuestas"))
        }
        // agregar la seccion de opciones de respuesta
        dataSource.append(seccionDeOpciones)
        IndiceSeccionDeOpciones = dataSource.count - 1
    }
    
    func revisar() {
        print("revisando las respuestas")
    }
    
    
 
    // Regresa una UILabel dada una palabra
    func nuevaLabel(_ titulo: String = "word") -> UILabel{
        let label = UILabel()
        label.text = titulo
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = color
        
        label.adjustsFontForContentSizeCategory = false
        label.adjustsFontSizeToFitWidth = false
        label.sizeToFit()
        // añadirle un poco de padding
        label.frame.size.width += 15
        label.frame.size.height += 15
        label.layer.cornerRadius = 5
        label.frame.origin.y -= 3
        label.layer.masksToBounds = true

        return label
    }
    // MARK:- CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].palabras.count
    }
    /*
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let seccionOrigen = indexPath.section
        let posicionOrigen = indexPath.item
        var posicionDestino: Int
        var seccionDestino: Int
        // si tocan una palabra en la seccion de opciones, esta se va a la primer fila, si esta ya esta llena a la siguente
        // y asi sucesivamente hasta encontrar una fila donde haya espacio
        if(seccionOrigen == IndiceSeccionDeOpciones){
            let etiquetaPorMover = dataSource[seccionOrigen].remove(at: posicionOrigen)
            seccionDestino = 0
            var largo: CGFloat
            for seccion in 0..<(dataSource.count - 1){
                largo = CGFloat(0)
                for etiqueta in dataSource[seccion]{
                    largo += etiqueta.frame.size.width + EspacioMinimoEntreCeldas
                }
                
                if((largo + etiquetaPorMover.frame.size.width) < LargoDeRenglon){
                    break
                }
                seccionDestino += 1
                
            }
            // mover  en data source
            dataSource[seccionDestino].append(etiquetaPorMover)
            // mover la celda en collectionview
            posicionDestino = collectionView.numberOfItems(inSection: seccionDestino)
            collectionView.moveItem(at: indexPath, to: IndexPath(item:posicionDestino, section: seccionDestino))
            
            }
        
        // palabras tocadas en cualquier otra seccion regresaran a la seccion de opciones y se re organizan las palabras las 
        // palabras en las otras secciones
    
        else  {
            // mandar al fondo
            posicionDestino = collectionView.numberOfItems(inSection:SeccionDeOpciones)
            // en data source
            let etiquetaPorMover = dataSource[seccionOrigen].remove(at: posicionOrigen)
            dataSource[SeccionDeOpciones].append(etiquetaPorMover)
            // en collectionView
            collectionView.moveItem(at: indexPath, to: IndexPath(item:posicionDestino, section:SeccionDeOpciones))
            
            // TODO: - Bug
            // intentar recorrer palabras que estan de la seccion origen hacia abajo
            // a menos que la seccion siguiente sea la de opciones
//            if(seccionOrigen + 1 != SeccionDeOpciones){
//                return
//            }
            var largoFilaOrigen = CGFloat(0)
            for p in dataSource[seccionOrigen]{
                largoFilaOrigen += p.frame.size.width
            }
                // si cabe la primer etiqueta de la fila que sigue ya la hicimos (otro movimiento)
            if((dataSource[seccionOrigen + 1].count > 0) && ((largoFilaOrigen + dataSource[seccionOrigen + 1][0].frame.size.width) < LargoDeRenglon)){
                let e = dataSource[seccionOrigen + 1].remove(at: 0)
                dataSource[seccionOrigen].append(e)
                let d = collectionView.numberOfItems(inSection: seccionOrigen)
                collectionView.moveItem(at: IndexPath(item:0, section:seccionOrigen + 1), to: IndexPath(item:d, section:seccionOrigen))
            }
        }
    }
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ancho = dataSource[indexPath.section].palabras[indexPath.item].frame.size.width
        return CGSize(width: ancho, height: AltoDeEtiqueta)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if(section == (collectionView.numberOfSections - 2)){
            // espacio entre la secion de respuestas y la de opcionnes
            return CGSize.init(width: collectionView.frame.size.width, height: 60)
        }
        else {// espacio normal entre renglones
            return CGSize.init(width: collectionView.frame.size.width, height: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if(collectionView.numberOfItems(inSection: section) == 0) {
            // Darle una altura da las secciones vacias?
            return CGSize.init(width: collectionView.frame.size.width, height: AltoDeEtiqueta + 1)
        }else{
            // si tuviera la altura = 0 daria un bug cuando todas las palabras estan una seccion intermedia y luego intentas sacarla
            return CGSize(width: 0, height: 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath)
        let label = dataSource[indexPath.section].palabras[indexPath.item]
        label.tag = 1
        celda.contentView.addSubview(label)
        celda.clipsToBounds = false
        return celda
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if(kind == "UICollectionElementKindSectionFooter"){
            // remueve la linea del parrafo del footer en caso de ser la ultima seccion (donde se encuentran las opciones)
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collection_footer", for: indexPath)
            if(indexPath.section == (collectionView.numberOfSections - 1)){
                footer.viewWithTag(2)?.isHidden = true
            }
            return footer;
        }else {//header
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collection_header", for: indexPath)
            return header
        }
    }
    
}
