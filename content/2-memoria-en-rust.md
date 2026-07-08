# Stack y Heap en Rust

Como saben, la memoria en una computadora suele dividirse en varias
áreas principales: - Stack (pila) - Heap (monton) - Static (memoria
estática)

## Static

En esta área se ubican las variables `static` que definimos en el código
y las cadenas con vida estática `&'static str`.

Ejemplo: literales de cadena escritos en el binario permanecen en la
sección estática durante toda la ejecución.

## Stack (pila)

La pila es la región de memoria donde, cada vez que se ejecuta una
función, se asigna un espacio (stack frame) para: - variables locales -
parámetros - espacio para el valor de retorno

Estructura conceptual:

    Stack

    -----------------
    |               |
    |   other fn 3  |  <- si fn 3 termina, se desapila y vuelve el control a fn 2
    -----------------
    |               |
    |   other fn 2  |
    -----------------
    |               |
    |   other fn 1  |
    -----------------
    |               |
    |   fn main     |
    -----------------

`main` es la función principal en Rust; es la primera que se apila.
Cuando `main` llama a otra función, se crea un nuevo frame encima del de
`main`. El frame de `main` queda inactivo hasta que la función llamada
termina y se desapila.

Como el tamaño requerido en el stack por cada función suele conocerse en
tiempo de compilación, Rust suele necesitar tipos concretos (por ejemplo
`i32`, `u8`) para calcular correctamente cuánto espacio reservar en el
stack. Esto es una de las razones por las que los tipos suelen ser
explícitos o inferridos durante la compilación.

## Heap (monton)

El heap es la región de memoria usada para asignaciones dinámicas en
tiempo de ejecución, cuando no conocemos el tamaño en compilación.

Conceptualmente hay bloques de memoria distribuidos en el heap:

    Heap
    ---------------------
    |                   |
    |         ------    |
    |         |    |    |
    |         ------    |
    |                   |
    |         -----     |
    |         |   |     |
    |         -----     |
    |                   |
    --------------------

Cuando el programa necesita memoria dinámica, el compilador de rust
solicita al sistema operativo un bloque de memoria adecuado; el SO
devuelve la dirección donde está ese bloque. Trabajar con el heap
permite tamaños dinámicos que pueden crecer en ejecución, a costa de
mayor coste en tiempo (asignaciones y liberaciones son más lentas que en
el stack).

## Notas sobre punteros y sitios de almacenamiento

Las variables que usamos para acceder a los datos (p. ej. punteros o
estructuras en Rust que contienen referencias) siempre viven en el stack
cuando son locales; esas variables contienen direcciones que apuntan a
datos en el heap o en la sección estática.

## Ejemplos en Rust

### Stack (arrays con tamaño conocido en compilación)

::: {#cb3 .sourceCode}
``` {.sourceCode .rust}
fn main() {
    // array: se almacena en el stack porque su tamaño es conocido en tiempo de compilación
    println!("Array: [i32; 3]");
    let mut a = [1, 2, 3];
    println!("len: {}, ptr: {:p}", a.len(), a.as_ptr());
    println!("a[1] == {}", a[1]);
    a[1] = 0;
    println!("a[1] == {}", a[1]);
}
```
:::

> Todos los tipos cuyo tamaño se conoce en compilación se colocan (o se
> reservan) dentro del stack frame de la función activa.

### Vector (`Vec<T>`) --- stack + heap

::: {#cb4 .sourceCode}
``` {.sourceCode .rust}
fn main() {
    // Vec: la estructura (tamaño, puntero, len, capacity) vive en el stack;
    // los elementos se almacenan en el heap
    println!("Vector Vec<i32>");
    let mut v = Vec::new();
    println!(
        "len: {}, capacity: {}, ptr: {:p}",
        v.len(),
        v.capacity(),
        v.as_ptr()
    );

    v.push(1);
    v.push(2);
    v.push(3);
    println!("v[1] == {}", v[1]);
    v[1] = 0;

    println!("v[1] == {}", v[1]);

    println!(
        "len: {}, capacity: {}, ptr: {:p}",
        v.len(),
        v.capacity(),
        v.as_ptr()
    );

    v.push(4);
    v.push(5);
    v.push(6);

    println!(
        "len: {}, capacity: {}, ptr: {:p}",
        v.len(),
        v.capacity(),
        v.as_ptr()
    );

    v.pop();

    println!(
        "len: {}, capacity: {}, ptr: {:p}",
        v.len(),
        v.capacity(),
        v.as_ptr()
    );

    v.drain(0..);

    println!(
        "len: {}, capacity: {}, ptr: {:p}",
        v.len(),
        v.capacity(),
        v.as_ptr()
    );
}
```
:::

> `capacity` muestra la reserva interna en el heap: a menudo un `Vec`
> reserva más espacio del estrictamente necesario para evitar
> reasignaciones frecuentes.

### Literales `&str` (estático)

::: {#cb5 .sourceCode}
``` {.sourceCode .rust}
fn main() {
    // &str: el literal vive en la sección estática del binario
    println!("&str");
    let s = "I love rust🦀❤️";
    println!(
        "len: {}, chars: {}, ptr: {:p}",
        s.len(),
        s.chars().collect::<Vec<char>>().len(),
        s.as_ptr()
    );
}
```
:::

### `String` --- stack + heap

::: {#cb6 .sourceCode}
``` {.sourceCode .rust}
fn main() {
    // String: la estructura (len, capacity, puntero) está en el stack;
    // el contenido se almacena en el heap
    println!("String");
    let mut s = String::from("I love rust 🦀❤️");
    println!(
        "len: {}, chars: {}, ptr: {:p}",
        s.len(),
        s.chars().collect::<Vec<char>>().len(),
        s.as_ptr()
    );

    s.push('C');
    s.push_str("!!!");
    s.pop();

    println!("{}", s);

    println!(
        "len: {}, chars: {}, ptr: {:p}",
        s.len(),
        s.chars().collect::<Vec<char>>().len(),
        s.as_ptr()
    );
}
```
:::

### `Box<T>` --- valores en el heap

::: {#cb7 .sourceCode}
``` {.sourceCode .rust}
fn main() {
    // Box: guarda el valor en el heap; la caja (el puntero) vive en el stack
    println!("Box Box<[i32; 3]>");
    let mut b = Box::new([1, 2, 3]);
    println!("len: {}, ptr: {:p}", b.len(), b.as_ptr());

    println!("b[1] == {}", b[1]);
    b[1] = 0;
    println!("b[1] == {}", b[1]);
}
```
:::
