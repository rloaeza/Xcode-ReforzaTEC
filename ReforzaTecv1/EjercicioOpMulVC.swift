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
   
    @IBOutlet weak var preguntaTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var BotonSiguiente: UIButton!
    
    var color : UIColor!
    var opcionesDeRespuesta : [String] = ["1","2","3","4"]
    var respuesta : String = ""
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preguntaTextView.text = Utils.preguntaRandom()
        respuesta = opcionesDeRespuesta.shuffled()[0]
        //cuando el textview esta sobre la tabla en el arbol de componentes del main.storybaord
        //por alguna razon el textview sale mas abajo, esto lo corrige
        if(debugVar) {
            preguntaTextView.setContentOffset(CGPoint.zero, animated: false)
        }
        // si se cambian de lugar, primero la tabla y luego el textview desaparece ese misterioso espacio
        
        BotonSiguiente.layer.cornerRadius = 20
        BotonSiguiente.backgroundColor = color
        BotonSiguiente.setTitleColor(UIColor.white, for: .normal)
        BotonSiguiente.frame.origin.y = self.view.bounds.size.height
        BotonSiguiente.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (color) == nil {
            print("color nil")
            color = UIColor.red
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
   
    func revisar( celda : OpcionTableCell) {
        if celda.etiqueta.text == respuesta {
            celda.cambiarEstado(estado: posiblesEstados.acertado)
            mostrarBoton()
        }
        else {
            celda.cambiarEstado(estado: posiblesEstados.equivocado)
        }
    }
    
    func mostrarBoton() {
        tableView.allowsSelection = false
        UIView.animate(withDuration: 1, animations: {
            self.BotonSiguiente.frame.origin.y -= self.BotonSiguiente.bounds.size.height + 20
            self.BotonSiguiente.alpha = 1
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
