import Testing
@testable import MatricesSwift

@Suite("Matriz: operaciones y casos límite")
struct MatrizTests {

    // MARK: - Utilidades de prueba

    /// Construye una matriz determinista mediante la API pública.
    private func matriz(_ valores: [[Int]]) -> Matriz {
        guard let primeraFila = valores.first, !primeraFila.isEmpty else {
            return Matriz()
        }

        let resultado = Matriz.zeros(
            filas: valores.count,
            columnas: primeraFila.count
        )

        for (fila, datosFila) in valores.enumerated() {
            precondition(datosFila.count == primeraFila.count, "Fixture no rectangular")
            for (columna, valor) in datosFila.enumerated() {
                precondition(resultado.establecerValor(valor, fila: fila, columna: columna))
            }
        }

        return resultado
    }

    /// Comprueba simultáneamente dimensiones y valores; nunca usa `mostrar()`.
    private func contiene(_ actual: Matriz, _ esperado: [[Int]]) -> Bool {
        guard let primeraFila = esperado.first, !primeraFila.isEmpty else {
            return actual.esNula && actual.filas == 0 && actual.columnas == 0
        }

        guard actual.filas == esperado.count,
              actual.columnas == primeraFila.count else {
            return false
        }

        for (fila, datosFila) in esperado.enumerated() {
            guard datosFila.count == primeraFila.count else { return false }
            for (columna, valor) in datosFila.enumerated() {
                guard actual.valor(fila: fila, columna: columna) == valor else {
                    return false
                }
            }
        }

        return true
    }

    // MARK: - Construcción y encapsulación

    @Test("Una matriz por defecto es nula (0×0)")
    func inicializadorPorDefecto() {
        let resultado = Matriz()
        #expect(resultado.esNula)
        #expect(resultado.filas == 0)
        #expect(resultado.columnas == 0)
        #expect(resultado.valor(fila: 0, columna: 0) == nil)
    }

    @Test("Dimensiones inválidas generan una matriz nula")
    func dimensionesInvalidas() {
        for (filas, columnas) in [(0, 3), (3, 0), (-1, 2), (2, -1)] {
            #expect(Matriz(filas: filas, columnas: columnas).esNula)
            #expect(Matriz.zeros(filas: filas, columnas: columnas).esNula)
        }
    }

    @Test("El inicializador aleatorio respeta dimensiones y rango 0...99")
    func inicializadorAleatorio() {
        let resultado = Matriz(filas: 5, columnas: 7)
        #expect(resultado.filas == 5)
        #expect(resultado.columnas == 7)
        #expect(!resultado.esNula)
        for fila in 0..<resultado.filas {
            for columna in 0..<resultado.columnas {
                let valor = resultado.valor(fila: fila, columna: columna)
                #expect(valor != nil)
                if let valor {
                    #expect((0...99).contains(valor))
                }
            }
        }
    }

