# Gestion-de-DB-Sistema-de-gestion-de-notas

Este es un proyecto del curso Gestión de base de datos de la Universidad de Talca, facultad de ingeniería, que consta en crear una base de datos activa que contenga triggers, funciones, procedimientos almacenados y que pudiese ser consumida a través de una página web.

El proyecto se trata de un gestor de notas en el que un o varios alumnos se pueden inscribir en uno o varios cursos y un profesor puede crear evaluaciones, ingresar las notas de cada alumno y calcular la nota final de cada alumno, incluyendo el estado final del alumno (si aprueba o reprueba el curso). La base de datos activa tiene varias funciones relacionadas a los alumnos, profesores, cursos, instancia curso (secciones), evaluaciones, instancia evaluaciones y las tablas que relacionan varias de las entidades anteriores entre si.

En este repositorio se encuentran todos los archivos SQL que contienen los procedimientos almacenados, funciones, triggers y tablas que usa nuestra base de datos activa. Además contiene un archivo llamado Backup.sql que es el que contiene la base de datos ya construida y que se puede restaurar directamente desde este archivo en pgadmin.

Para que la base de datos activa pudiese ser consumida de manera más fácil y cómoda, se creó una página web usando Angular CLI y Expressjs
que contiene un menú con las funcionalidades básicas del sistema y navegando a través de este se encunetran las funcionalidades restantes.

Si desea descargar el repositorio y usarlo, debe instalar PostgreSQL junto con pgadmin, node.js, angular CLI desde consola después de haber instalado nodejs, y realizar el comando "npm install" en el front-end y back-end de la aplicación. Porfavor leer el documento "Manual de instalación.pdf" para instrucciones con mayor detalle.

Atentamente, Matías Parra @maticou y Manuel González @mn-gonzalez , desarrolladores del repositorio.
