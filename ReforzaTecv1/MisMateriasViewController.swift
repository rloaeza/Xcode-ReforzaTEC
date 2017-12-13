//
//  ViewController.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 7/17/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit
import CoreData

class MisMateriasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BtnBorrarMateriaDelegate {
    
    let color : UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tableView: CustomUITableView!
    var materiasDescargadas : [Materia] = []
    var lastCell : CustomTableViewCell = CustomTableViewCell ()//guarda la celda que esta expandida?
    var tagCeldaExpandida = -1//identifica a la celda abierta
    
    //deberia dejarle el color por defecto al tinte (azul) a los view controlers este y el de descargas? 
    //lo puse en view did appear por que en view did load no funcionaba?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Restablece la barra de estado y el tinte a color transparente (lol)y negro, si no, cuando regresas de una materia, la barra conservaria el color pasado.
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : color]
        //tal vez poner aqui lo de recuperar la informacion de Core
        recuperarData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // prueba de coredata Escribiendo
//        print("Prueba de core data escribiendo \n")
//
//                let m = Materia(context: context)
//                m.nombre = "materia65"
//                let unidad4 = Unidad(context: context)
//                unidad4.nombreUni = "unidad 5.661"
//
////                let unidad2 = Unidad(context: context)
////                unidad2.nombreUni = "unidad 2.2"
////
////                let unidad3 = Unidad(context: context)
////                unidad3.nombreUni = "unidad 3.2"
//
//                m.addToUnidades(unidad4)
////                m.addToUnidades(unidad2)
////                m.addToUnidades(unidad3)
//
//                unidad4.materia = m
////                unidad2.materia = m
////                unidad3.materia = m
//
//
//                do{
//                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
////                    try context.save()
//                }catch{
//                    print("error")
//                }

        print("Prueba de core data leyendo\n")
        do{
            let materiasEncontradas = (try context.fetch(Materia.fetchRequest())) as! [Materia]
            for materia in materiasEncontradas{
//                let materia = materiaEncontrada as! Materia
                print(materia.nombre ?? "materia sin nombre")
                if let unidadesEncontradas = materia.unidades{
                    for unidadEncontrada in unidadesEncontradas{
                        let unidad = unidadEncontrada as! Unidad
                        print(unidad.nombreUni ?? "unidad sin nombre")
                    }
                }else{
                    print("Materia sin unidades")
                }
             print("///")
            }
        }catch{
            print("Error al leer datos")
        }
        
        configurarTabla()
    }
    
    func recuperarData(){

        do {
            materiasDescargadas = (try context.fetch(Materia.fetchRequest())) as! [Materia]
        } catch {
            print("Error al recuperar las materias")
        }
    }
    //Si el toque largo se hizo sobre una celda, esta se expandira
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
  
    //MARK:- Cositas Table View
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
            cell.nombreLabel.text = m.nombre
            cell.descripcionTextView.text = m.descripcion
            cell.cellExists = true
            cell.detailsView.backgroundColor = Utils.colorHash(m.nombre ?? "error" )
            cell.titleView.backgroundColor = cell.detailsView.backgroundColor
            cell.delegate = self
            cell.referenciaCD = m
            
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            materiasDescargadas.remove(at: indexPath.row)//tal vez esto deberia estar en eliminarMateria(celda)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    //MARK:- Cositas Segue

    //curr in use
    func abrirMateria (_ numero: Int) {
        self.performSegue(withIdentifier: "segueContenido", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueContenido" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contenidoView = segue.destination as! ContenidoMateria
                let selectedRow = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
                contenidoView.titulo = selectedRow.nombreLabel.text!
                contenidoView.color = selectedRow.detailsView.backgroundColor
                contenidoView.MateriaAbierta = selectedRow.referenciaCD
            }
        }
    }
    
    //MARK:- Cosas extra
    
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

    //Cumpliendo con el delegado del CustomTableView para que al darle en el boton de borrar de la celda se llame aqui esto y se borre
    //Elimina la materia de coreData y la celda del tableview
    //primero muestra
    func eliminarMateria(_ celda : CustomTableViewCell) {
        let alerta = UIAlertController(title: "¿Deseas borrar la materia \(celda.nombreLabel.text!)?", message: "Tu progreso será perdido", preferredStyle: UIAlertControllerStyle.actionSheet)
        alerta.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.destructive, handler: {_ in
            let indexPath = self.tableView.indexPath(for: celda)!
            let coreData = celda.referenciaCD!
            self.tableView(self.tableView, commit: .delete, forRowAt: indexPath)
            self.context.delete(coreData)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {_ in
            print("Cancelado, nada se borrara.")
        }))
        self.present(alerta, animated: true, completion: nil)
    }

}

