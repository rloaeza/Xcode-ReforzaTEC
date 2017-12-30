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
        var respuestaCorrecta: String
        var opciones: [String]!
        var botones: [UIView]!
        var respuestaAbierta: String!
        var estado: estados!
        enum tipos {
            case abierta
            case opcionM
        }
        enum estados {
            case sinCalificar
            case correcto
            case incorrecto
        }
        // y practicamente este es el constructor para cuando es de abierta
        init(texto: String, respuesta: String, indice: Int) {
            self.indice = indice
            self.texto = texto
            self.tipo = .abierta
            self.respuestaCorrecta = respuesta
            self.respuestaAbierta = ""
            self.opciones = nil
            self.botones = nil
            self.estado = .sinCalificar
        }
        // practicmente este es el constructor para cuando es de opcionM
        init(texto: String, respuesta: String, opciones: [String], ancho: CGFloat, color: UIColor, indice: Int) {
            self.indice = indice
            self.texto = texto
            self.tipo = .opcionM
            self.respuestaCorrecta = respuesta
            self.opciones = opciones
            var todas = opciones
            todas.append(respuesta)
            self.botones = arregloDeBotones(con: todas, ancho: ancho, color: color)
            self.estado = .sinCalificar
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
        mutating func esCorrecto() ->Bool{
          switch self.tipo {
             case .abierta:
                if (respuestaCorrecta.caseInsensitiveCompare(respuestaAbierta) == ComparisonResult.orderedSame){
                    estado = .correcto
                    return true
                }else{
                    estado = .incorrecto
                    return false
                 }
             case .opcionM:
                estado = .correcto
                return true
             }
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
                cell.respuestaCorrecta = p.respuestaCorrecta
                cell.RespuestaTF.text = p.respuestaAbierta
                cell.delegate = self
                cell.indiceDataSource = p.indice
                if(p.estado == .correcto){
                    cell.RespuestaTF.textColor = UIColor.green
                    cell.RespuestaTF.isEnabled = false
                }else if(p.estado == .incorrecto){
                    cell.RespuestaTF.textColor = UIColor.red
                    cell.RespuestaTF.isEnabled = false
                    let attributedString: NSMutableAttributedString =  NSMutableAttributedString(string: p.respuestaAbierta)
                    attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
                    cell.RespuestaTF.attributedText = attributedString
                }else {
                    cell.RespuestaTF.textColor = UIColor.purple
                }
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
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(),respuesta: "3", opciones: ["1", "2"], ancho: tableView.frame.width, color: color, indice: 0))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(),respuesta: "todos", opciones: ["uno", "dos"], ancho: tableView.frame.width, color: color, indice: 1))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Uno", indice: 2))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "México", indice: 3 ))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Azul", indice: 4))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 5 ))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 6))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 7))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(),respuesta: "tal vez", opciones: ["quiza"], ancho: tableView.frame.width, color: color, indice: 8))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(),respuesta: "si", opciones: ["no"], ancho: tableView.frame.width, color: color, indice: 9))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 10))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(),respuesta: "sep", opciones: ["nao"], ancho: tableView.frame.width, color: color, indice: 11))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Azul", indice: 12))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 13 ))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 14))
        dataSource.append(PreguntaStruct(texto: Utils.preguntaRandom(), respuesta: "Apio", indice: 15))
//        dataSource = dataSource.shuffled()
    }
    
    // MARK:- Definicion de protocolos
    func guardar(respuestAbierta: String, en indice: Int) {
        dataSource[indice].respuestaAbierta = respuestAbierta
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
            return " \(minutos) minutos:\(segundos % 60) segundos"
        }
        
    }
    
    func contarAciertos() {
        var aciertos = 0
        var fallos = 0
        
        for i in 0...(dataSource.count - 1){
            if (dataSource[i].esCorrecto()){
                aciertos += 1
            }else {
                fallos += 1
            }
        }
        
        
        AciertosL.text?.append(" \(aciertos)")
        ErroresL.text?.append(" \(fallos)")
    }
    
}
