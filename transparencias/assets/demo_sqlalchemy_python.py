# Para instalar las librerías:
# pip install sqlalchemy pymysql
#
# Asegúrate de tener ejecutándose una instancia de MySQL con una base de datos llamada alchemy:
# docker run --name mysql -e MYSQL_ROOT_PASSWORD=sqlalchemy -e MYSQL_DATABASE=alchemy -p 3306:3306 -d mysql:5.7

# Configurando la conexión con el SGBD
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://root:sqlalchemy@127.0.0.1:3306/alchemy",
)

# Definiendo los modelos
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

from sqlalchemy import Column, Table, ForeignKey
from sqlalchemy.types import Integer, String, DateTime
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship

# Definimos la tabla de asociación para la relación N:M

tabla_asoc = Table('visualiza', Base.metadata,
   Column('id_usuario', ForeignKey('usuarios.id'), primary_key=True),
   Column('id_capitulo', ForeignKey('capitulos.id'), primary_key=True)
)

class Usuario(Base):
   # Nombre de la tabla que se creará en la BD
   __tablename__ = "usuarios"

   # Atributos del modelo (columnas de la tabla)
   id = Column(Integer, primary_key=True, autoincrement="auto")
   alias = Column(String(255), unique=True, nullable=False)
   fecha_alta = Column(DateTime, server_default=func.now())

   capitulos = relationship("Capitulo", secondary=tabla_asoc, backref="usuarios")

   def __repr__(self):
      return f"<Usuario: {self.alias}>"

class Serie(Base):
   __tablename__ = "series"

   id = Column(Integer, primary_key=True, autoincrement="auto")
   titulo = Column(String(500), nullable=False)
   genero = Column(String(150), nullable=False)
   fecha_alta = Column(DateTime, server_default=func.now())

   def __repr__(self):
      return f"<Serie '{self.titulo}'>"

class Capitulo(Base):
   __tablename__ = "capitulos"

   id = Column(Integer, primary_key=True, autoincrement="auto")
   titulo = Column(String(500), nullable=False)
   duracion = Column(Integer, nullable=False)
   id_serie = Column(Integer, ForeignKey("series.id")) # Referencia a nombre de tabla

   serie = relationship("Serie", backref="capitulos") # Referencia a nombre de la clase

   def __repr__(self):
      return f"<Capítulo '{self.titulo}' ({self.serie})>"

# Se lanza la generación de todas las tablas
Base.metadata.create_all(engine)

# Abrimos una sesión de conexión con el SGBD
from sqlalchemy.orm import sessionmaker
Session = sessionmaker(bind=engine)
session = Session()

# Creando un nuevo usuario
u1 = Usuario(
   alias="Carlos Boyero"
)
session.add(u1)
session.commit()

# Creando una nueva serie:
perdidos = Serie(titulo="Lost", genero="Ciencia Ficción")
session.add(perdidos)
session.commit()

# Creando y vinculando dos capítulos de Perdidos
s01e01 = Capitulo(titulo="Pilot, Part 1", duracion=42, id_serie=perdidos.id)
s01e02 = Capitulo(titulo="Pilot, Part 2", duracion=41, id_serie=perdidos.id)
session.add(s01e01)
session.add(s01e02)
session.commit()

# Añadimos la visualización del capítulo 1 al usuario
u1.capitulos.append(s01e01)
session.commit()

# Consultas
caps = session.query(Capitulo).all()
for c in caps:
   print(c)

# Borrado
session.delete(s01e02)
session.commit()

session.close()
