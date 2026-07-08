# ¿Por qué 755?

Para empezar, ¿por qué 755? Este número tal vez lo han oído sobre todo
usuarios de Linux, especialmente con el comando
`chmod 755 filename or dir`, pero ¿qué significa en detalle? Lo veremos
en este blog sobre el sistema de seguridad del sistema de archivos de
Linux.

### Este tema se dividirá en los siguientes temas

-   Permisos de archivos (también aplica en directorios)
-   Objetivos (para los que se pueden establecer estos permisos)
-   chmod (cómo usarlo)

## Permisos en Linux/Unix

PD: Si tienes un Mac, o una distribución como FreeBSD o alguna que tenga
base Unix, este tutorial también es para ti. Sin más, empecemos.

  Permisos   Flags   \#   Representación binaria
  ---------- ------- ---- ------------------------
  Read       r       4    100
  Write      w       2    010
  Execute    x       1    001

-   **Read (Lectura)**
    -   Si tienes permiso de lectura en un archivo puedes leerlo, pero
        si lo tienes en un directorio, puedes listar el contenido de ese
        directorio, todos los nombres de archivos.
-   **Write (Escritura)**
    -   Si tienes los permisos de escritura puedes modificar los
        archivos y guardar los cambios, también puedes eliminarlos. Si
        lo tienes en un directorio, puedes hacer cualquier cosa: borrar
        archivos, crear archivos, o renombrar, etc.
-   **Execute (Ejecución)**
    -   Si tienes permisos de ejecución para un archivo puedes
        ejecutarlo, y si es en un directorio, entonces podrás hacer `cd`
        en él. Si solo tienes ejecución y no lectura, entonces no podrás
        ver el contenido de ese directorio. Pero si conoces el nombre de
        este o de sus subcarpetas puedes ir.

### Representación binaria de los permisos

Ok, ¿por qué se menciona el binario? No es por gusto por supuesto, sino
por diseño. Es muy ingenioso y se basa en los indicadores mencionados
anteriormente `flags`.

Ok, entonces vamos a por el ejemplo.

    0001 -> 1 -> x
    0010 -> 2 -> w
    0100 -> 4 -> r

Se pueden combinar, digamos que queremos combinar el permiso de lectura
y escritura.

    Sería algo como (4+2 = 6)
    Entonces 6 significa lectura y escritura juntos. En binario se vería algo como 110, 
    ya que la única forma de producir un 6 es de esta forma binaria.

    0 0 0
    4 2 1 -> Las posiciones valen eso en decimal.

    Podemos almacenar todas las combinaciones posibles de estas, ya que no chocan y forman un entero.

## Objetivos

En esta parte ya podemos empezar a usar la terminal, específicamente el
comando `ls`.

Entonces, ¿qué pasa cuando ejecutamos el comando `ls -l`?

