import Testing
@testable import MatricesSwift

@Suite("MatrizC: construcción y comportamiento")
struct MatrizCTests {

    @Test("El inicializador por orden crea una matriz cuadrada aleatoria")
    func inicializadorDeOrden() {
        let cuadrada = MatrizC(orden: 3)

        #expect(cuadrada.filas == 3)
        #expect(cuadrada.columnas == 3)
        #expect(!cuadrada.esNula)

        for fila in 0..<cuadrada.filas {
            for columna in 0..<cuadrada.columnas {
                let valor = cuadrada.valor(fila: fila, columna: columna)
                #expect(valor != nil)
                if let valor {
                    #expect((0...99).contains(valor))
                }
            }
        }
    }

    @Test("El inicializador con valor fija todas las posiciones")
    func inicializadorConValor() {
        let cuadrada = MatrizC(orden: 4, valorInicial: -7)

        #expect(cuadrada.filas == 4)
        #expect(cuadrada.columnas == 4)

        for fila in 0..<cuadrada.filas {
            for columna in 0..<cuadrada.columnas {
                #expect(cuadrada.valor(fila: fila, columna: columna) == -7)
            }
        }
    }

    @Test("zeros(orden:) fabrica una MatrizC rellena de ceros")
    func factoriaDeCeros() {
        let cuadrada = MatrizC.zeros(orden: 3)

        #expect(cuadrada.filas == 3)
        #expect(cuadrada.columnas == 3)

        for fila in 0..<3 {
            for columna in 0..<3 {
                #expect(cuadrada.valor(fila: fila, columna: columna) == 0)
            }
        }
    }

    @Test("Órdenes no positivos crean una matriz nula")
    func ordenesInvalidos() {
        for orden in [0, -1, -4] {
            let aleatoria = MatrizC(orden: orden)
            let constante = MatrizC(orden: orden, valorInicial: 5)
            let ceros = MatrizC.zeros(orden: orden)

            for matriz in [aleatoria, constante, ceros] {
                #expect(matriz.esNula)
                #expect(matriz.filas == 0)
                #expect(matriz.columnas == 0)
            }
        }
    }

    @Test("Equatable compara el contenido y no la identidad")
    func igualdadPorContenido() {
        let a = MatrizC.zeros(orden: 2)
        let b = MatrizC(orden: 2, valorInicial: 0)
        let c = MatrizC(orden: 2, valorInicial: 1)
        let matrizBase = Matriz.zeros(filas: 2, columnas: 2)

        #expect(a == b)
        #expect(a == matrizBase)
        #expect(!(a == c))
        #expect(a !== b)
    }

    @Test("Las operaciones heredadas funcionan sobre matrices cuadradas")
    func operadoresHeredados() {
        let a = MatrizC(orden: 2, valorInicial: 2)
        let b = MatrizC(orden: 2, valorInicial: 3)

        let suma = a + b
        let producto = a * b

        #expect(suma.filas == 2)
        #expect(suma.columnas == 2)
        #expect(producto.filas == 2)
        #expect(producto.columnas == 2)

        for fila in 0..<2 {
            for columna in 0..<2 {
                #expect(suma.valor(fila: fila, columna: columna) == 5)
                #expect(producto.valor(fila: fila, columna: columna) == 12)
                #expect(a.valor(fila: fila, columna: columna) == 2)
                #expect(b.valor(fila: fila, columna: columna) == 3)
            }
        }
    }

    // MARK: - Copia

    @Test("La copia de una MatrizC conserva dimensiones y contenido")
    func copiaDeCuadrada() throws {
        let original = MatrizC(orden: 2, valorInicial: 4)
        #expect(original.establecerValor(9, fila: 0, columna: 1))

        let copia = try #require(MatrizC(copiaDe: original))

        #expect(copia.filas == 2)
        #expect(copia.columnas == 2)
        #expect(copia == original)
        #expect(copia !== original)
        #expect(copia.valor(fila: 0, columna: 0) == 4)
        #expect(copia.valor(fila: 0, columna: 1) == 9)
    }

    @Test("La copia es independiente del objeto original")
    func copiaSinCompartirReferencia() throws {
        let original = MatrizC(orden: 2, valorInicial: 5)
        let copia = try #require(MatrizC(copiaDe: original))

        #expect(copia.establecerValor(99, fila: 1, columna: 1))

        #expect(original.valor(fila: 1, columna: 1) == 5)
        #expect(copia.valor(fila: 1, columna: 1) == 99)
        #expect(original !== copia)
    }

    @Test("El inicializador de copia failable rechaza una MatrizC nula")
    func copiaDeNula() {
        let nula = MatrizC(orden: 0)
        #expect(nula.esNula)
        #expect(MatrizC(copiaDe: nula) == nil)
    }
}
