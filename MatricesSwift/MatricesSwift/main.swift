import Foundation

// MARK: - Referencias

let matriz1 = Matriz(filas: 2, columnas: 2)

// Establecemos un valor conocido
precondition(matriz1.establecerValor(10, fila: 0, columna: 0))

// Copiamos la referencia
let matriz2 = matriz1

// Creamos una copia independiente
let matriz3 = Matriz(copiaDe: matriz1)

// Modificamos la matriz mediante matriz2
precondition(matriz2.establecerValor(99, fila: 0, columna: 0))

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


// MARK: - Pruebas de operaciones

// Crear una matriz con valores conocidos, en lugar de aleatorios.
func matrizDesde(_ valores: [[Int]]) -> Matriz {
    guard let primeraFila = valores.first, !primeraFila.isEmpty else {
        return Matriz()
    }

    let resultado = Matriz.zeros(filas: valores.count, columnas: primeraFila.count)
    for (fila, valoresFila) in valores.enumerated() {
        precondition(valoresFila.count == primeraFila.count)
        for (columna, valor) in valoresFila.enumerated() {
            precondition(resultado.establecerValor(valor, fila: fila, columna: columna))
        }
    }
    return resultado
}

// Verificar dimensiones y contenido de una matriz calculada.
func comprobar(_ actual: Matriz, esIgualA esperado: [[Int]]) {
    precondition(actual.filas == esperado.count)
    precondition(actual.columnas == (esperado.first?.count ?? 0))
    for (fila, valoresFila) in esperado.enumerated() {
        for (columna, valor) in valoresFila.enumerated() {
            precondition(actual.valor(fila: fila, columna: columna) == valor)
        }
    }
}

let a = matrizDesde([[1, 2, 3], [4, 5, 6]])
let b = matrizDesde([[7, 8], [9, 10], [11, 12]])
let c = matrizDesde([[6, 5, 4], [3, 2, 1]])

comprobar(a + c, esIgualA: [[7, 7, 7], [7, 7, 7]])
comprobar(a - c, esIgualA: [[-5, -3, -1], [1, 3, 5]])
comprobar(a * b, esIgualA: [[58, 64], [139, 154]])
comprobar(b * a, esIgualA: [[39, 54, 69], [49, 68, 87], [59, 82, 105]])
comprobar(a * 2, esIgualA: [[2, 4, 6], [8, 10, 12]])

precondition((a * a).esNula)
precondition((a + b).esNula)
precondition(Matriz.zeros(filas: -1, columnas: 3).esNula)

print("\nPruebas de operaciones superadas")