::: {#cb3 .sourceCode}
``` {.sourceCode .sh}
.rw-r--r-- jakepys jakepys 0 B Sat Jan 17 18:57:49 2026 main.c
```
:::

Vale, aquí están las flags, de forma literal como se vio en la parte de
representación.

Pero esto tiene algo importante y es que en Linux/Unix los usuarios
propietarios dan esos permisos. En este caso son 3: el usuario, el grupo
y otros.

    rw- r-- r--
    U   G   O

-   **Usuario (U)**
    -   Es básicamente el propietario del archivo. Por ejemplo, si has
        creado un archivo en tu directorio de inicio entonces eres el
        propietario. Y eso significa que tienes permisos para cambiar
        los permisos. Si eliminas todos los permisos no puedes acceder
        al archivo, pero puedes darte acceso de lectura y escritura y
        luego abrir el archivo, también puedes eliminarlo, etc. Por lo
        tanto debes decidir si el usuario tendrá permisos de lectura o
        escritura o ejecución o los 3.
-   **Grupo (G)**
    -   Cada usuario en una distro Linux/Unix es parte de un grupo, pero
        posiblemente de varios. Básicamente el administrador (root)
        puede crear esos grupos y puedes formar parte de esos grupos.
-   **Otros (O)**
    -   Se establecen permisos para un grupo específico, tiene infinitas
        posibilidades.

  Target   Flag
  -------- ------
  user     u
  group    g
  other    o

Entonces volvamos a `ls -l`. No solo obtendrás información sobre los
permisos, sino información adicional como fecha de creación, la cantidad
de bytes del archivo o directorio y luego los nombres.

## chmod

`chmod` es un comando para cambiar esas flags, o modos en Linux/Unix.

::: {#cb5 .sourceCode}
``` {.sourceCode .sh}
# Supongamos que tenemos esta salida del ls -l
ls -l
total 0
-rw-r--r-- 1 jakepys jakepys 0 Jan 17 18:57 main.c

# Tenemos el archivo main.c con los permisos en el usuario en lectura y escritura,
# de solo lectura en grupos y lectura en otros.
# Vamos a agregarle el modo escritura al grupo.

chmod g+w main.c

# Si hacemos ls -l veremos los cambios de modo en el grupo.
total 0
-rw-rw-r-- 1 jakepys jakepys 0 Jan 17 18:57 main.c

# Como ven ahora tiene rw-
# Ahora vamos a quitar todos los permisos a otros.

chmod o-r main.c

# Como ven si hacemos de nuevo el comando ls -l entonces veremos que
# otros ya no tiene ningún permiso.
total 0
-rw-rw---- 1 jakepys jakepys 0 Jan 17 18:57 main.c

# Vamos a complicar un poco el asunto, vamos a poner permisos de lectura y escritura a otros,
# vamos a quitar permiso de escritura a grupo y al usuario le vamos a poner permisos de
# acceso o ejecución en un solo chmod.

chmod o+r,o+w,g-w,u+x main.c

total 0
-rwxr--rw- 1 jakepys jakepys 0 Jan 17 18:57 main.c

# Como ven ahora el archivo es un ejecutable y tiene permisos de lectura y escritura en
# otros y no tiene permiso de escritura en grupos.
```
:::

Hasta ahora es muy raro ¿no? usar +, - ¿qué son esas locuras?
Afortunadamente se pueden hacer de otra forma y es con números. Hagamos
otro ejemplo con números.

::: {#cb6 .sourceCode}
``` {.sourceCode .sh}
ls -l
total 0
-rw-r--r-- 1 jakepys jakepys 0 Jan 17 19:31 script.sh

# Vamos a agregarle permiso de escritura a grupo

chmod 664 script.sh

# Espera ¿qué es esto? ¿664? Vale, recuerden la parte de representación, cada dígito es
# el resultado de hacer la operación binaria. Por ejemplo si quiero que el usuario tenga
# permisos de lectura y escritura y no permisos de ejecución sumamos:

# r -> 100 -> 4
# w -> 010 -> 2
# x -> 001 -> 1

# Entonces sería 4+2+0 = 6
# Ahí está el del usuario

# Ahora para grupos
# 4+2+0 = 6

# Ahora para otros
# Agreguémosles permisos de ejecución y no lectura ni escritura.

# 0+0+1 = 1

# chmod sería
chmod 661 script.sh
```
:::

Para terminar, el ejemplo de este tutorial el 755.

Supongamos que queremos que un archivo tenga permisos de lectura,
escritura y ejecución en usuario, lectura y ejecución en grupos, y
lectura y ejecución en otros. ¿Lo intentamos?

::: {#cb7 .sourceCode}
``` {.sourceCode .sh}
chmod 755 gracias.c
total 0
-rwxr-xr-x 1 jakepys jakepys 0 Jan 17 19:40 gracias.c

# Y listo ahí quedó

# rwx -> user
# r-x -> groups
# r-x -> others

# r -> 4; w -> 2; x -> 1
# 4+2+1 4+0+1 4+0+1 = 755
```
:::

Gracias por leer este tutorial, considera seguirme en GitHub y
compartirlo con más personas que amen Linux. ¡Hasta la próxima!
