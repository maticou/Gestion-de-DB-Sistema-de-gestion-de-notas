export class Evaluacion{
    codigo: number;
    fecha: string;
    porcentaje: number;
    exigible: number;
    area: string;
    tipo: string;
    prorroga: string;
    ref_profesor: string;
    ref_instancia_curso: number;
}

export class Instancia_evaluacion{
    codigo: number;
    ref_alumno: number;
    ref_evaluacion: number;
    nota: number;
    ref_instancia_curso: number;
}