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
    var MateriaAbierta: Materia!
    var ejerciciosPorAbrir: NSSet!
    var documentoPorAbrir: String!
    
    var secciones: [UnidadStruct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = true
        colorear()
        
        // comprobar que cosas tiene y que no para es mostrar
        let NSSetUnidades = MateriaAbierta.unidades ?? []
        var i = 1
        for NSUni in NSSetUnidades{
            let uni = NSUni as! Unidad
            let nombre = uni.nombreUni ?? ""
            let descrip = uni.descripcionUni ?? ""
            
            var nuevaSeccion = UnidadStruct(nombre: nombre, descripcion: descrip, numero: i)
            if let _ = uni.ejemplo{
                nuevaSeccion.contenido.append("Ejemplos")
            }
            if let _ = uni.teoria{
                nuevaSeccion.contenido.append("Teoria")
            }
            if let e = uni.ejercicios{
                if (e.count != 0){
                    nuevaSeccion.contenido.append("Ejercicios")
                }
            }
            //TODO: Agregar evaluaciones al modelo CD
            nuevaSeccion.contenido.append("Evaluación")
            
            secciones.append(nuevaSeccion)
            i += 1
        }
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = titulo
    }
//MARK: - tableView Cositas

    override func numberOfSections(in tableView: UITableView) -> Int {
        return MateriaAbierta.unidades?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones[section].contenido.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text = secciones[indexPath.section].contenido[indexPath.row]
        
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
        let uni = MateriaAbierta.unidades![section] as! Unidad
        header.customInit(title: uni.nombreUni ?? "Unidad \(section)", section: section, delegate: self)
        return header
        
    }
    
    
    func toggleSelection(header: ExpandibleHeaderView, section: Int) {
        secciones[section].expanded = !secciones[section].expanded
        
        tableView.beginUpdates()
        for i in 0..<secciones[section].contenido.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
        
    }
//MARK: - Mis Metodos
    
    func colorear () {
        if let c = color {
            UIApplication.shared.statusBarView?.backgroundColor = c
            self.navigationController?.navigationBar.tintColor = c
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : c]
        }
    }

    //Dependiendo de la fila escojida nos lleva a la vista
    func abrir (actividad: String, enUnidad: Int) {
        switch actividad {
        case "Teoria":
            let uni = MateriaAbierta.unidades![enUnidad] as! Unidad
            documentoPorAbrir = uni.teoria!
            self.performSegue(withIdentifier: "segueWeb", sender: self)
        case "Ejemplos":
            let uni = MateriaAbierta.unidades![enUnidad] as! Unidad
            documentoPorAbrir = uni.ejemplo!
            self.performSegue(withIdentifier: "segueWeb", sender: self)
        case "Ejercicios":
            ejerciciosPorAbrir = (MateriaAbierta.unidades![enUnidad] as! Unidad).ejercicios
            self.performSegue(withIdentifier: "segueEjercicios", sender: self)
        case "Evaluación":
            self.performSegue(withIdentifier: "segueEvaluacion", sender: self)
        default:
            print("Actividad desconocida: '\(actividad)'")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "segueEjercicios":
            let ejerciciosView = segue.destination as! EjercicioOpMulVC
            ejerciciosView.color = self.color
            ejerciciosView.Ejercicios = ejerciciosPorAbrir
        case "segueWeb":
            let webView = segue.destination as! PDFWebViewController
            webView.color = self.color
            webView.archivoPorAbrir = documentoPorAbrir
        case "segueEvaluacion":
            let evaluacionView = segue.destination as! EvaluacionTVC
            evaluacionView.color = self.color
        default:
            print("Segue desconocido.")
        }
    }
}
