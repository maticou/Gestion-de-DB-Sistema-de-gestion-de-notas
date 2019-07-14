export class Alumno{
    matricula_alumno: number;
    nombre_alumno: string;
    apellido_paterno: string;
    promedio_final: number;
    cantidad_cursos_aprobados: number;
    cantidad_cursos_reprobados: number;
}

export class Profesor{
    rut: string; 
    nombre_profesor:string; 
    apellido: string; 
    cantidad_cursos_dictados: number;
    cantidad_alumnos_reprobados: number;
    cantidad_alumnos_aprobados: number;
}

export class Curso{
    codigo_del_curso: number; 
    nombre_del_curso: string;
    porcentaje_alumnos_reprobados: number;
}

    