//
//  EvaluacionTVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 11/13/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit
// Guarda las datos de celdas en el data soruce antes de que sean reutilizadas por la table view
protocol GuardarDatosProtocol: class{
    func guardar(respuestAbierta: String, en indice: Int)
    func guaradar(RespuestasMultiples: [UIView], en indice: Int)
}
class EvaluacionTVC: UITableViewController, GuardarDatosProtocol {
    
    struct PreguntaStruct {
        var indice: Int
        var texto: String
        var tipo: tipos
        var respuesta: String
        var opciones: [String]!
        var botones: [UIView]!
        var respuestaAbierta: String!
        enum tipos {
            case abierta
            case opcionM
        }
        // y practicamente este es el constructor para cuando es de abierta
        init(texto: String, respuesta: String, indice: Int) {
            self.indice = indice
            self.texto = texto
            self.tipo = .abierta
            self.respuesta = respuesta
            self.opciones = nil
            self.botones = nil
        }
        // practicmente este es el constructor para cuando es de opcionM
        init(texto: String, respuesta: String, opciones: [String], ancho: CGFloat, color: UIColor, indice: Int) {
            self.indice = indice
            self.texto = texto
            self.tipo = .opcionM
            self.respuesta = respuesta
            self.opciones = opciones
            var todas = opciones
            todas.append(respuesta)
            self.botones = arregloDeBotones(con: todas, ancho: ancho, color: color)
        }
        
        func arregloDeBotones(con strings: [String], ancho: CGFloat, color: UIColor)-> [UIView] {
            var botones: [DLRadioButton] = []
            for s in strings{
                let radioButton = DLRadioButton(frame: CGRect(x:0, y:0, width: ancho,  height: 30))
                radioButton.setTitle(s, for: [])
                radioButton.setTitleColor(UIColor.black, for: [])
                radioButton.iconColor = color
                radioButton.indicatorColor = color
                radioButton.contentHorizontalAlignment = .left
                radioButton.isMultipleSelectionEnabled = true
                botones.append(radioButton)
            }
            return botones
        }
    }
    
    
    @IBOutlet weak var ResultadosSV: UIStackView!
    @IBOutlet weak var AciertosL: UILabel!
    @IBOutlet weak var ErroresL: UILabel!
    @IBOutlet weak var TiempoL: UILabel!
    @IBOutlet weak var RevisarB: UIButton!
    @IBOutlet weak var AlturaC: NSLayoutConstraint!
    @IBOutlet weak var ResultadosV: UIView!
    
    var horaInicial: NSDate!
    var dataSource: [PreguntaStruct]!
    var color: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        inicializarDataSource()
       
        
        RevisarB.layer.borderWidth = 1.5
        RevisarB.layer.borderColor = color.cgColor
        RevisarB.layer.cornerRadius = 10
        RevisarB.setTitleColor(color,for: .normal)
        RevisarB.backgroundColor = UIColor.white
        
        ResultadosV.backgroundColor = UIColor.white
        ResultadosV.layer.borderWidth = 1.5
        ResultadosV.layer.borderColor = color.cgColor
        ResultadosV.layer.cornerRadius = 10
        ResultadosV.alpha = 0
        AlturaC.constant = 0
        
        tableView.register(UINib(nibName: "PreguntaATVC", bundle: nil), forCellReuseIdentifier: "preguntaAbierta")
        tableView.register(UINib(nibName: "PreguntaOMTVC", bundle: nil), forCellReuseIdentifier: "preguntaOpcion")
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        horaInicial = NSDate()
    }
    
    // revisarAction
    @IBAction func RevisarA(_ sender: Any) {
        // calificar
        // mostrar resultados
        contarAciertos()
        TiempoL.text?.append(tiempoTranscurrido())
        UIView.animate(withDuration: 0.3, animations: {
            self.AlturaC.constant = 128
            self.ResultadosV.alpha = 1
        })
        RevisarB.isEnabled = false
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let p = dataSource[indexPath.row]
        switch p.tipo {
            case .abierta:
                let cell = tableView.dequeueReusableCell(withIdentifier: "preguntaAbierta", for: indexPath)as! PreguntaATVC
                cell.PreguntaL.text = String(indexPath.row + 1) + ". " + p.texto
                cell.color = color
                cell.respuesta = p.respuesta
                cell.delegate = self
                cell.indiceDataSource = p.indice
                return cell
            case .opcionM:
                let cell = tableView.dequeueReusableCell(withIdentifier: "preguntaOpcion", for: indexPath)as! PreguntaOMTVC
                cell.PreguntaL.text = String(indexPath.row + 1) + ". " + p.texto
                cell.color = color
                cell.delegate = self
                cell.indiceDataSource = p.indice
                for view in p.botones {
                    cell.OpcionesSV.addArrangedSubview(view)
                }
                return cell
        }
    }
    
    private func inicializarDataSource() {
        dataSource = []
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(),respuesta: "todos", opciones: ["uno", "dos"], ancho: tableView.frame.width, color: color, indice: 0))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(),respuesta: "todos", opciones: ["uno", "dos"], ancho: tableView.frame.width, color: color, indice: 1))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Uno", indice: 2))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "México", indice: 3 ))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Azul", indice: 4))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 5 ))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 6))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 7))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(),respuesta: "si", opciones: ["no"], ancho: tableView.frame.width, color: color, indice: 8))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(),respuesta: "si", opciones: ["no"], ancho: tableView.frame.width, color: color, indice: 9))
        
//        dataSource = dataSource.shuffled()
    }
    
    // MARK:- Definicion de protocolos
    func guardar(respuestAbierta: String, en indice: Int) {
        dataSource[indice].respuesta = respuestAbierta
    }
    
    func guaradar(RespuestasMultiples: [UIView], en indice: Int) {
        dataSource[indice].botones = RespuestasMultiples
    }
    
    func tiempoTranscurrido() -> String {
        let segundos = Int(horaInicial.timeIntervalSinceNow.magnitude)
        let minutos = Int(segundos/60)
        
        if(minutos == 0) {
            return " \(segundos % 60) segundos"
        } else{
            return " \(minutos):\(segundos % 60) segundos"
        }
        
    }
    
    func contarAciertos() {
        var aciertos = 0
        var fallos = 0
        
//        for i in 0...dataSource.count {
//            switch(dataSource[i].tipo){
//            case .abierta:
//                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! PreguntaATVC
//                if(cell.revisar()){
//                    aciertos += 1
//                }else {
//                    fallos += 1
//                }
//            case .opcionM:
//                let cell = tableView.cell(at: IndexPath(row: i, section: 0)) as! PreguntaOMTVC
//                if(cell.revisar()){
//                    aciertos += 1
//                }else {
//                    fallos += 1
//                }
//            }
//        }
            
        
        
        AciertosL.text?.append(" \(aciertos)")
        ErroresL.text?.append(" \(fallos)")
    }
    
}
