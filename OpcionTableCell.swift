//
//  OpcionTableCell.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 8/1/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

enum posiblesEstados {
    case equivocado
    case acertado
    case blanco
}

class OpcionTableCell: UITableViewCell {
    @IBOutlet weak var etiqueta: UILabel!
    
    static let reuseId : String = "celdaOpcion"
    var color : UIColor!
    var estadoActual : posiblesEstados!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        etiqueta.layer.borderWidth = 1.5
        etiqueta.layer.cornerRadius = 6
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    func inicializar(titulo: String, color: UIColor) {
        etiqueta.text = titulo
        self.color = color
       //etiqueta.textColor = color
        etiqueta.layer.borderColor = color.cgColor
        
        estadoActual = posiblesEstados.blanco
    }
    
    func cambiarEstado(estado : posiblesEstados) {
        estadoActual = estado
        switch estado {
        case .equivocado:
            etiqueta.layer.borderColor = #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1).cgColor
            etiqueta.backgroundColor = #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1)
        case .acertado:
            etiqueta.layer.borderColor = #colorLiteral(red: 0.1906670928, green: 0.9801233411, blue: 0.474581778, alpha: 1).cgColor
            etiqueta.backgroundColor = #colorLiteral(red: 0.1906670928, green: 0.9801233411, blue: 0.474581778, alpha: 1)
        default://.blanco
            print("Estado no de celda de opcion respuesta reconocido")
        }
        etiqueta.textColor = UIColor.white
    }
    
}
