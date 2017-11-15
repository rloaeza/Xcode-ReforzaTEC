//
//  EvaluacionTVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 11/13/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

class EvaluacionTVC: UITableViewController {
    
    @IBOutlet weak var ResultadosSV: UIStackView!
    @IBOutlet weak var AciertosL: UILabel!
    @IBOutlet weak var ErroresL: UILabel!
    @IBOutlet weak var TiempoL: UILabel!
    @IBOutlet weak var RevisarB: UIButton!
    @IBOutlet weak var AlturaC: NSLayoutConstraint!
    
    
    @IBOutlet weak var ResultadosV: UIView!
    
    var color: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    @IBAction func RevisarA(_ sender: Any) {
        // calificar
        // mostrar resultados
        UIView.animate(withDuration: 0.3, animations: {
            self.AlturaC.constant = 128
            self.ResultadosV.alpha = 1
        })
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 11
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preguntaAbierta", for: indexPath)as! PreguntaATVC
        cell.PreguntaL.text = String((indexPath.row + 1)) + ". " + Utils.preguntaRandom()
       
        // Configure the cell...

        return cell
    }

}
