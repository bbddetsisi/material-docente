---
marp        : true
title       : Modelo Entidad-Relación extendido (paso a tablas)
paginate    : true
theme       : bbdd
header      : Modelo Entidad-Relación extendido (paso a tablas)
footer      : Bases de datos
description : >
  Cómo pasar al modelo relacional los elementos del modelo entidad-relación extendido.
keywords    : >
  Bases de datos, Modelo Entidad-Relación extendido, Álgebra Relacional, Normalización,
  Claves, Relaciones, Tablas
math        : mathjax
---

<!-- _class: titlepage -->

# Modelo Entidad-Relación extendido (paso a tablas)

## Bases de datos

### Departamento de Sistemas Informáticos

#### E.T.S.I. de Sistemas Informáticos

##### Universidad Politécnica de Madrid

[![height:30](https://mirrors.creativecommons.org/presskit/buttons/80x15/svg/by-nc-sa.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

![bg left:30%](img/upm-logo.jpg)

---

# Paso a tablas de la generalización/especialización

Proceso a seguir

1. Creamos una relación (tabla) para la superclase, incluyendo todos sus atributos
1. Para cada subclase:
    1. Creamos una relación, incluyendo sus atributos
    1. La clave de la superclase se añade como clave primaria y externa (referenciando a la clave primaria de la superclase)
1. Seguir aplicando las reglas de paso a tablas de las relaciones con las entidades.

---

# Ejemplo

<style>
.container{
    display: flex;
}
.col{
    flex: 1 1 auto;
    margin: 20px
}
</style>

<div class="container">

<div class="col">

![width:900](diagrams/eer-ejemplo.png)

</div>

<div class="col">

![width:400](diagrams/eer-tablas.drawio.png)

</div>

</div>


---

# Licencia<!--_class: license -->

Esta obra está licenciada bajo una licencia [Creative Commons Atribución-NoComercial-CompartirIgual 4.0 Internacional](https://creativecommons.org/licenses/by-nc-sa/4.0/).

Puede encontrar su código en el siguiente enlace: <https://github.com/bbddetsisi/material-docente>
