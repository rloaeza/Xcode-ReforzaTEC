
//
//  MateriasDisponiblesViewController.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 7/17/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit
//Renombrar a materiasDescargables?
class MateriasDisponiblesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BtnMateriaDelegate {

    @IBOutlet weak var tableView: CustomUITableView!
    var dataSource : [MateriaObj] = []
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var controlActualizar: UIRefreshControl!
    var lastCell : CustomTableViewCell2 = CustomTableViewCell2 ()
    var tagCeldaExpandida = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurarTabla()
        descargarListaMaterias()//y configurar tabla
      
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // soluciona un detalle que, luego de cargar la vista tenias que darle un click para que saliera la lista
        if(dataSource.isEmpty){
            mostrarVistaVacia(true)
        }else{
            tableView.reloadData()
        }
    }
    
    
    @IBAction func borrarTodo() {
        let alerta = UIAlertController(title: "Purgar CoreData", message: "Seguro borrar todo?", preferredStyle: UIAlertControllerStyle.alert)
        alerta.addAction(UIAlertAction(title: "Purgar", style: UIAlertActionStyle.destructive, handler: {_ in
            do{
                let materiasGuardadas = try self.context.fetch(Materia.fetchRequest()) as! [Materia]
                for m in materiasGuardadas {
                    print("Borrando \(m.nombre!)")
                    self.context.delete(m)
                }
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                print("CoreData purgado")
            }catch {
                print("Error al tratar de borrar todas las materias")
            }
        }))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {_ in
            print("Cancelado, nada se borrara.")
        }))
        self.present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            var touchPoint = sender.location(in: self.view)
            touchPoint.y -= 70
            //seria mejor restarle la altura de la barra de navegacion + barra de estado?
            if let rowIndex = tableView.indexPathForRow(at: touchPoint) {
                expandirCelda(numero: rowIndex.row)
            }
        }
    }
    
