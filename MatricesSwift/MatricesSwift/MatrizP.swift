//
//  MatrizP.swift
//  MatricesSwift
//
//  Created by Jordi Sellés Enríquez on 29/10/2026.
//

import Foundation

class MatrizP: MatrizC {
    
    // MARK: - Inicializadores
    
    init(copiaDe otra: MatrizP) {
        super.init(copiaDe: otra)
    }
    
    override init?(desde otra: Matriz) {
        guard MatrizP.esPermutacion(otra) else {
            return nil
        }
        
        super.init(desde: otra)
    }
    
    override init(orden: Int) {
        
        // Construimos una matriz cuadrada de ceros
        super.init(orden: orden, valorInicial: 0)

        // Si el orden no es válido, conservamos la matriz nula
        guard orden > 0 else {
            return
        }
        
        // Generamos una permutación aleatoria de columnas
        let columnas = Array(0..<orden).shuffled()
        
        for fila in 0..<orden {
            _ = super.establecerValor(1, fila: fila, columna: columnas[fila])
        }
    }
    
    // MARK: - Comprobadores
    
    static func esPermutacion(_ otra: Matriz) -> Bool {
        guard !otra.esNula, otra.filas == otra.columnas else {
            return false
        }
        
        var unosEnColumnas = Array(
            repeating: 0, count: otra.columnas)
        
        for fila in 0..<otra.filas {
            var unosEnFila = 0
            
            for columna in 0..<otra.columnas {
                guard let elemento = otra.valor(fila: fila, columna: columna),
                      elemento == 0 || elemento == 1 else {
                    return false
                }
                
                if elemento == 1 {
                    unosEnFila += 1
                    unosEnColumnas[columna] += 1
                }
            }
            
            // Cada fila debe contener solo un 1
            guard unosEnFila == 1 else {
                return false
            }
        }
        
        // Cada columna debe contener solo un 1
        for cantidad in unosEnColumnas {
            guard cantidad == 1 else {
                return false
            }
        }
        return true
    }
    
    func esPermutacion() -> Bool {
        return MatrizP.esPermutacion(self)
    }
    
    // MARK: - Métodos
    
    override func establecerValor(_ valor: Int, fila: Int, columna: Int) -> Bool {
        
        guard let valorActual = self.valor(fila: fila, columna: columna) else {
            return false
        }
        
        guard valorActual == valor else {
            return false
        }
        
        return true
    }
    
    func intercambiarFilas(_ origen: Int, _ destino: Int) -> Bool {
        
        guard (0..<filas).contains(origen),
              (0..<filas).contains(destino) else {
            return false
        }
        
        guard origen != destino else {
            return true
        }
        
        for columna in 0..<columnas {
            
            guard let valorOrigen = valor(fila: origen, columna: columna),
                  let valorDestino = valor(fila: destino, columna: columna) else {
                return false
            }
            
            _ = super.establecerValor(valorDestino, fila: origen, columna: columna)
            _ = super.establecerValor(valorOrigen, fila: destino, columna: columna)
        }
        return true
    }
    
    func intercambiarColumnas(_ origen: Int, _ destino: Int) -> Bool {
        
        guard (0..<columnas).contains(origen),
              (0..<columnas).contains(destino) else {
            return false
        }
        
        guard origen != destino else {
            return true
        }
        
        for fila in 0..<filas {
            
            guard let valorOrigen = valor(fila: fila, columna: origen),
                  let valorDestino = valor(fila: fila, columna: destino) else {
                return false
            }
            
            _ = super.establecerValor(valorDestino, fila: fila, columna: origen)
            _ = super.establecerValor(valorOrigen, fila: fila, columna: destino)
        }
        return true
    }
    
}
