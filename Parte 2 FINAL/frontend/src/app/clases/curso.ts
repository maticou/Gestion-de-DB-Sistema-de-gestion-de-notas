export class Curso{
    codigo: number;
    nombre: string;
    carrera: string;
    ref_profesor_encargado: string;
}

export class CursoAlumno{
    id_instancia: number;
    nombre_del_curso: string;
    seccion: string;
    anio: string;
    semestre: string;
    nombre_profesor_encargado: string;
}