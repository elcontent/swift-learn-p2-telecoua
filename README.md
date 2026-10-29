# MatricesSwift — Aprendizaje de Swift y POO

Proyecto de aprendizaje de **Swift** a partir de la Práctica 2 de **Programación 2 (FP2_GISIT)**, originalmente planteada en C++. El objetivo es comprender las particularidades de Swift y aplicar los fundamentos de la **programación orientada a objetos (POO)**, no traducir el código de C++ de forma literal.

## Objetivos de aprendizaje

- Trabajar con Xcode, la ejecución de programas de consola y el depurador LLDB.
- Entender propiedades, inicializadores, encapsulación, métodos y propiedades calculadas.
- Practicar referencias, copias, `class` frente a `struct`, opcionales y `guard`.
- Sobrecargar operadores y validar las dimensiones de las matrices.
- Aplicar herencia y polimorfismo.
- Explorar protocolos y genéricos de Swift como alternativa a las plantillas de C++.
- Incorporar pruebas automatizadas y, opcionalmente, una interfaz con SwiftUI.

## Ejercicio 1 — Jerarquía de matrices

El enunciado original propone las siguientes clases:

```text
Matriz
  └── MatrizC (cuadrada)
        └── MatrizP (permutación)
              └── MatrizI (identidad)
```

**`Matriz`** representa una matriz dinámica de enteros. Incluye una matriz nula de tamaño 0 × 0, construcción con valores aleatorios entre 0 y 99, copia independiente, consulta y modificación controladas de elementos y visualización por consola.

Operaciones previstas:

| Operación | Requisito |
| --- | --- |
| `+`, `-` | Igual número de filas y columnas |
| `*` entre matrices | Columnas de la izquierda = filas de la derecha |
| `*` por escalar | Multiplicación de cada elemento |
| `+=`, `-=`, `*=` | Operaciones compuestas |
| `==` | Comparación de matrices |

En consonancia con el enunciado original, las operaciones incompatibles deben producir una **matriz nula (0 × 0)**, que no debe confundirse con `nil`.

Las clases derivadas restringirán los valores admisibles: una matriz cuadrada, una de permutación y una identidad, respectivamente.

## Ejercicio 2 — Genéricos y Fibonacci

Se generalizará la jerarquía mediante tipos genéricos, para trabajar con `Int`, `Double`, `Float` y un tipo propio `Fibonacci`. En este último caso, las operaciones se realizan sobre el ordinal del elemento de la sucesión, según el enunciado.

## Estado del aprendizaje

- [x] Preparación de Xcode y primera ejecución.
- [x] Uso básico de breakpoints y depuración.
- [x] Diseño inicial de `Matriz`: propiedades, inicializadores, copia, acceso controlado y presentación.
- [x] Conceptos de `nil`, `Void`, etiquetas de argumentos, `guard` y `@discardableResult`.
- [x] Validación de dimensiones para suma y resta.
- [x] Completar los operadores aritméticos básicos y compuestos.
- [x] Añadir 63 pruebas automatizadas con Swift Testing.
- [x] Implementar la primera versión de `MatrizC`, `MatrizP` y `MatrizI`.
- [ ] Implementar genéricos y `Fibonacci`.
- [ ] Refactorizar con patrones idiomáticos de Swift.
- [ ] Desarrollar una interfaz SwiftUI (ampliación opcional).

> **Nota:** el código del proyecto Xcode se encuentra versionado en `MatricesSwift/MatricesSwift/`. Las pruebas están separadas del ejecutable.

## Entorno de desarrollo

- macOS
- Xcode
- Swift

Para trabajar en el proyecto, abre el proyecto de Xcode desde tu copia local, selecciona el destino **My Mac** y ejecútalo con **⌘R**. Puedes compilar con **⌘B** y abrir la consola de depuración con **⌘⇧Y**.

## Ejecutar las pruebas

Las 63 pruebas de `Matriz`, `MatrizC`, `MatrizP` y `MatrizI` se han escrito con **Swift Testing** y funcionan mediante **Swift Package Manager**, sin modificar el proyecto de consola de Xcode existente.

Desde la raíz del repositorio:

```bash
cd MatricesSwift
swift test --parallel
```

Para ejecutarlas visualmente en **Xcode**, abre la carpeta `MatricesSwift/` como *Swift Package* (mediante `File > Open`, seleccionando la carpeta que contiene `Package.swift`) y utiliza **⌘U**. El proyecto `MatricesSwift.xcodeproj` sigue siendo el punto de entrada para editar y ejecutar el programa de consola con **⌘R**, pero no tiene un test target propio: para `⌘U` debes abrir el paquete.

Los tests cubren inicializadores de `Matriz`, `MatrizC`, `MatrizP` y `MatrizI`, construcción y conversión failable, copias independientes, matrices nulas y dimensiones inválidas, operaciones aritméticas e igualdad. En `MatrizP` se comprueban la invariante de permutación, los intercambios y la protección de los valores. En `MatrizI` se comprueba la identidad para múltiples órdenes, su validación, los rechazos de operaciones que romperían la diagonal, los índices inválidos y el polimorfismo mediante referencias de las superclases.

GitHub Actions ejecuta `swift test --parallel` automáticamente en cada `push` y `pull_request` mediante `.github/workflows/swift-tests.yml`.

## Criterios de implementación

1. Mantener el comportamiento exigido por la práctica original como primera referencia.
2. Encapsular el almacenamiento de los elementos y comprobar los índices.
3. No confundir una instancia de matriz nula con una referencia opcional que contiene `nil`.
4. Diferenciar la copia de un objeto de la copia de su referencia.
5. Documentar los cambios de diseño necesarios para adaptar C++ a Swift.
6. Preferir código claro, verificable y fácil de mantener.

## Licencia

No se ha definido una licencia para este repositorio.
