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

   
    @IBOutlet weak var preguntaTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var color : UIColor!
    var opcionesDeRespuesta : [String] = ["1","2","3","4"]
    var opcionesDePregunta : [String] = ["Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.","On the other hand I am a very short question.", "I am a question intended to be 2 at least lines high but who knows if I-ll be able to achive it huas huas huas ."]
    var respuesta : String = ""
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preguntaTextView.text = opcionesDePregunta.shuffled()[0]
        respuesta = opcionesDeRespuesta.shuffled()[0]
        //cuando el textview esta sobre la tabla en el arbol de componentes del main.storybaord
        //por alguna razon el textview sale mas abajo, esto lo corrige
        preguntaTextView.setContentOffset(CGPoint.zero, animated: false)
        // si se cambian de lugar, primero la tabla y luego el textview desaparece ese misterioso espacio
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (color) == nil {
            print("color nil")
            color = UIColor.red
        }
        opcionesDeRespuesta = opcionesDeRespuesta.shuffled()
        //Para que el textview tome la altura necesaria para mostrar su contenido sin hacer scroll
        preguntaTextView.translatesAutoresizingMaskIntoConstraints = true
        preguntaTextView.sizeToFit()
        preguntaTextView.isScrollEnabled = false
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
            cambiarEjercicio()
        }
        else {
            celda.cambiarEstado(estado: posiblesEstados.equivocado)
        }
    }
    
    func cambiarEjercicio() {
        print("cambiando de segue")
    }
}
