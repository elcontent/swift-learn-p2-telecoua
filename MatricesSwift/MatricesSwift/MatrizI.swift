//
//  MatrizI.swift
//  MatricesSwift
//
//  Created by Jordi Sellés Enríquez on 29/10/2026.
//

import Foundation

class MatrizI: MatrizP {
    
    // MARK: - Inicializadores
    
    override init() {
        super.init()
    }
    
    init(copiaDe otra: MatrizI) {
        super.init(copiaDe: otra)
    }
    
    override init?(desde otra: Matriz) {
        guard MatrizI.esIdentidad(otra) else {
            return nil
        }
        
        super.init(desde: otra)
    }
    
    override init(orden: Int) {

        // Construimos una permutación válida
        super.init(orden: orden)

        guard orden > 0 else {
            return
        }

        for diagonal in 0..<orden {

            // ¿Ya tenemos el 1 en la posición correcta?
            if valor(fila: diagonal, columna: diagonal) == 1 {
                continue
            }

            // Buscamos la fila que contiene el 1 de esta columna
            for siguiente in (diagonal + 1)..<orden {

                if valor(fila: siguiente, columna: diagonal) == 1 {

                    // Intercambio controlado utilizando MatrizP
                    _ = super.intercambiarFilas(diagonal, siguiente)
                    break
                }
            }
        }
    }
    
    // MARK: - Comprobadores
    
    static func esIdentidad(_ otra: Matriz) -> Bool {
        
        // Tiene que ser matriz de permutación para poder ser de identidad.
        // Por lo tanto, confiamos en este método para ampliarlo en esIdentidad
        guard MatrizP.esPermutacion(otra) else {
            return false
        }
        
        for iter in 0..<otra.columnas {
            guard otra.valor(fila: iter, columna: iter) == 1 else {
                return false
            }
        }
        
        return true
    }
    
    // MARK: - Métodos
    
    override func intercambiarFilas(_ origen: Int, _ destino: Int) -> Bool {

        guard (0..<filas).contains(origen),
              (0..<filas).contains(destino) else {
            return false
        }

        return origen == destino
    }
    
    override func intercambiarColumnas(_ origen: Int, _ destino: Int) -> Bool {
        
        guard (0..<columnas).contains(origen),
              (0..<columnas).contains(destino) else {
            return false
        }
        
        return origen == destino
    }
    
}
