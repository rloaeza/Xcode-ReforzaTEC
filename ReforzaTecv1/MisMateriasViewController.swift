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
        //Restablece la barra de estado y el tinte a color transparente (lol)y negro, si no, cuando regresas de una materia, la barra conservaria el color pasado.
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : color]

    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        materiasDescargadas = Materia.llenarConEjemplos()
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
    //MARK: Remover boton de las celdas
    //curr in use
    func abrirMateria (_ numero: Int) {
        self.performSegue(withIdentifier: "segueContenido", sender: self)
//        let contenidoView = ContenidoMateria()
//        contenidoView.titulo = materiasDescargadas[numero].mNombre
//        contenidoView.color = materiasDescargadas[numero].mColor
//        print("alo")
//        contenidoView.navigationController?.performSegue(withIdentifier: "segueContenido", sender: self)
//        self.navigationController?.pushViewController(contenidoView, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueContenido" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contenidoView = segue.destination as! ContenidoMateria
                contenidoView.titulo = materiasDescargadas[indexPath.row].mNombre
                contenidoView.color = materiasDescargadas[indexPath.row].mColor
            }
        }
    }
    
    //Forma antigua de abrir una materia, ahora es cuando se selecciona cualquier parte de la materia
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

