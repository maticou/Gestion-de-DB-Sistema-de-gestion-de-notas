export class Curso{
    codigo: number;
    nombre: string;
    carrera: string;
    ref_profesor_encargado: string;
}

export class CursoAlumno{
    codigo: number;
    nombre: string;
    seccion: string;
    anio: string;
    semestre: string;
    profesor: string;
}