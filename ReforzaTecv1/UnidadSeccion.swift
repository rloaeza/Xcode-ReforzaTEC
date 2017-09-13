//
//  SeccionUnidad.swift
//  ReforzaTecv1
//
//  Created by Delfin: Verano Científico on 26/07/17.
//  Copyright © 2017 TecUruapan. All rights reserved.
//

import Foundation

struct UnidadSeccion {
    var nombreUnidad : String?
    var numeroUnidad : Int!
    
    var expanded : Bool
    
    let material : [String] = ["Teoria", "Ejemplos", "Ejercicios", "Evaluación"]
    
    init(_ nombreUnidad : String?, numeroUnidad : Int, expanded : Bool) {
        if let nom = nombreUnidad {
            self.nombreUnidad = nom
        }
        self.numeroUnidad = numeroUnidad
        self.expanded = expanded
    }
    
}

