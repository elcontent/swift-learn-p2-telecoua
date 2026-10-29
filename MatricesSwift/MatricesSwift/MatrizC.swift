//
//  MatrizC.swift
//  MatricesSwift
//
//  Created by Jordi Sellés Enríquez on 29/10/2026.
//

import Foundation

class MatrizC: Matriz {
    
    // MARK: - Inicializadores
    
    init(orden: Int) {
        super.init(filas: orden, columnas: orden)
    }
    
    init(orden: Int, valorInicial: Int) {
        super.init(filas: orden, columnas: orden, valorInicial: valorInicial)
    }
    
    init?(copiaDe otra: MatrizC) {
        guard !otra.esNula,
              otra.filas == otra.columnas else {
            return nil
        }
        
        super.init(copiaDe: otra)
    }
    
    // MARK: - Constructores especiales
    
    static func zeros(orden: Int) -> MatrizC {
        return MatrizC(orden: orden, valorInicial: 0)
    }
    
    
}
