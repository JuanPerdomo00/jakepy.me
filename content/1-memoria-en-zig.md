# Bloques de memoria

Cada proceso tiene una vista virtual de la memoria dividia en bloques.

## Static

    static
    -------------------------
            |       |       |
            |       |       |
            |       |       |
    -------------------------
    0x1000   0x1001  0x1002


    Estas regienos de memoria guardan informacion
    que no van a cambiar, como el caso de las constantes.
    Static se le conoce como Static live time. La vida de
    esos valores dura mientras el programa este en ejecucucion.

### Nivel de contenedor

Variables y constantes a nivel contenedor, o globales, se almacenan en
el bloque **Static**

::: {#cb2 .sourceCode}
``` {.sourceCode .zig}
const c: u8 = 42;
var v: u8 = 13;

// ----------------------------------
// c: u8        | v: u8     |       |
//    42        |    13     |       |
//              |           |       |
// ----------------------------------
// 0x1000       0x1001      0x1002

// Como cada de esos datos en memoria ocupan 8bytes y hay 2 entonces
// en la memoria seria 16bits o 2 bytes. 
```
:::

### Constantes

Las constantes siempre se almacenan en el bloque **Static** no importa
si son globales o locales.

::: {#cb3 .sourceCode}
``` {.sourceCode .zig}
fn f(a: u8, b: u8) {
    const c: u8 = 13;
}

//          Static
// ----------------------------------
// c: u8        |           |       |
//    13        |           |       |
//              |           |       |
// ----------------------------------
// 0x1000       0x1001      0x1002


//          Stack
// ----------------------------------
// a: u8        | b: u8     |       |
//    1         |    2      |       |
//              |           |       |
// ----------------------------------
// 0xff00       0xff01      0xff02

// Los parametros de la funcion siempre van al frame de funcion 
// pero para las connstantees van para el static. En el scope de 
// esa funcion si va estar disponible la constante, pero su direccion 
// de memoria va esta siempre en el static. 1 byte en el area de static 
// y 2 bytes en el funcion stack frame.
```
:::

## Heap

    heap
    -------------------------
            |       |       |
            |       |       |
            |       |       |
    -------------------------
    0x7700   0x7701  0x7702

    -> Direcciones aumentan

    Esta es un area de memoria donde haremos asignaciones diammicas o allocator.

## Asignacion al heap

Cuando usamos un **allocator** en zig, el espacion que se asigna esta en
el **heap** y solo es accesible por medio de un puntero.

::: {#cb5 .sourceCode}
``` {.sourceCode .zig}
const ptr: *u8 = try allocator.create(u8);

// El metodo create se le pasa el tipo de dato, este se utilizaa
// cuando queremos hacer una asignacion de 1 solo elemento, en este caso 
// 1 byte.
// El try es porque puede fallar, porque si en caso el proceso se quede sin memoria.
// Estas funcones de allocator siempre regresan punteros.


//          Static
// ----------------------------------
// ptr: *u8     |           |       |
//  0x7700      |           |       |
//              |           |       |
// ----------------------------------
// 0x1000       0x1001      0x1002


//          Heap
// ----------------------------------
// u8           |            |       |
//              |            |       |
//              |            |       |
// ----------------------------------
// 0x7700       0x7701        0x7702 

// En el caso de static al puntero ser const, pues esta se 
// guarda en el espacion de memoria de static, pero guarda 
// la direccion de memoria en la reguion del heap donde se 
// va guardar ese byte. Es decir el punteo ala region del 
// heap de ese tipo de dato.
```
:::

## Stack

    Stack
    -------------------------
            |       |       |
            |       |       |
            |       |       |
    -------------------------
    0xff00   0xff01  0xff02

    Direcciones disminuyen <-

    Region de memoria donde se van a colocar variables locales y parametros de funciones.

## Nivel de funcion

Variables a nivel de funcion, o locales, se almacecnan en el **Stack**,
dentro del marco de la funcion.

::: {#cb7 .sourceCode}
``` {.sourceCode .zig}
fn f(a : u8, b: u8) {
    var v: u8 = 13;
}

// ------------------------------
//  a: u8   |  b: u8  |  v: u8  |
//      1   |      2  |     12  |
//          |         |         |
// ------------------------------
// 0xff00   0xff01     0xff02

// En el caso del stack, cuuando se hacen esta asignacion de todo 
// este entorno que necesita la funcion para funcionar, se conoce en 
// ingles como el function stack frame. Una vez la funcion termina 
// el function stack frame se elimina o se hace un pop. En la gran 
// mayoria de las arquitectura el stack crece hacia abajo o va disminuyendo.
```
:::
