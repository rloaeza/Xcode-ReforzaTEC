//
//  ViewController.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 7/17/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

class MisMateriasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let color : UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
   
    @IBOutlet weak var tableView: CustomUITableView!
    var materiasDescargadas : [Materia] = []
    
    var lastCell : CustomTableViewCell = CustomTableViewCell ()//guarda la celda que esta expandida?
    var tagCeldaExpandida = -1//identifica a la celda abierta
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : color]

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cargarMaterias()
        configurarTabla()
    }
    
    func configurarTabla() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName : "CustomTableViewCell", bundle : nil) ,forCellReuseIdentifier: "CustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
    }
    
    func cargarMaterias () {
        materiasDescargadas.append(Materia(nombre: "Matematicas", descripcion: "Aqui podras apredner los secretos de la lengua espanola asi como inglesa."))
        materiasDescargadas.append(Materia(nombre: "Redes", descripcion: "Por que existe esta materia?!?!"))
        materiasDescargadas.append(Materia(nombre: "Defensa Personal", descripcion: nil))
        materiasDescargadas.append(Materia(nombre: "Fisica ll", descripcion: "Todo lo que puedas esperar de la fisica."))
        materiasDescargadas.append(Materia(nombre: "Conjuros 1", descripcion: "Aprende a realizar conjuros y encantamientos de todo nivel. Busquen sus nuevos libros en la biblioteca por favor!"))
        materiasDescargadas.append(Materia(nombre:"Lorem Ipsum", descripcion : "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."))
        materiasDescargadas.reverse()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materiasDescargadas.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        if !cell.cellExists {
            let m = materiasDescargadas[indexPath.row]
            cell.nombreLabel.text = m.mNombre
            cell.descripcionTextView.text = m.mDescripcion
            cell.cellExists = true
            cell.detailsView.backgroundColor = m.mColor
            cell.titleView.backgroundColor = m.mColor
            //cell.openButton.addTarget(self, action: #selector(abrirContenido(sender:)), for: .touchUpInside)
            //para saber cual boton pertenece a cual materia
            cell.openButton.tag = indexPath.row
            }
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        abrirMateria(indexPath.row)
    }
    
    //curr in use
    func abrirMateria (_ numero: Int) {
        print("Vamos a abrir una materia")
        let contenidoView = ContenidoMateria()
        contenidoView.titulo = materiasDescargadas[numero].mNombre
        contenidoView.color = materiasDescargadas[numero].mColor
        self.navigationController?.pushViewController(contenidoView, animated: true)
    }
    
//    func abrirMateria(sender: UIButton) {
//        let contenidoView = ContenidoMateria()
//        contenidoView.titulo = materiasDescargadas[sender.tag].mNombre
//        contenidoView.color = materiasDescargadas[sender.tag].mColor
//        self.navigationController?.pushViewController(contenidoView, animated: true)
//    }
    
    func expandirCelda(numero : Int) {
        self.tableView.beginUpdates()
        let previousCellTag = tagCeldaExpandida
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.2, c: {
                
                self.view.layoutIfNeeded()
            })
            if numero == tagCeldaExpandida {//si la celda que quiere volver a abrirse ya esta abierta se cierra
                tagCeldaExpandida = -1// menos uno indica que no hay celdas abiertas
                lastCell = CustomTableViewCell()//seria mas rapido modificar lastCell.exists?
            }
        }
        
        if numero != previousCellTag {
            tagCeldaExpandida = numero
            lastCell = tableView.cellForRow(at: IndexPath(row: tagCeldaExpandida, section: 0)) as! CustomTableViewCell
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
        }
        
        self.tableView.endUpdates()
    }

   

    

    
    @IBAction func longTouchHandler(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {
            var touchPoint = sender.location(in: self.view)
            touchPoint.y -= 70
            //seria mejor restarle la altura de la barra de navegacion + barra de estado?
            if let rowIndex = tableView.indexPathForRow(at:touchPoint) {
                    expandirCelda(numero: rowIndex.row)
            }
        }
    }
    
    
  

}

