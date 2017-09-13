//
//  EjercicioOpMulVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 7/31/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

class EjercicioOpMulVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

   
    @IBOutlet weak var preguntaTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    var color : UIColor!// = Utils.colorHash("Matematicas")
    var opcionesDeRespuesta : [String] = ["Kuro","Shiro","Ao","Amarillo"]
    var respuesta : String = "Kuro"
  
    override func viewDidLoad() {
        super.viewDidLoad()
        if (color) == nil {
            print("color nil")
            color = UIColor.red
        }
        opcionesDeRespuesta = opcionesDeRespuesta.shuffled()
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
