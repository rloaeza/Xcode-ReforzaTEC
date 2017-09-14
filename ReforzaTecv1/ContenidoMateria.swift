//
//  ContenidoMateria.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 7/25/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//
import UIKit

class ContenidoMateria: UITableViewController, ExpandibleHeaderRowDelegate   {
    
    var titulo : String = ""
    var color : UIColor!
    
    
    var secciones = [UnidadSeccion(nil ,numeroUnidad: 1, expanded: false),
                     UnidadSeccion(nil ,numeroUnidad: 2, expanded: false),
                     UnidadSeccion(nil ,numeroUnidad: 3, expanded: false)]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
        colorear()
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = titulo
    }
//MARK: - tableView Cositas

    override func numberOfSections(in tableView: UITableView) -> Int {
        return secciones.count
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones[section].material.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = secciones[indexPath.section].material[indexPath.row]
            return cell

    }
    
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection indexPath: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (secciones[indexPath.section].expanded) {
            return 44
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    //cehcar enums
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        abrir(actividad: (tableView.cellForRow(at: indexPath)?.textLabel?.text!)!, enUnidad: indexPath.section)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandibleHeaderView()
        header.customInit(title: "Unidad \(section + 1)", section: section, delegate: self)
        return header
        
    }
    
    
    func toggleSelection(header: ExpandibleHeaderView, section: Int) {
        secciones[section].expanded = !secciones[section].expanded
        
        tableView.beginUpdates()
        for i in 0..<secciones[section].material.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
        
    }
//MARK: - Mis Metodos
    
    func colorear () {
        if let c = color {
            UIApplication.shared.statusBarView?.backgroundColor = c
            self.navigationController?.navigationBar.tintColor = c
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : c]
        }
    }

    //Dependiendo de la fila escojida nos lleva a la vista
    func abrir (actividad: String, enUnidad: Int) {
        switch actividad {
        case "Teoria":
            print("Abrir Teoria")
//            let view = PDFWebViewController()
//            view.color = self.color
//            navigationController?.pushViewController(view, animated: true)
            self.performSegue(withIdentifier: "segueWeb", sender: self)
        case "Ejercicios":
            print("Abrir ejercicios")
            //navigationController?.performSegue(withIdentifier: "EjerciciosSegue",
            self.performSegue(withIdentifier: "segueEjercicios", sender: self)
        default:
            print("Actividad desconocida: '\(actividad)'")
        }
    }
}
