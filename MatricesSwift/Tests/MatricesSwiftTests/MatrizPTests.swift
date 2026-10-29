import Testing
@testable import MatricesSwift

@Suite("MatrizP: permutaciones e invariantes")
struct MatrizPTests {

    // MARK: - Ayudas para pruebas deterministas

    /// Construye una Matriz de enteros sin valores aleatorios.
    private func matriz(_ filas: [[Int]]) -> Matriz {
        guard let primera = filas.first, !primera.isEmpty else {
            return Matriz()
        }

        let resultado = Matriz.zeros(filas: filas.count, columnas: primera.count)
        for (fila, valores) in filas.enumerated() {
            precondition(valores.count == primera.count, "Las filas deben tener la misma longitud")
            for (columna, valor) in valores.enumerated() {
                precondition(resultado.establecerValor(valor, fila: fila, columna: columna))
            }
        }
        return resultado
    }

    /// Verifica contenido y dimensiones, sin depender de la representación por consola.
    private func contiene(_ actual: Matriz, _ esperado: [[Int]]) -> Bool {
        guard let primera = esperado.first, !primera.isEmpty else {
            return actual.esNula && actual.filas == 0 && actual.columnas == 0
        }
        guard actual.filas == esperado.count,
              actual.columnas == primera.count else {
            return false
        }
        for (fila, valores) in esperado.enumerated() {
            guard valores.count == primera.count else { return false }
            for (columna, valor) in valores.enumerated() {
                guard actual.valor(fila: fila, columna: columna) == valor else {
                    return false
                }
            }
        }
        return true
    }

