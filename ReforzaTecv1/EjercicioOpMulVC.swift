//
//  EjercicioOpMulVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 7/31/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

//Por hacer la proxima vez:
//[] Llegar a un acuerdo sobre como mostrar el texto de la pregunta, habia unos bugs sobre la altura y al corregirlo salia 
//      otro bug con la alineacion
//      estaba pensando en dejar una altura fija (mejor dicho aspect ratio) para mostrar el texto, en caso de ser muy largo, pues si 
//      scroll pero el borde del textview deberia mostrar un blur en lugar de cortar el texto asi nada mas
//      y centrar el texto en ese espacio designado,lo mismo pensaba con las opciones de respuesta 

class EjercicioOpMulVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let RetrasoDeSegue: Int = 2
//para no estar descomentando cosas y probar rapido con breakpoints
    var debugVar = false
    var Ejercicios: NSSet?
    var EjercicioActual: Ejercicio!
   
    @IBOutlet weak var preguntaTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var BotonSiguiente: UIButton!
    
    var color : UIColor!
    var opcionesDeRespuesta : [String]!// = ["incorrecto","incorrecto","incorrecto","correcto"]
    var respuesta : String!// = "correcto"
    var botonSigOculto: Bool!
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        // si se cambian de lugar, primero la tabla y luego el textview desaparece ese misterioso espacio
        botonSigOculto = true
        BotonSiguiente.layer.cornerRadius = 20
        BotonSiguiente.layer.borderColor = color.cgColor
        BotonSiguiente.layer.borderWidth = 1.5
        BotonSiguiente.setTitleColor(UIColor.black, for: .normal)
        BotonSiguiente.frame.origin.y = self.view.bounds.size.height
        BotonSiguiente.alpha = 0
        BotonSiguiente.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EjercicioActual = Ejercicios!.allObjects[0] as! Ejercicio
        preguntaTextView.text = EjercicioActual.textos ?? "error"//"En esta parte es donde podremos encontrar la pregunta del ejercicio."//Utils.preguntaRandom()
        var  arreglo = EjercicioActual.respuestas!.characters.split{$0 == "|"}.map(String.init)
        for a in arreglo{
            if(a.contains("@")){
                respuesta = a//.trimmingCharacters(in: ['@'])
                break
            }
        }
        
        opcionesDeRespuesta = arreglo
        //respuesta = opcionesDeRespuesta.shuffled()[0]
        //cuando el textview esta sobre la tabla en el arbol de componentes del main.storybaord
        //por alguna razon el textview sale mas abajo, esto lo corrige
        if(debugVar) {
            preguntaTextView.setContentOffset(CGPoint.zero, animated: false)
        }
        
        
        
        if (color) == nil {
            print("color nil")
            color = UIColor.purple
        }
        opcionesDeRespuesta = opcionesDeRespuesta.shuffled()
        //Para que el textview tome la altura necesaria para mostrar su contenido sin hacer scroll
        if(debugVar){
            preguntaTextView.translatesAutoresizingMaskIntoConstraints = true
            preguntaTextView.sizeToFit()
            preguntaTextView.isScrollEnabled = false
        }
        configurarTabla()
      
    }

    // MARK:- TableView
    
    func configurarTabla() {
        //aqui da nil cuando esta aparte del storyboard
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName : "OpcionTableCell", bundle : nil) ,forCellReuseIdentifier: OpcionTableCell.reuseId)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OpcionTableCell.reuseId, for:indexPath) as! OpcionTableCell
        
        //aqui da nil
        cell.inicializar(titulo: opcionesDeRespuesta[indexPath.row], color: self.color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return opcionesDeRespuesta.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        revisar(celda: tableView.cellForRow(at: indexPath) as! OpcionTableCell)
    }
    // MARK:- Otros
    func revisar( celda : OpcionTableCell) {
        if(celda.etiqueta.text! == respuesta){
            celda.saltar(retraso: 0, fin: mostrarBoton())
        }else {
            var celdaCorrecta = OpcionTableCell()
            for i in 0..<opcionesDeRespuesta.count{
                if(opcionesDeRespuesta[i] == respuesta){
                    celdaCorrecta = tableView.cellForRow(at: IndexPath(row:i, section:0)) as! OpcionTableCell
                    break
                }
            }
            celda.agitar()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9, execute: {
                celdaCorrecta.etiqueta.textColor = UIColor.white
                celdaCorrecta.etiqueta.layer.borderColor = #colorLiteral(red: 0.1906670928, green: 0.9801233411, blue: 0.474581778, alpha: 1)
            })
            //celdaCorrecta.marcar(bien: true)
            //celdaCorrecta.saltar(retraso: 10.5, fin: mostrarBoton()) no se llama a tiempo el bloque de completion
            UIView.animate(withDuration: 0.2, delay: 1, options: [.transitionFlipFromBottom], animations: {
                celdaCorrecta.etiqueta.layer.backgroundColor = #colorLiteral(red: 0.1906670928, green: 0.9801233411, blue: 0.474581778, alpha: 1)
                celdaCorrecta.etiqueta.transform = CGAffineTransform.init(scaleX: 1.1, y: 0.98)
                //celdaCorrecta.(bien: true)
            }, completion: {_ in
               UIView.animate(withDuration: 0.1, animations: {
                celdaCorrecta.etiqueta.transform = CGAffineTransform.init(scaleX: 1, y: 1)
               })
                self.mostrarBoton()
            })
            
//            UIView.animateKeyframes(withDuration: 0.3, delay: 3, options: [.calculationModeCubic], animations: {
//                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2/3, animations: {
//                    celdaCorrecta.etiqueta.transform = CGAffineTransform.init(scaleX: 1.1, y: 0.98)
//                   // celdaCorrecta.marcar(bien: true)
//                })
//                UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
//                    celdaCorrecta.etiqueta.transform = CGAffineTransform.init(scaleX: 1, y: 1)
//
//                })
//            }, completion: {(finalizo: Bool) in
//                self.mostrarBoton()
//                celdaCorrecta.marcar(bien: true)
//            })
        }
    }
    
    func mostrarBoton() {
        if(!botonSigOculto) {return}
        tableView.allowsSelection = true
        UIView.animate(withDuration: 0.6, animations: {
            self.BotonSiguiente.frame.origin.y -= self.BotonSiguiente.bounds.size.height + 20
            self.BotonSiguiente.alpha = 1
            self.botonSigOculto = false
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "segueOrdenar":
            let view = segue.destination as! EjercicioOrdenarVC
            view.color = self.color
        default:
            print("Segue desconocido.")
        }
    }
}
