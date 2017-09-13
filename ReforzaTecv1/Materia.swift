//
//  Materia.swift
//  ReforzaTecv1
//
//  Created by Omar Rico on 7/17/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import Foundation
import UIKit.UIColor


class Materia: NSObject {
        //201.134.65.227  die schule
    // das haus http://172.16.107.1/reforzatec/reforzatec.php?Actividad=1
     static let  direccion : String  = "http://172.16.107.1/reforzatec/reforzatec.php?Actividad=1"
        let mNombre : String
        let mDescripcion : String?
        var mColor : UIColor
    
    init(nombre : String, descripcion : String?) {
        mNombre = nombre
        if let d = descripcion {
            mDescripcion = d
        }else {
            mDescripcion = ""
        }
        
        mColor = Utils.colorHash(nombre)
    }
    
    
    
    
    static func  llenarConEjemplos () -> [Materia] {
        var materiasDescargadas : [Materia] = []
        
        materiasDescargadas.append(Materia(nombre: "Ciencias", descripcion: "Aqui podras apredner los secretos de la lengua espanola asi como inglesa. lengua espanola asi como inglesa.lengua espanola asi como inglesa.lengua espanola asi como inglesa.lengua espanola asi como inglesa.vargua espanola asi como inglesa.lengua espanola asi como inglesa.lengua espanola asi como inglesa.lengua espanola asi como inglesa. lengua espanola asi como inglesa."))
        materiasDescargadas.append(Materia(nombre: "Espanol", descripcion: "Aqui podras apredner los secretos de la lengua espanola asi como inglesa."))
        materiasDescargadas.append(Materia(nombre: "Educasion inglesa", descripcion: "Por que existe esta materia?!?!"))
        materiasDescargadas.append(Materia(nombre: "Vuelo", descripcion: nil))
        materiasDescargadas.reverse()
        
        return materiasDescargadas
    }
    
    static func ejemplos () {
        var materiasDescargadas : [Materia] = []
        materiasDescargadas.append(Materia(nombre: "Matematicas", descripcion: "Aqui podras apredner los secretos de la lengua espanola asi como inglesa."))
        materiasDescargadas.append(Materia(nombre: "Redes", descripcion: "Por que existe esta materia?!?!"))
        materiasDescargadas.append(Materia(nombre: "Defensa Personal", descripcion: nil))
        materiasDescargadas.append(Materia(nombre: "Fisica ll", descripcion: "Todo lo que puedas esperar de la fisica."))
        materiasDescargadas.append(Materia(nombre: "Conjuros 1", descripcion: "Aprende a realizar conjuros y encantamientos de todo nivel. Busquen sus nuevos libros en la biblioteca por favor!"))
        materiasDescargadas.append(Materia(nombre:"Lorem Ipsum", descripcion : "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."))
        return    materiasDescargadas.reverse()
        
    }

    
    
}
