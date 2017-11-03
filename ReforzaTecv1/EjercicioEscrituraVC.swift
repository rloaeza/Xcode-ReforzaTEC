//
//  EjercicioEscrituraVC.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 11/3/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import UIKit

class EjercicioEscrituraVC: UIViewController {
    
    var color: UIColor!
    
    @IBOutlet weak var BotonRevisar: UIButton!
    @IBOutlet weak var preguntaTextView: UITextView!
    @IBOutlet weak var EntradaField: UITextField!
    @IBOutlet weak var CalificacionImagenView: UIImageView!
    
    @IBOutlet weak var AlturaDeImagenConstraint: NSLayoutConstraint!
    
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
        
        // ocultando la imagen de la calificacion
        AlturaDeImagenConstraint.constant = 0
        CalificacionImagenView.alpha = 0
        
    }
    // MARK: - Navigation

    @objc func accionDelBoton(sender: UIButton){
        let titulo = sender.title(for: .normal)!
        switch(titulo){
            case "Revisar":
                revisarEjercicio()
            case "Siguiente":
                siguienteEjercicio()
            default:
                print("Wow, titulo desconocido para el boton")
        }
    
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueVoz"){
            let vc = segue.destination as! EjercicioVozVC
            vc.color = self.color
        }
        
    }
    
    func revisarEjercicio(){
        UIView.animate(withDuration: 0.5, animations: {
            self.AlturaDeImagenConstraint.constant = 64
            self.CalificacionImagenView.alpha = 1
            self.BotonRevisar.setTitle("Siguiente", for: .normal)
        })
        
    }
    
    func siguienteEjercicio() {
        performSegue(withIdentifier: "segueVoz", sender: self)
    }

}
