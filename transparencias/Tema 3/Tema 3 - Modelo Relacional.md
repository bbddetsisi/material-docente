---
marp: true
size: 4:3
auto-scaling: 
    - true
    - fittingHeader
    - math
    - code
backgroundColor: #fff
backgroundImage: url('https://marp.app/assets/hero-background.jpg')
paginate: true
header: Modelo relacional
---
<!--
_header: ''
_footer: ![Licencia de Creative Commons](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png) Esta obra está bajo una [licencia de Creative Commons Reconocimiento-NoComercial-CompartirIgual 4.0 Internacional](http://creativecommons.org/licenses/by-nc-sa/4.0/). Icono diseñado por Flaticon
-->
<style>
img[alt~="center"] {
  display: block;
  margin: 0 auto;
}
img {
  background-color: transparent!important;
}
li {
  text-align: justify;
}
s {
  text-decoration: underline;
  font-weight: bold;
}
p {
  text-align: justify;
}
</style>
![bg left:40% 60%](img/relational.svg)

# TEMA 3

# Modelo relacional

### Modelado lógico de bases de datos

---

## MODELO RELACIONAL

1. Introducción al modelo relacional.
2. Transformación del modelo ER a modelo relacional (paso a tablas).
3. Álgebra relacional.

---

## Elementos del modelo relacional

Como modelo de datos que es, el Modelo Relacional consta de tres partes diferentes:

- **Parte Estructural**: Relaciones (también llamadas Tablas).
- **Parte Operativa**: Álgebra Relacional.
- **Parte Semántica**: Restricciones de Integridad

---

## Elementos del modelo (Parte Estructural)

- Proporciona una representación uniforme de la información.
- Acceso a los datos: *navegación lógica*.
- Ventajas:
  - Simplicidad de la estructura.
  - Sencillez en la definición de los operadores.
  - Todas las consultas realizadas son simétricas.
  - La definición del Modelo Relacional está basada en una **base matemática potente**. Es similar a la *Teoría de Conjuntos*.

---

## Elementos del modelo (Parte Estructural)

-Las relaciones de este modelo pueden definirse de manera matemática:

> $R$ es una relación sobre los conjuntos $D_1,D_2,\ldots,D_n$, si es un subconjunto del producto cartesiano $D_1\times D_2\times \ldots \times D_n$.

Los diferentes conjuntos $D_1,D_2,\ldots,D_n$ sobre los que se define la relación se denominan **dominios**.

---

## Elementos del modelo (Parte Estructural)

- Cada **atributo** de la relación está asociado a un único dominio:
  - Ej: $D_\textrm{COLOR} = \left \{ \textrm{Rojo},\textrm{Negro},\textrm{Azul},\textrm{Verde} \right \}$
  - Los nombres de los atributos que definen una relación no pueden repetirse.
  - Los dominios sí pueden estar repetidos.
- Los elementos que componen una relación se denominan **tuplas**.
- **Grado de una relación**: número de atributos sobre el que se define la relación.
- **Cardinalidad de una relación**: número de tuplas que contiene la relación en un momento dado.

---

## Elementos del modelo (Parte Estructural)

Representación gráfica de una relación:

![center w:650](img/relacion.png)

Representación textual:

$R \left ( A_1,A_2,\ldots,A_n \right )$

---
<style scoped>
blockquote {
  font-size: 0.8rem;
}
</style>

## Esquemas de relación

- Toda relación puede definirse de dos formas:
  - Por extensión: especificando todas y cada una de las tuplas que componen la relación.
  - Por intensión: especificando el esquema de la relación.
- Se define un esquema de relación como:

> Estructura abstracta que define una relación a través de un nombre, un conjunto de atributos y un conjunto de restricciones que caracterizan a esa relación.

$$
r = R(T,L)
$$

donde $R$ es el nombre de la relación $r$, $T$ el conjunto de atributos que definen a $r$ y $L$ el conjunto de restricciones que caracterizan a $r$.

---

## Esquemas de relación

Las restricciones de comportamiento suelen ser de dos tipos:

- Asignación de los atributos a dominios.
- Relaciones entre los atributos.

Concepto de realización de una relación:
> Es la asignación de valores al conjunto T de atributos del esquema de relación, de tal forma que se cumplan todas y cada una de las restricciones del conjunto L de restricciones.

---

## Esquemas de relación

El esquema de una **base de datos relacional** será el conjunto de esquemas de relación correspondiente a cada una de las relaciones que la formen.

Por tanto, una realización válida de la **base de datos relacional** será el conjunto de realizaciones válidas de cada una de sus esquemas de relación.

---
<style scoped>
li {
  font-size: 0.8rem;
}
p {
  font-size: 0.8rem
}
</style>

## Condiciones del modelo (Parte Estructural)

- Cada tabla debe contener un solo tipo de filas.
- Una tabla no puede contener filas duplicadas.
- Cada columna debe estar identificada por un nombre específico.
- Cada columna tiene que ser única, no pudiendo existir columnas duplicadas.
- Cada valor en una columna tiene que ser único, no permitiéndose valores múltiples para - un atributo.
- Cada columna debe extraer sus valores de un dominio.
- Un mismo dominio podrá servir para columnas diferentes.
- Las filas pueden estar en cualquier orden.
- Las columnas pueden estar en cualquier orden.

---

## Elementos del modelo (Parte Estructural)

Definición de **base de datos relacional**:

> Conjunto de relaciones de formato fijo cuyo contenido es variable en el tiempo.

Los atributos serán símbolos tomados de un conjunto finito $\mathbb{U}$ ("universo" del modelo conceptual). Usaremos $A,B,\ldots$ para denotar atributos simples y $V,W,X\ldots$, para designar conjuntos de los mismos o descriptores.

**NOTA**: en adelante denominaremos indistintamente "descriptor" a un atributo simple o a un conjunto de atributos. 

---

## Elementos del modelo (Parte Estructural)

En el Modelo Relacional se distingue entre dos tipos de relaciones:

- **Relaciones básicas**: son aquellas relaciones que se definen con independencia del resto de relaciones existentes en la *BD* relacional.
- **Relaciones derivadas**: son aquellas otras relaciones que son resultado de la aplicación de los operadores relacionales sobre las relaciones básicas.

---

## Elementos del modelo (Parte Semántica)

Concepto de clave (definición **no** formal):

> Descriptor mínimo cuyo valor determina de forma unívoca el valor del resto de los atributos de la relación.

- Cada relación tiene **al menos una** clave.
- Si hay varias claves, desde el punto de vista puramente teórico todas son iguales.
  - En la práctica, es decir, cuando se define la BD relacional en un SGBD, cada clave se denomina *clave candidata*, y una de ellas se elegirá como **CLAVE PRINCIPAL O PRIMARIA**, quedando el resto como **claves alternativas**.

---

## Elementos del modelo (Parte Semántica)

Cada relación tendrá una combinación de atributos que, tomados en conjunto, identifican de forma única cada tupla.

| DNI | Nombre | Domicilio | Teléfono |
|-----|--------|-----------|----------|
| 321 | Pepe   | Aquí      | 987      |
| 134 | Pepe   | Allí      | 789      |
| 123 | Juan   | Allí      |          |

¿Cuál será la clave para esta relación?

---

## Elementos del modelo (Parte Semántica)

Restricciones semánticas del modelo relacional:

1. **Restricción de Integridad de Entidad**. Ningún valor de la clave primaria de una relación puede ser nulo o tener algún componente nulo. Asimismo, una clave primaria no admite valores repetidos.
2. **Restricción de Integridad de Dominio**. Un atributo no puede tomar valores que excedan del rango asociado.

---

## Elementos del modelo (Parte Semántica)

3. **Restricción de Integridad Referencial**: Para un atributo $A$ perteneciente a una clave primaria compuesta de una relación $R$, se cumple que para todo valor $a$ de dicho atributo $A$ en $R$ tiene que existir otra relación $S$ con una clave primaria $B$ tal que $a$ ocurre como un valor de $B$ en la relación $S$.

---
<style scoped>
blockquote {
  font-size: 0.8rem;
}
</style>
Ejemplo:

>PROVEEDORES (~~COD_PROV~~, NOMBRE)
>ARTÍCULOS (~~COD_ART~~, DESCRIPCIÓN)
>SUMINISTROS (~~COD_PROV~~, ~~COD_ART~~, CANTIDAD, ~~FECHA~~)

Si en `SUMINISTROS` existe la tupla: (*P2*, *A012*, 1000, *13/01/98*)

Por la restricción de integridad referencial **es obligado** que en `PROVEEDORES` exista una tupla tal que ~~COD_PROV~~=*P2*. Así mismo, en la relación `ARTICULOS` deberá existir otra tupla en la que se verifique ~~COD_ART~~=*A012*

**Conclusión**: no podrá existir una tupla en la relación `SUMINISTROS` en la que figure un código de proveedor o un código de artículo que no existan previamente en sus respectivas relaciones de `PROVEEDORES` y `ARTICULOS`.
