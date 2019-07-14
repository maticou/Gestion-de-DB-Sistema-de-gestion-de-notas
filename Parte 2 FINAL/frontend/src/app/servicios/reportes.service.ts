import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { environment as env } from '../../environments/environment';
import { map } from 'rxjs/operators';
import { Observable } from "rxjs";
import { Alumno, Profesor, Curso } from 'src/app/clases/clases-reportes';

@Injectable({
  providedIn: 'root'
})
export class ReportesService {

  constructor(private http: HttpClient) { 

  }

  porcentaje_alumnos_que_toman_cursos(): Observable<{msg: string}>{
    return this.http.get<{msg : string}>(env.api.concat("/reportes/porcentaje_alumnos_que_toman_cursos"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  alumnos_con_mejor_promedio(): Observable<Alumno[]>{
    return this.http.get<Alumno[]>(env.api.concat("/reportes/alumnos_con_mejor_promedio"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  alumnos_con_peor_promedio(): Observable<Alumno[]>{
    return this.http.get<Alumno[]>(env.api.concat("/reportes/alumnos_con_peor_promedio"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  alumnos_con_mas_cursos_aprobados(): Observable<Alumno[]>{
    return this.http.get<Alumno[]>(env.api.concat("/reportes/alumnos_con_mas_cursos_aprobados"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  alumnos_con_mas_cursos_reprobados(): Observable<Alumno[]>{
    return this.http.get<Alumno[]>(env.api.concat("/reportes/alumnos_con_mas_cursos_reprobados"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  numero_cursos_dictados_por_profesor(): Observable<Profesor[]>{
    return this.http.get<Profesor[]>(env.api.concat("/reportes/numero_cursos_dictados_por_profesor"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  profesores_con_numero_de_aprobados(): Observable<Profesor[]>{
    return this.http.get<Profesor[]>(env.api.concat("/reportes/profesores_con_numero_de_aprobados"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  profesores_con_numero_de_reprobados(): Observable<Profesor[]>{
    return this.http.get<Profesor[]>(env.api.concat("/reportes/profesores_con_numero_de_reprobados"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  cursos_con_porcentaje_de_reprobados(): Observable<Curso[]>{
    return this.http.get<Curso[]>(env.api.concat("/reportes/cursos_con_porcentaje_de_reprobados"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  porcentaje_aprobado_y_reprobado_de_una_seccion(id_instancia: number): Observable<{msg: string}>{
    return this.http.get<{msg : string}>(env.api.concat("/reportes/porcentaje_aprobado_y_reprobado_de_una_seccion/"+id_instancia))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  promedio_de_una_seccion(id_instancia: number): Observable<{msg: string}>{
    return this.http.get<{msg : string}>(env.api.concat("/reportes/promedio_de_una_seccion/"+id_instancia))
    .pipe(
      map(result => {
        return result;
      })
    );
  }
}
