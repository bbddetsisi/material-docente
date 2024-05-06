import mysql.connector
from datetime import date, datetime, timedelta

# Nos conectamos a la base de datos, creando un objeto para gestionar la conexión
mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="root"
)

# Las operaciones se ejecutan con un objeto de tipo cursor:
cursor = mydb.cursor()

# Vamos a crear un esquema de prueba (https://github.com/datacharmer/test_db/blob/master/employees.sql)
cursor.execute("CREATE DATABASE prueba DEFAULT CHARACTER SET 'utf8'")

# Podemos usar strings multilínea de Python para las consultas SQL
tabla_empleado = """
CREATE TABLE prueba.employees (
    emp_no      INT             NOT NULL AUTO_INCREMENT,
    birth_date  DATE            NOT NULL,
    first_name  VARCHAR(14)     NOT NULL,
    last_name   VARCHAR(16)     NOT NULL,
    gender      ENUM ('M','F')  NOT NULL,
    hire_date   DATE            NOT NULL,
    PRIMARY KEY (emp_no)
);
"""

cursor.execute(tabla_empleado)

# Podemos definirnos una función para crear un empleado y almacenarlo en la base de datos
def crear_empleado(fecha_nac, nombre, apellidos, genero, fecha_alta):
    # Vamos a utilizar las consultas parametrizadas
    add_employee = ("INSERT INTO prueba.employees "
                    "(first_name, last_name, hire_date, gender, birth_date) "
                    "VALUES (%s, %s, %s, %s, %s)")
    cursor.execute(add_employee, (nombre, apellidos, fecha_alta, genero, fecha_nac))
    # Nos aseguramos de confirmar la transacción
    mydb.commit()

# Vamos a solicitar los datos del empleado por pantalla
fecha_nac = datetime.strptime(input("Fecha de nacimiento dd/mm/aa: "), r"%d/%m/%y")
nombre = input("Nombre: ")
apellidos = input("Apellidos: ")
genero = input("Género M/F: ")
fecha_alta = datetime.strptime(input("Fecha de alta dd/mm/aa: "), r"%d/%m/%y")

# Añadimos al usuario
crear_empleado(fecha_nac, nombre, apellidos, genero, fecha_alta)

# Vamos a realizar una consulta para obtener todos los empleados de la tabla
consulta = """
SELECT emp_no, first_name, last_name, hire_date
FROM prueba.employees
"""

cursor.execute(consulta)

for (id_emp, nombre, apellidos, fecha_alta) in cursor:
    print(f"Empleado {id_emp} - {apellidos}, {nombre} dado de alta el {fecha_alta}")

# Limpiamos la base de datos
cursor.execute("DROP SCHEMA prueba")
cursor.close()
mydb.close()
