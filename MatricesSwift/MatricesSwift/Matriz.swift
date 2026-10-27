
//
//  Matriz.swift
//  MatricesSwift
//
//  Created by Jordi Sellés Enríquez on 27/10/2026.
//

import Foundation

class Matriz {

    // MARK: - Propiedades

    let filas: Int
    let columnas: Int

    private var elementos: [[Int]]

    // MARK: - Propiedades calculadas

    var esNula: Bool {
        return filas == 0 && columnas == 0
    }

    // MARK: - Inicializadores

    // Inicializador por defecto: matriz nula (0x0)
    init() {
        self.filas = 0
        self.columnas = 0
        self.elementos = []
    }

    // Inicializador con dimensiones y valores aleatorios
    init(filas: Int, columnas: Int) {
        guard filas > 0 && columnas > 0 else {
            self.filas = 0
            self.columnas = 0
            self.elementos = []
            return
        }

        self.filas = filas
        self.columnas = columnas

        self.elementos = Array(
            repeating: Array(repeating: 0, count: columnas),
            count: filas
        )

        for fila in 0..<filas {
            for columna in 0..<columnas {
                elementos[fila][columna] = Int.random(in: 0...99)
            }
        }
    }

    // Inicializador de copia independiente
    init(copiaDe original: Matriz) {
        self.filas = original.filas
        self.columnas = original.columnas
        self.elementos = original.elementos
    }

    // MARK: - Acceso a elementos

    // Obtener el valor de una posición
    func valor(fila: Int, columna: Int) -> Int? {
        guard fila >= 0, fila < filas,
              columna >= 0, columna < columnas else {
            return nil
        }

        return elementos[fila][columna]
    }

    // Modificar el valor de una posición
    // Devuelve false si la posición no existe
    func establecerValor(
        _ valor: Int,
        fila: Int,
        columna: Int
    ) -> Bool {
        guard fila >= 0, fila < filas,
              columna >= 0, columna < columnas else {
            return false
        }

        elementos[fila][columna] = valor
        return true
    }

    // MARK: - Validaciones

    // Comprobar compatibilidad para suma y resta
    func esCompatibleParaSuma(_ otra: Matriz) -> Bool {
        guard !esNula && !otra.esNula else {
            return false
        }

        return filas == otra.filas &&
               columnas == otra.columnas
    }

    // MARK: - Operaciones aritméticas

    // Pendiente:
    // - Suma de matrices (+)
    // - Resta de matrices (-)
    // - Producto de matrices (*)
    // - Producto por escalar (*)
    // - Operadores compuestos (+=, -=, *=)
    // - Igualdad (==)
    
    static func + (lhs: Matriz, rhs: Matriz) -> Matriz {

        // Comprobamos que las matrices sean compatibles
        guard lhs.esCompatibleParaSuma(rhs) else {
            return Matriz()
        }

        // Creamos la matriz que contendrá el resultado
        let resultado = Matriz(
            filas: lhs.filas,
            columnas: lhs.columnas
        )

        // Sumamos los elementos de ambas matrices
        for fila in 0..<lhs.filas {
            for columna in 0..<lhs.columnas {
                resultado.elementos[fila][columna] =
                    lhs.elementos[fila][columna] +
                    rhs.elementos[fila][columna]
            }
        }

        return resultado
    }
    
    static func - (lhs: Matriz, rhs: Matriz) -> Matriz {
        
        // Comprobamos que las matrices sean compatibles
        guard lhs.esCompatibleParaSuma(rhs) else {
            return Matriz()
        }
        
        // Creamos la matriz que contendrá el resultado
        let resultado = Matriz(
            filas: lhs.filas,
            columnas: lhs.columnas
        )
        
        // Restamos los elementos de ambas matrices
        for fila in 0..<lhs.filas {
            for columna in 0..<lhs.columnas {
                resultado.elementos[fila][columna] =
                    lhs.elementos[fila][columna] -
                    rhs.elementos[fila][columna]
            }
        }
        
        return resultado
    }


    // MARK: - Representación

    // Mostrar la matriz por consola
    func mostrar() {
        guard !esNula else {
            print("MATRIZ NULA")
            return
        }

        for fila in elementos {
            for valor in fila {
                print(valor, terminator: "\t")
            }
            print()
        }
    }
}
