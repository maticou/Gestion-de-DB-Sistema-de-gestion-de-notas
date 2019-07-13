import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { environment as env } from '../../environments/environment';
import { map } from 'rxjs/operators';
import { Observable } from "rxjs";
import { Evaluacion } from '../clases/evaluacion';

@Injectable({
  providedIn: 'root'
})
export class EvaluacionService {

  /*
    Crear tabla evaluacion
    Crear tabla instancia_evaluacion
    Actualizar los metodos agregar, eliminar y modificar del backend
    Modificar clases del frontend.
  */
  constructor(private http: HttpClient) { }

  agregarEvaluacion(data: Evaluacion): Observable<boolean>{
    const body = new HttpParams()
    .set('fecha', data.fecha)
    .set('porcentaje', data.porcentaje.toString())
    .set('exigible', data.exigible.toString())
    .set('area', data.area)
    .set('tipo', data.tipo)
    .set('prorroga', data.prorroga)
    .set('ref_profesor', data.ref_profesor)
    .set('ref_instancia_curso', data.ref_instancia_curso.toString())

    console.log(body);
    return this.http.put<{ msg: string}>(env.api.concat("/evaluacion/agregar"), body)
    .pipe(
      map(result => {
        console.log(result.msg);
        return true;
      })
    );
  }

  obtenerDatosEvaluacion(codigo: number): Observable<Evaluacion>{
    return this.http.get<Evaluacion>(env.api.concat("/evaluacion/obtener/"+codigo))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  obtenerEvaluaciones(): Observable<Evaluacion[]>{
    return this.http.get<Evaluacion[]>(env.api.concat("/evaluacion/obtener"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  obtenerEvaluacionesCurso(codigo: number):  Observable<Evaluacion[]>{
    return this.http.get<Evaluacion[]>(env.api.concat("/curso/obtener/evaluaciones/"+codigo))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  modificarEvaluacion(data: Evaluacion): Observable<boolean>{
    const body = new HttpParams()
    .set('codigo', data.codigo.toString())
    .set('fecha', data.fecha)
    .set('porcentaje', data.porcentaje.toString())
    .set('exigible', data.exigible.toString())
    .set('area', data.area)
    .set('tipo', data.tipo)
    .set('prorroga', data.prorroga)
    .set('ref_profesor', data.ref_profesor)
    .set('ref_instancia_curso', data.ref_instancia_curso.toString())

    return this.http.post<{ msg: string}>(env.api.concat("/evaluacion/modificar"), body)
    .pipe(
      map(result => {
        console.log(result);
        return true;
      })
    );
  }

  evaluacionesAlumno(codigo: number, matricula: number){
    return this.http.get<Evaluacion[]>(env.api.concat("/evaluacion/obtener/evaluacionesAlumno/"+codigo+"/"+matricula))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  ingresarNota(data: any): Observable<Boolean>{
    const body = new HttpParams()
    .set('nota', data.nota.toString())
    .set('ref_alumno', data.ref_alumno.toString())
    .set('ref_instancia_curso', data.ref_instancia_curso.toString())
    .set('ref_evaluacion', data.ref_evaluacion.toString())

    return this.http.post<{ msg: string}>(env.api.concat("/evaluacion/ingresarNota"), body)
    .pipe(
      map(result => {
        console.log(result);
        return true;
      })
    );
  }
}
