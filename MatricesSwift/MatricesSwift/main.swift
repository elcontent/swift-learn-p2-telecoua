import Foundation

// MARK: - Referencias

let matriz1 = Matriz(filas: 2, columnas: 2)

// Establecemos un valor conocido
matriz1.establecerValor(10, fila: 0, columna: 0)

// Copiamos la referencia
let matriz2 = matriz1

// Creamos una copia independiente
let matriz3 = Matriz(copiaDe: matriz1)

// Modificamos la matriz mediante matriz2
matriz2.establecerValor(99, fila: 0, columna: 0)

print("MATRICES")
print("--------")

print("Matriz 1:",
      matriz1.valor(fila: 0, columna: 0) ?? -1)

print("Matriz 2:",
      matriz2.valor(fila: 0, columna: 0) ?? -1)

print("Matriz 3:",
      matriz3.valor(fila: 0, columna: 0) ?? -1)

// MARK: - Identidad

print("\nIDENTIDAD")
print("---------")

print("1 y 2 son el mismo objeto:", matriz1 === matriz2)
print("1 y 3 son el mismo objeto:", matriz1 === matriz3)

// MARK: - Estructuras

struct Punto {
    var x: Int
    var y: Int
}

let punto1 = Punto(x: 10, y: 20)
var punto2 = punto1

punto2.x = 99

print("\nESTRUCTURAS")
print("-----------")

print("Punto 1:", punto1.x)
print("Punto 2:", punto2.x)

