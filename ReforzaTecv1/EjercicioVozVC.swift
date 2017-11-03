//
//  EjercicioVozVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 11/3/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

class EjercicioVozVC: UIViewController {
    
    @IBOutlet weak var PretuntaTextView: UITextView!
    @IBOutlet weak var BotonRevisar: UIButton!
    @IBOutlet weak var BotonMicrofono: UIButton!
    @IBOutlet weak var EntradaField: UITextField!
    
    @IBOutlet weak var CalificacionImagenView: UIImageView!
    @IBOutlet weak var AlturaDeImagenConstraint: NSLayoutConstraint!
    
    var color: UIColor! = UIColor.cyan

    override func viewDidLoad() {
        super.viewDidLoad()

        // iniciando boton
        BotonRevisar.backgroundColor = UIColor.white
        BotonRevisar.addTarget(self, action: #selector(accionDelBoton), for: .touchDown)
        BotonRevisar.layer.cornerRadius = 10
        BotonRevisar.layer.borderWidth = 1.5
        BotonRevisar.layer.borderColor = color.cgColor
        BotonRevisar.setTitleColor( #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1), for: .disabled)
        BotonRevisar.isEnabled = true
        
        // Ocultando la imagen
        AlturaDeImagenConstraint.constant = 0
        CalificacionImagenView.alpha = 0
        
    }
    
    @objc func accionDelBoton(sender: UIButton) {
        let titulo = sender.title(for: .normal)!
        switch titulo {
        case "Revisar":
            revisarEjercicio()
        case "Siguiente":
            siguienteEjercicio()
        default:
            print("Wow titulo desconocido")
        }
    }
    @IBAction func MuteMicrofono(_ sender: Any) {
        print("No mas ejercicios de voz en un rato")
    }
    
    func revisarEjercicio() {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.AlturaDeImagenConstraint.constant = 64
            self.CalificacionImagenView.alpha = 1
            self.BotonRevisar.setTitle("Siguiente", for: .normal)
        })
    }
    
    func siguienteEjercicio() {
        print("Luego que?")
    }
    
    
}
