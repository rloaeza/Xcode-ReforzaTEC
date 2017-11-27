//
//  PreguntaEvaluacionTVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 11/13/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit
// bug con el borde inferior del textfield, no se muestra
class PreguntaATVC: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var PreguntaL: UILabel!
    @IBOutlet weak var RespuestaTF: UITextField!
    
    var color:  UIColor!
    var respuesta: String!
    var indiceDataSource: Int!
    weak var delegate: GuardarDatosProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RespuestaTF.setBottomBorder()
        RespuestaTF.tintColor = color
        RespuestaTF.delegate = self
        
    }
    // implementando el delegado del textfield para ocultar el teclado al presionar la tecla de 'Done'
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let text = RespuestaTF.text ??  ""
        delegate?.guardar(respuestAbierta: text, en: indiceDataSource)
    }
    // compara la respeusta del usuario con la repsuesta correcta, les
    //pone color verde si estan bien y rojo si estan mal
    // devuelve true si es correcta
    func revisar() ->Bool{
        let entrada = RespuestaTF.text ?? ""
        let esCorrecto: Bool = respuesta.caseInsensitiveCompare(entrada) == ComparisonResult.orderedSame
        if(esCorrecto) {
            RespuestaTF.textColor = UIColor.green
        }else{
            RespuestaTF.textColor = UIColor.red
//            let estilos = RespuestaTF.textStyling(at: RespuestaTF.beginningOfDocument, in: .forward)
//            estilos
            
        }
        
     return esCorrecto
    }
}

