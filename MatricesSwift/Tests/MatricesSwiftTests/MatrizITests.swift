import Testing
@testable import MatricesSwift

@Suite("MatrizI: identidad, construcción y preservación")
struct MatrizITests {

    // MARK: - Ayudas deterministas

    private func matriz(_ valores: [[Int]]) -> Matriz {
        guard let primera = valores.first, !primera.isEmpty else {
            return Matriz()
        }

        let m = Matriz.zeros(filas: valores.count, columnas: primera.count)
        for (fila, elementos) in valores.enumerated() {
            precondition(elementos.count == primera.count)
            for (columna, elemento) in elementos.enumerated() {
                precondition(m.establecerValor(elemento, fila: fila, columna: columna))
            }
        }
        return m
    }

    private func coincide(_ actual: Matriz, _ valores: [[Int]]) -> Bool {
        guard let primera = valores.first, !primera.isEmpty else {
            return actual.esNula && actual.filas == 0 && actual.columnas == 0
        }
        guard actual.filas == valores.count, actual.columnas == primera.count else {
            return false
        }
        for (fila, elementos) in valores.enumerated() {
            guard elementos.count == primera.count else { return false }
            for (columna, elemento) in elementos.enumerated() {
                guard actual.valor(fila: fila, columna: columna) == elemento else {
                    return false
                }
            }
        }
        return true
    }

    private func identidadDeTres() -> Matriz {
        matriz([
            [1, 0, 0],
            [0, 1, 0],
            [0, 0, 1]
        ])
    }

    // MARK: - Inicializadores