    private func permutacionEjemplo() throws -> MatrizP {
        let origen = matriz([
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 0]
        ])
        return try #require(MatrizP(desde: origen))
    }

    // MARK: - Construcción y validación

    @Test("El constructor aleatorio genera permutaciones válidas de varios órdenes")
    func constructorAleatorio() {
        for orden in [1, 2, 3, 5, 8] {
            for _ in 0..<8 {
                let resultado = MatrizP(orden: orden)
                #expect(resultado.filas == orden)
                #expect(resultado.columnas == orden)
                #expect(resultado.esPermutacion())
                #expect(MatrizP.esPermutacion(resultado))
            }
        }
    }

    @Test("Órdenes cero o negativos conservan la matriz nula prevista")
    func constructorOrdenInvalido() {
        for orden in [0, -1, -3] {
            let resultado = MatrizP(orden: orden)
            #expect(resultado.esNula)
            #expect(resultado.filas == 0)
            #expect(resultado.columnas == 0)
            #expect(!resultado.esPermutacion())
        }
    }

    @Test("El comprobador acepta matrices de permutación, incluidas las 1×1")
    func validadorAceptaPermutaciones() {
        #expect(MatrizP.esPermutacion(matriz([[1]])))
        #expect(MatrizP.esPermutacion(matriz([
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 0]
        ])))
        #expect(MatrizP.esPermutacion(matriz([
            [1, 0, 0],
            [0, 1, 0],
            [0, 0, 1]
        ])))
    }

    @Test("El comprobador rechaza matrices nulas y rectangulares")
    func validadorRechazaDimensiones() {
        #expect(!MatrizP.esPermutacion(Matriz()))
        #expect(!MatrizP.esPermutacion(matriz([[1, 0, 0], [0, 1, 0]])))
        #expect(!MatrizP.esPermutacion(matriz([[1, 0], [0, 1], [0, 0]])))
    }

    @Test("El comprobador rechaza ceros, valores distintos de 0/1 y unos repetidos")
    func validadorRechazaContenido() {
        #expect(!MatrizP.esPermutacion(matriz([[0, 0], [0, 0]])))
        #expect(!MatrizP.esPermutacion(matriz([[1, 0], [0, 2]])))
        #expect(!MatrizP.esPermutacion(matriz([[-1, 0], [0, 1]])))
        #expect(!MatrizP.esPermutacion(matriz([[1, 1], [0, 0]])))
        #expect(!MatrizP.esPermutacion(matriz([[1, 0], [1, 0]])))
        #expect(!MatrizP.esPermutacion(matriz([[1, 1, 0], [0, 0, 1], [0, 0, 0]])))
    }

    // MARK: - Conversiones y copias

    @Test("La conversión desde Matriz admite una permutación válida y copia sus datos")
    func conversionValida() throws {
        let origen = matriz([
            [0, 1, 0],
            [1, 0, 0],
            [0, 0, 1]
        ])
        let resultado = try #require(MatrizP(desde: origen))
        #expect(resultado.esPermutacion())
        #expect(resultado == origen)
        #expect(resultado !== origen)
        #expect(contiene(resultado, [[0, 1, 0], [1, 0, 0], [0, 0, 1]]))
    }

    @Test("La conversión falla si las dimensiones o el contenido no son válidos")
    func conversionInvalida() {
        #expect(MatrizP(desde: Matriz()) == nil)
        #expect(MatrizP(desde: matriz([[1, 0, 0], [0, 1, 0]])) == nil)
        #expect(MatrizP(desde: matriz([[0, 0], [0, 0]])) == nil)
        #expect(MatrizP(desde: matriz([[1, 1], [0, 0]])) == nil)
        #expect(MatrizP(desde: matriz([[1, 0], [0, 9]])) == nil)
    }

    @Test("La copia de MatrizP mantiene contenido, tipo e identidad independiente")
    func constructorCopia() throws {
        let original = try permutacionEjemplo()
        let copia = MatrizP(copiaDe: original)
        #expect(copia.esPermutacion())
        #expect(copia == original)
        #expect(copia !== original)
        #expect(contiene(copia, [[0, 1, 0], [0, 0, 1], [1, 0, 0]]))
    }

    @Test("Modificar una copia mediante intercambios no modifica el original")
    func copiaIndependiente() throws {
        let original = try permutacionEjemplo()
        let copia = MatrizP(copiaDe: original)
        #expect(copia.intercambiarFilas(0, 2))
        #expect(copia.esPermutacion())
        #expect(original.esPermutacion())
        #expect(contiene(original, [[0, 1, 0], [0, 0, 1], [1, 0, 0]]))
        #expect(contiene(copia, [[1, 0, 0], [0, 0, 1], [0, 1, 0]]))
    }

    // MARK: - Integridad mediante API pública

    @Test("establecerValor rechaza cambios que romperían la permutación")
    func setterRechazaCambios() throws {
        let p = try permutacionEjemplo()
        #expect(!p.establecerValor(1, fila: 0, columna: 0))  // 0 -> 1
        #expect(!p.establecerValor(0, fila: 0, columna: 1))  // 1 -> 0
        #expect(!p.establecerValor(5, fila: 2, columna: 0))  // 1 -> 5
        #expect(!p.establecerValor(-1, fila: 1, columna: 0)) // 0 -> -1
        #expect(p.esPermutacion())
        #expect(contiene(p, [[0, 1, 0], [0, 0, 1], [1, 0, 0]]))
    }

    @Test("establecerValor admite mantener el mismo valor y rechaza índices inválidos")
    func setterSinCambios() throws {
        let p = try permutacionEjemplo()
        #expect(p.establecerValor(1, fila: 0, columna: 1))
        #expect(p.establecerValor(0, fila: 0, columna: 0))
        #expect(!p.establecerValor(1, fila: -1, columna: 0))
        #expect(!p.establecerValor(0, fila: 0, columna: 3))
        #expect(p.esPermutacion())
    }

    @Test("Intercambiar filas cambia el contenido y conserva la permutación")
    func intercambiarFilas() throws {
        let p = try permutacionEjemplo()
        #expect(p.intercambiarFilas(0, 2))
        #expect(contiene(p, [[1, 0, 0], [0, 0, 1], [0, 1, 0]]))
        #expect(p.esPermutacion())
        #expect(p.intercambiarFilas(0, 2))
        #expect(contiene(p, [[0, 1, 0], [0, 0, 1], [1, 0, 0]]))
    }

    @Test("Intercambiar columnas cambia el contenido y conserva la permutación")
    func intercambiarColumnas() throws {
        let p = try permutacionEjemplo()
        #expect(p.intercambiarColumnas(0, 2))
        #expect(contiene(p, [[0, 1, 0], [1, 0, 0], [0, 0, 1]]))
        #expect(p.esPermutacion())
        #expect(p.intercambiarColumnas(0, 2))
        #expect(contiene(p, [[0, 1, 0], [0, 0, 1], [1, 0, 0]]))
    }

    @Test("Intercambios inválidos no modifican la matriz; el mismo índice es válido")
    func intercambioInvalidoOIdentico() throws {
        let p = try permutacionEjemplo()
        #expect(!p.intercambiarFilas(-1, 0))
        #expect(!p.intercambiarFilas(0, 3))
        #expect(!p.intercambiarColumnas(-1, 2))
        #expect(!p.intercambiarColumnas(2, 3))
        #expect(p.intercambiarFilas(1, 1))
        #expect(p.intercambiarColumnas(0, 0))
        #expect(contiene(p, [[0, 1, 0], [0, 0, 1], [1, 0, 0]]))
        #expect(p.esPermutacion())
    }
}
