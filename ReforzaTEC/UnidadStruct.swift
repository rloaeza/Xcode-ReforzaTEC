

import Foundation

struct UnidadStruct {
    var nombre: String?
    var descripcion: String?
    var numero: Int
    var expanded: Bool = false
    var contenido: [String] = []
    
    init(nombre: String?, descripcion: String?, numero: Int) {
        self.nombre = nombre
        self.descripcion = descripcion
        self.numero = numero
    }
    
}

