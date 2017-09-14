//
//  MateriasDisponiblesViewController.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 7/17/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

class MateriasDisponiblesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: CustomUITableView!
    var materiasDescargadas : [Materia] = []
    
   
    var lastCell : CustomTableViewCell2 = CustomTableViewCell2 ()
    var tagCeldaExpandida = -1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //llenar materias de ejemplo desde la clase materia
        //materiasDescargadas = Materia.llenarConEjemplos()
       // configurarTabla()
        //descargarMaterias()
        materiasDescargadas = Materia.llenarConEjemplos()
        configurarTabla()
        
    }
    
    func configurarTabla() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName : "CustomTableViewCell2", bundle : nil) ,forCellReuseIdentifier: "CustomTableViewCell2")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materiasDescargadas.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell2", for: indexPath) as! CustomTableViewCell2
        
        if !cell.cellExists {
            cell.nombreLabel.text = materiasDescargadas[indexPath.row].mNombre
            cell.descripcionTextView.text = materiasDescargadas[indexPath.row].mDescripcion
            cell.cellExists = true
            cell.detailsView.backgroundColor = Utils.colorHash(materiasDescargadas[indexPath.row].mNombre)
            cell.titleView.backgroundColor = Utils.colorHash(materiasDescargadas[indexPath.row].mNombre)

        }
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        
        return cell
    }
    
  
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
    

    
    func descargarMaterias () {
        let url = URL(string: Materia.direccion)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {data,response,error -> Void in
            print("Creo que ya se descargo")
            if(error != nil){
                print(error.debugDescription)
            }
            self.jsonParser(d: data!)
            //self.configurarTabla()
            
        })
        
        task.resume()
     
    }
    
  
    func jsonParser(d: Data) {
        var names = [String] ()
        do {
            if NSString(data: d, encoding: String.Encoding.utf8.rawValue) != nil {
                let json = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as! [AnyObject]
                // ???
                names = json.map { ($0 as! [String:AnyObject]) ["nombre"] as! String }
            }
        } catch {
            print(error)
        }
        
        for n in names {
            materiasDescargadas.append(Materia(nombre: n, descripcion: nil))
        }
        configurarTabla()
        
    }
   

}