//    MARK:- Cositas TableView
    
    func configurarTabla() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName : "CustomTableViewCell2", bundle : nil) ,forCellReuseIdentifier: "CustomTableViewCell2")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
        // aniade la cosa para recargar cuando deslizes hacia abajo
        controlActualizar = UIRefreshControl()
        controlActualizar.addTarget(self, action: #selector(actualizar(_:)), for: .valueChanged)
        controlActualizar.tintColor = UIColor.orange
        tableView.addSubview(controlActualizar)
        // le pone un mensaje a mostrar si esta vacia
        let etiqueta = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        etiqueta.textColor = UIColor.red
        etiqueta.textAlignment = NSTextAlignment.center
        etiqueta.numberOfLines = 3
        etiqueta.text = "No se pudo conectar con el servidor.\n😥\nDesliza hacia abajo para actualizar."
        tableView.separatorStyle  = UITableViewCellSeparatorStyle.none
        tableView.backgroundView = etiqueta
        tableView.backgroundView?.isHidden = true
    }
    
    // Le pone un mensaje a la table view diciendo que no se pudo recargar
    func mostrarVistaVacia(_ mostrar: Bool) {
        tableView.backgroundView?.isHidden = !mostrar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guardarMateria(tableView.cellForRow(at: indexPath) as! CustomTableViewCell2)
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell2", for: indexPath) as! CustomTableViewCell2
    
        if !cell.cellExists {
            cell.nombreLabel.text = dataSource[indexPath.row].mNombre
            cell.descripcionTextView.text = dataSource[indexPath.row].mDescripcion
            cell.cellExists = true
            cell.detailsView.backgroundColor = Utils.colorHash(dataSource[indexPath.row].mNombre)
            cell.titleView.backgroundColor = Utils.colorHash(dataSource[indexPath.row].mNombre)
            cell.objMateria = dataSource[indexPath.row]
            cell.delegate = self
        }
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
   
    
    
    //MARK:- Mis metodos extras
    
    func expandirCelda(numero : Int) {
        self.tableView.beginUpdates()
        
        let previousCellTag = tagCeldaExpandida
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            if numero == tagCeldaExpandida {
                tagCeldaExpandida = -1
                lastCell = CustomTableViewCell2()
            }
        }
        
        if numero != previousCellTag {
            tagCeldaExpandida = numero
            lastCell = tableView.cellForRow(at: IndexPath(row: tagCeldaExpandida, section: 0)) as! CustomTableViewCell2
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
        }
        
        self.tableView.endUpdates()
    }
    
    func guardarMateria(_ row : CustomTableViewCell2){
        
        //guardando en CoreData
        let objMateria = row.objMateria!

        let url = URL(string: MateriaObj.DESCARGA_UNIDAD + String(objMateria.id))
        print(url!.absoluteString)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {data, response, error -> Void in
            if(error != nil){
                print(error.debugDescription)
                print("Error al descargar la lista de materias")
            }
            else {
                // una materia
                let coreDataMateria = Materia(context:self.context)
                coreDataMateria.idMateria = Int32(objMateria.id)
                coreDataMateria.nombre = objMateria.mNombre
                coreDataMateria.descripcion = objMateria.mDescripcion

                let arregloRaiz = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let unidadesJson = arregloRaiz as? [Any]{
                    for unidadJson in unidadesJson{
                        if let unidad = unidadJson as? [String: Any]{
                            let coreDataUnidad = Unidad(context: self.context)
                            
                            if let nombre = unidad["nombre"] as? String{
                                print("nombre: \(nombre)")
                                coreDataUnidad.nombreUni = nombre
                            }
//                            if let descripcion = unidad["descripcion"] as? String {
//                                print("descripcion: \(descripcion)")
//                                coreDataUnidad.descripcionUni = descripcion
//                            }
//                            if let teoria = unidad["teoria"] as? String {
//                                print("teoria: \(teoria)")
////                                let coreDataTeoria = Teoria(context: context)
////                                coreDataTeoria.archivoTeoria = teoria
////                                coreDataUnidad.teoria = coreDataTeoria
//                            }
//                            if let ejemplo = unidad["ejemplo"] as? String {
//                                print("ejemplo: \(ejemplo)")
////                                let coreDataEjemplo = Ejemplos(context: context)
////                                coreDataEjemplo.archivoEjemplos = ejemplo
////                                coreDataUnidad.ejemplos = coreDataEjemplo
//                            }
                            if let ejerciciosJson = unidad["ejercicios"] as? [Any]{
                                for ejercicioJson in ejerciciosJson{
                                    if let ejercicio = ejercicioJson as? [String: Any]{
                                        let coreDataEjercicio = Ejercicio(context: self.context)
                                        if let pregunta = ejercicio["pregunta"] as? String{
                                            print("pregunta \(pregunta)")
                                            coreDataEjercicio.textos = pregunta
                                        }
                                        if let respuestas = ejercicio["respuestas"] as? String{
                                            print("respuestas \(respuestas)")
                                            coreDataEjercicio.respuestas = respuestas
                                        }
                                        if let tipo = ejercicio["tipo"] as? String{
                                            print("tipo \(tipo)")
                                            coreDataEjercicio.tipo = tipo
                                        }
                                        coreDataEjercicio.unidad = coreDataUnidad
                                        coreDataUnidad.addToEjercicios(coreDataEjercicio)
                                    }
                                }
                            }
//                            if let evaluacionesJson = unidad["evaluacion"] as? [Any]{
//                                for evaluacionJson in evaluacionesJson{
//                                    if let evaluacion = evaluacionJson as? [String: Any]{
//                                        let coreDataEvaluacion = EvaluacionMO(context: self.context)
//
//                                        if let idEvaluaciones = evaluacion ["idEvaluaciones"] as? Int32 {
//                                            print("idEvaluaciones: \(idEvaluaciones)")
//                                            coreDataEvaluacion.idEvaluacion = idEvaluaciones
//                                        }
//                                        if let texto = evaluacion["textos"] as? String{
//                                            print("texto \(texto)")
//                                            coreDataEvaluacion.texto = texto
//                                        }
//                                        if let respuesta = evaluacion["respuestas"] as? String {
//                                            print("respuesta \(respuesta)")
//                                            coreDataEvaluacion.respuestas = respuesta
//                                        }
//                                        coreDataUnidad.addToEvaluaciones(coreDataEvaluacion)
//                                    }
//                                }
//                            }
                            coreDataUnidad.materia = coreDataMateria
                            coreDataMateria.addToUnidades(coreDataUnidad)
                        }
                    }
                }
 
                DispatchQueue.main.async {
                   
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
//                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    print("Materia de \(objMateria.mNombre) con la id:\(objMateria.id) guardada en CoreData!" )
                    //removiendo de la lista
                    self.tableView(self.tableView, commit: .delete, forRowAt: self.tableView.indexPath(for: row)!)
                }
 
            }

        })
        task.resume()
    }
    
    func descargarListaMaterias () {
        let url = URL(string: MateriaObj.direccion)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {data,response,error -> Void in
            self.dataSource.removeAll()
            //task ejecutandose
            if(error != nil){
                print(error.debugDescription)
                print("Error al descargar la lista de materias")            }
            else {
                self.parsearJSON(d: data!)
            }
        })
        task.resume()
     
    }
    
  //parsea json e inicializa la tabla
    func parsearJSON(d: Data) {
        var names = [String] ()
        var ids = [String] ()
        var descriptions = [String] ()
        do {
            if NSString(data: d, encoding: String.Encoding.utf8.rawValue) != nil {
                let json = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as! [AnyObject]
                // ???
                names = json.map { ($0 as! [String:AnyObject]) ["nombre"] as! String }
                ids = json.map { ($0 as! [String:AnyObject]) ["idMaterias"] as! String }
                descriptions = json.map { ($0 as! [String:AnyObject]) ["descripcion"] as! String }
            }
        } catch {
            print(error)
        }
        //tal vez es inecesario, por quitar?
        guard names.count == ids.count && ids.count == descriptions.count else {
            print("Tenemos diferente cantidad de materias, ids o descripciones")
            return
        }
        
        //agarrar las materias ya guardadas para no mostrarlas
        var materiasGuardadas : [Materia]
        do{
            materiasGuardadas = try context.fetch(Materia.fetchRequest()) as! [Materia]
        }catch {
            print("Error al tratar de comparar materias descargadas con guardadas")
            return
        }
        
        for i in 0...(ids.count-1){
            dataSource.append(MateriaObj(id: Int(ids[i])!, nombre: names[i], descripcion: descriptions[i]))
        }
        
        var materiasParaMostrar = [MateriaObj] ()
        var guardar : Bool
        for md in dataSource {
            guardar = true
            for mg in materiasGuardadas{
                if(md.id == Int(mg.idMateria)){
                    //no guardar
                    guardar = false
                    break
                }
            }
            if(guardar){
                materiasParaMostrar.append(md)
            }
        }
        //por renombrar y removar cosas inesecarias
        dataSource = materiasParaMostrar
        //configurarTabla()
        
    }
    
    func btnDescargarDelegate(_ row : CustomTableViewCell2) {
        guardarMateria(row)
    }
    @objc func actualizar(_ controlActualizar: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.descargarListaMaterias()
            self.tableView.reloadData()
            self.controlActualizar.endRefreshing()
            if(self.dataSource.isEmpty){
                self.mostrarVistaVacia(true)
            }else{
                self.tableView.reloadData()
                self.mostrarVistaVacia(false)
            }
        })
        
        
        
    }
   

}