    @Test("La identidad construida es correcta para diversos órdenes y generaciones")
    func construccionPorOrden() {
        for orden in [1, 2, 3, 4, 6, 9] {
            for _ in 0..<12 {
                let identidad = MatrizI(orden: orden)
                #expect(identidad.filas == orden)
                #expect(identidad.columnas == orden)
                #expect(MatrizI.esIdentidad(identidad))
                #expect(identidad.esPermutacion())
                for fila in 0..<orden {
                    for columna in 0..<orden {
                        #expect(identidad.valor(fila: fila, columna: columna) ==
                                (fila == columna ? 1 : 0))
                    }
                }
            }
        }
    }

    @Test("El constructor por defecto produce matriz nula")
    func constructorPorDefecto() {
        let identidad = MatrizI()
        #expect(identidad.esNula)
        #expect(identidad.filas == 0)
        #expect(identidad.columnas == 0)
        #expect(!MatrizI.esIdentidad(identidad))
    }

    @Test("Los órdenes no positivos producen la matriz nula prevista")
    func ordenNoPositivo() {
        for orden in [0, -1, -4] {
            let identidad = MatrizI(orden: orden)
            #expect(identidad.esNula)
            #expect(identidad.filas == 0)
            #expect(identidad.columnas == 0)
            #expect(!MatrizI.esIdentidad(identidad))
        }
    }

    // MARK: - Comprobador estático

    @Test("esIdentidad acepta una identidad genérica de orden uno y tres")
    func aceptaIdentidadesGenericas() {
        #expect(MatrizI.esIdentidad(matriz([[1]])))
        #expect(MatrizI.esIdentidad(identidadDeTres()))
        #expect(MatrizI.esIdentidad(MatrizI(orden: 5)))
    }

    @Test("esIdentidad rechaza matrices nulas y rectangulares")
    func rechazaDimensiones() {
        #expect(!MatrizI.esIdentidad(Matriz()))
        #expect(!MatrizI.esIdentidad(matriz([[1, 0, 0], [0, 1, 0]])))
        #expect(!MatrizI.esIdentidad(matriz([[1, 0], [0, 1], [0, 0]])))
    }

    @Test("esIdentidad rechaza permutaciones que no tienen todos los unos en diagonal")
    func rechazaPermutacionesNoIdentidad() {
        #expect(!MatrizI.esIdentidad(matriz([
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 0]
        ])))
        #expect(!MatrizI.esIdentidad(matriz([[0, 1], [1, 0]])))
    }

    @Test("esIdentidad rechaza valores distintos de cero y uno y matrices de ceros")
    func rechazaContenidosInvalidos() {
        #expect(!MatrizI.esIdentidad(matriz([[0]])))
        #expect(!MatrizI.esIdentidad(matriz([[2]])))
        #expect(!MatrizI.esIdentidad(matriz([[-1, 0], [0, 1]])))
        #expect(!MatrizI.esIdentidad(matriz([[1, 0], [0, 2]])))
        #expect(!MatrizI.esIdentidad(matriz([[1, 1], [0, 1]])))
        #expect(!MatrizI.esIdentidad(matriz([[0, 0], [0, 0]])))
    }

    // MARK: - Conversión y copia

    @Test("La conversión de Matriz genérica copia una identidad válida")
    func conversionDesdeMatriz() throws {
        let original = identidadDeTres()
        let identidad = try #require(MatrizI(desde: original))
        #expect(MatrizI.esIdentidad(identidad))
        #expect(identidad == original)
        #expect(identidad !== original)
        #expect(original.establecerValor(9, fila: 0, columna: 0))
        #expect(MatrizI.esIdentidad(identidad))
        #expect(coincide(identidad, [[1, 0, 0], [0, 1, 0], [0, 0, 1]]))
    }

    @Test("La conversión de MatrizC válida funciona")
    func conversionDesdeMatrizC() throws {
        let cuadrada = MatrizC.zeros(orden: 3)
        for indice in 0..<3 {
            #expect(cuadrada.establecerValor(1, fila: indice, columna: indice))
        }
        let identidad = try #require(MatrizI(desde: cuadrada))
        #expect(MatrizI.esIdentidad(identidad))
        #expect(identidad !== cuadrada)
    }

    @Test("La conversión desde una MatrizP identidad funciona")
    func conversionDesdeMatrizP() throws {
        let permutacion = try #require(MatrizP(desde: identidadDeTres()))
        let identidad = try #require(MatrizI(desde: permutacion))
        #expect(MatrizI.esIdentidad(identidad))
        #expect(identidad !== permutacion)
    }

    @Test("La conversión failable rechaza matrices que no son identidades")
    func conversionInvalida() {
        #expect(MatrizI(desde: Matriz()) == nil)
        #expect(MatrizI(desde: matriz([[0]])) == nil)
        #expect(MatrizI(desde: matriz([[1, 0, 0], [0, 1, 0]])) == nil)
        #expect(MatrizI(desde: matriz([[0, 1], [1, 0]])) == nil)
        #expect(MatrizI(desde: matriz([[2, 0], [0, 1]])) == nil)
    }

    @Test("El constructor de copia genera una instancia independiente")
    func constructorCopia() {
        let original = MatrizI(orden: 4)
        let copia = MatrizI(copiaDe: original)
        #expect(copia == original)
        #expect(copia !== original)
        #expect(MatrizI.esIdentidad(copia))
        #expect(copia.filas == 4)
    }

    @Test("Copiar una identidad nula preserva el estado nulo")
    func copiaNula() {
        let original = MatrizI()
        let copia = MatrizI(copiaDe: original)
        #expect(copia.esNula)
        #expect(copia !== original)
        #expect(!MatrizI.esIdentidad(copia))
    }

    // MARK: - Invariante y polimorfismo

    @Test("establecerValor protege la identidad incluso mediante referencia Matriz")
    func protegeEscrituras() {
        let identidad = MatrizI(orden: 3)
        let general: Matriz = identidad
        #expect(general.establecerValor(1, fila: 0, columna: 0))
        #expect(general.establecerValor(0, fila: 0, columna: 1))
        #expect(!general.establecerValor(0, fila: 0, columna: 0))
        #expect(!general.establecerValor(1, fila: 0, columna: 1))
        #expect(!general.establecerValor(7, fila: 2, columna: 2))
        #expect(!general.establecerValor(1, fila: -1, columna: 0))
        #expect(!general.establecerValor(0, fila: 0, columna: 3))
        #expect(MatrizI.esIdentidad(identidad))
    }

    @Test("Intercambiar filas o columnas diferentes se rechaza sin alterar la identidad")
    func intercambiosDistintos() {
        let identidad = MatrizI(orden: 4)
        #expect(!identidad.intercambiarFilas(0, 1))
        #expect(!identidad.intercambiarFilas(1, 3))
        #expect(!identidad.intercambiarColumnas(0, 2))
        #expect(!identidad.intercambiarColumnas(2, 3))
        #expect(MatrizI.esIdentidad(identidad))
        #expect(identidad == MatrizI(orden: 4))
    }

    @Test("Intercambiar el mismo índice es válido y no modifica la identidad")
    func intercambiosIdenticos() {
        let identidad = MatrizI(orden: 4)
        #expect(identidad.intercambiarFilas(0, 0))
        #expect(identidad.intercambiarFilas(3, 3))
        #expect(identidad.intercambiarColumnas(1, 1))
        #expect(identidad.intercambiarColumnas(3, 3))
        #expect(MatrizI.esIdentidad(identidad))
    }

    @Test("Los índices de intercambio fuera de rango son rechazados")
    func intercambiosIndicesInvalidos() {
        let identidad = MatrizI(orden: 3)
        #expect(!identidad.intercambiarFilas(-1, -1))
        #expect(!identidad.intercambiarFilas(3, 3))
        #expect(!identidad.intercambiarFilas(0, 3))
        #expect(!identidad.intercambiarColumnas(-1, 0))
        #expect(!identidad.intercambiarColumnas(3, 3))
        #expect(!identidad.intercambiarColumnas(0, 3))
        #expect(MatrizI.esIdentidad(identidad))
    }

    @Test("La referencia MatrizP utiliza los overrides de MatrizI")
    func polimorfismoEnIntercambios() {
        let identidad = MatrizI(orden: 3)
        let permutacion: MatrizP = identidad
        #expect(!permutacion.intercambiarFilas(0, 1))
        #expect(!permutacion.intercambiarColumnas(0, 2))
        #expect(permutacion.intercambiarFilas(2, 2))
        #expect(permutacion.intercambiarColumnas(1, 1))
        #expect(MatrizI.esIdentidad(identidad))
    }
}