    @Test("La factoría zeros no introduce valores aleatorios")
    func matrizDeCeros() {
        #expect(contiene(Matriz.zeros(filas: 2, columnas: 3), [
            [0, 0, 0],
            [0, 0, 0]
        ]))
    }

    @Test("Lectura y escritura validan índices")
    func accesoAElementos() {
        let resultado = Matriz.zeros(filas: 2, columnas: 3)
        #expect(resultado.establecerValor(42, fila: 1, columna: 2))
        #expect(resultado.valor(fila: 1, columna: 2) == 42)
        #expect(!resultado.establecerValor(99, fila: -1, columna: 0))
        #expect(!resultado.establecerValor(99, fila: 0, columna: 3))
        #expect(resultado.valor(fila: 2, columna: 0) == nil)
        #expect(resultado.valor(fila: 0, columna: -1) == nil)
        #expect(resultado.valor(fila: 1, columna: 2) == 42)
    }

    @Test("La copia es independiente y la asignación comparte referencia")
    func copiasYReferencias() {
        let original = matriz([[1, 2], [3, 4]])
        let referencia = original
        let copia = Matriz(copiaDe: original)
        #expect(original === referencia)
        #expect(original !== copia)
        #expect(referencia.establecerValor(99, fila: 0, columna: 0))
        #expect(original.valor(fila: 0, columna: 0) == 99)
        #expect(copia.valor(fila: 0, columna: 0) == 1)
    }

    // MARK: - Compatibilidad y operaciones básicas

    @Test("La suma y resta requieren dimensiones iguales y no nulas")
    func compatibilidadSuma() {
        let a = matriz([[1, 2, 3], [4, 5, 6]])
        #expect(a.esCompatibleParaSuma(matriz([[0, 0, 0], [0, 0, 0]])))
        #expect(!a.esCompatibleParaSuma(matriz([[0, 0], [0, 0]])))
        #expect(!a.esCompatibleParaSuma(Matriz()))
    }

    @Test("El producto requiere columnas de A iguales a filas de B")
    func compatibilidadProducto() {
        let a = matriz([[1, 2, 3], [4, 5, 6]])
        #expect(a.sePuedeMultiplicarPor(matriz([[1, 2], [3, 4], [5, 6]])))
        #expect(!a.sePuedeMultiplicarPor(matriz([[1, 2], [3, 4]])))
        #expect(!a.sePuedeMultiplicarPor(Matriz()))
    }

    @Test("Suma elemento a elemento sin modificar los operandos")
    func suma() {
        let a = matriz([[1, 2, 3], [4, 5, 6]])
        let b = matriz([[6, 5, 4], [3, 2, 1]])
        #expect(contiene(a + b, [[7, 7, 7], [7, 7, 7]]))
        #expect(contiene(a, [[1, 2, 3], [4, 5, 6]]))
        #expect(contiene(b, [[6, 5, 4], [3, 2, 1]]))
    }

    @Test("Resta elemento a elemento, incluso resultados negativos")
    func resta() {
        let a = matriz([[1, 2, 3], [4, 5, 6]])
        let b = matriz([[6, 5, 4], [3, 2, 1]])
        #expect(contiene(a - b, [[-5, -3, -1], [1, 3, 5]]))
        #expect(contiene(a, [[1, 2, 3], [4, 5, 6]]))
    }

    @Test("Suma y resta incompatibles devuelven matriz nula")
    func sumaYRestaIncompatibles() {
        let a = matriz([[1, 2, 3], [4, 5, 6]])
        let b = matriz([[1, 2], [3, 4]])
        #expect((a + b).esNula)
        #expect((a - b).esNula)
        #expect((a + Matriz()).esNula)
    }

    @Test("Multiplicación rectangular en ambos órdenes")
    func productoMatricial() {
        let a = matriz([[1, 2, 3], [4, 5, 6]])
        let b = matriz([[7, 8], [9, 10], [11, 12]])
        #expect(contiene(a * b, [[58, 64], [139, 154]]))
        #expect(contiene(b * a, [[39, 54, 69], [49, 68, 87], [59, 82, 105]]))
        #expect(contiene(a, [[1, 2, 3], [4, 5, 6]]))
    }

    @Test("Producto matricial incompatible devuelve matriz nula")
    func productoIncompatible() {
        let a = matriz([[1, 2, 3], [4, 5, 6]])
        #expect((a * a).esNula)
        #expect((Matriz() * a).esNula)
    }

    @Test("Producto por escalar desde ambos lados")
    func productosEscalares() {
        let a = matriz([[1, -2], [3, 4]])
        #expect(contiene(a * 3, [[3, -6], [9, 12]]))
        #expect(contiene(3 * a, [[3, -6], [9, 12]]))
        #expect(contiene(a * 0, [[0, 0], [0, 0]]))
        #expect(contiene(-2 * a, [[-2, 4], [-6, -8]]))
        #expect((Matriz() * 3).esNula)
        #expect((3 * Matriz()).esNula)
        #expect(contiene(a, [[1, -2], [3, 4]]))
    }

    // MARK: - Operadores compuestos e igualdad

    @Test("+= y -= reasignan el resultado correcto")
    func sumaYRestaCompuesta() {
        var a = matriz([[1, 2], [3, 4]])
        let referenciaAnterior = a
        let b = matriz([[5, 6], [7, 8]])
        a += b
        #expect(contiene(a, [[6, 8], [10, 12]]))
        #expect(contiene(referenciaAnterior, [[1, 2], [3, 4]]))
        a -= b
        #expect(contiene(a, [[1, 2], [3, 4]]))
    }

    @Test("*= opera con matrices y cambia dimensiones si corresponde")
    func productoCompuestoMatricial() {
        var a = matriz([[1, 2, 3], [4, 5, 6]])
        let b = matriz([[7, 8], [9, 10], [11, 12]])
        a *= b
        #expect(contiene(a, [[58, 64], [139, 154]]))
    }

    @Test("*= también admite escalares")
    func productoCompuestoEscalar() {
        var a = matriz([[1, -2], [3, 4]])
        a *= -3
        #expect(contiene(a, [[-3, 6], [-9, -12]]))
        a *= 0
        #expect(contiene(a, [[0, 0], [0, 0]]))
    }

    @Test("Operadores compuestos incompatibles producen matriz nula")
    func operacionesCompuestasIncompatibles() {
        let a = matriz([[1, 2, 3], [4, 5, 6]])
        let b = matriz([[1, 2], [3, 4]])
        var suma = Matriz(copiaDe: a)
        suma += b
        #expect(suma.esNula)
        var resta = Matriz(copiaDe: a)
        resta -= b
        #expect(resta.esNula)
        var producto = Matriz(copiaDe: a)
        producto *= a
        #expect(producto.esNula)
    }

    @Test("== compara dimensiones y elementos, no identidad de referencia")
    func igualdad() {
        let a = matriz([[1, 2], [3, 4]])
        let b = matriz([[1, 2], [3, 4]])
        let c = matriz([[1, 2], [3, 5]])
        #expect(a == b)
        #expect(!(a == c))
        #expect(!(a == matriz([[1, 2, 3], [4, 5, 6]])))
        #expect(Matriz() == Matriz())
        #expect(a == a)
    }
}
