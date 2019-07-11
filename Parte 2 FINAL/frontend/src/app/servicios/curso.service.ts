import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment as env } from '../../environments/environment';
import { map } from 'rxjs/operators';
import { Curso, CursoAlumno } from '../clases/curso';
import { Instancia_curso } from '../clases/instancia_curso';

@Injectable({
  providedIn: 'root'
})
export class CursoService {

  constructor(private http: HttpClient) { }

  agregarCurso(data: Curso): Observable<boolean>{
    const body = new HttpParams()
    .set('nombre', data.nombre)
    .set('carrera', data.carrera)
    .set('ref_profesor', data.ref_profesor_encargado)

    return this.http.put<{ msg: string}>(env.api.concat("/curso/agregar"), body)
    .pipe(
      map(result => {
        console.log(result.msg);
        return true;
      })
    );
  }

  obtenerDatosCurso(codigo: number): Observable<Curso>{
    return this.http.get<Curso>(env.api.concat("/curso/obtener/"+codigo))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  obtenerCursos(): Observable<Curso[]>{
    return this.http.get<Curso[]>(env.api.concat("/curso/obtener"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  modificarCurso(data: Curso): Observable<boolean>{
    const body = new HttpParams()
    .set('codigo', data.codigo.toString())
    .set('nombre', data.nombre)
    .set('carrera', data.carrera)
    .set('ref_profesor_encargado', data.ref_profesor_encargado)

    return this.http.post<{ msg: string}>(env.api.concat("/curso/modificar"), body)
    .pipe(
      map(result => {
        console.log(result);
        return true;
      })
    );
  }

  obtenerVistaCursos(matricula: number): Observable<CursoAlumno[]>{
    return this.http.get<CursoAlumno[]>(env.api.concat("/cursoAlumno/obtener/cursos-alumno/"+matricula))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  agregarInstanciaCurso(data: Instancia_curso): Observable<Boolean>{
    const body = new HttpParams()
    .set('periodo', '0')
    .set('seccion', data.seccion)
    .set('ref_profesor', data.ref_profesor)
    .set('ref_curso', data.ref_curso.toString())
    .set('anio', data.anio.toString())
    .set('semestre', data.semestre)

    console.log(body);
    return this.http.put<{ msg: string}>(env.api.concat("/curso/agregarInstancia"), body)
    .pipe(
      map(result => {
        console.log(result);
        return true;
      })
    );
  }

  obtenerInstanciasCurso(id_curso: number) : Observable<Instancia_curso[]>{
    return this.http.get<Instancia_curso[]>(env.api.concat("/curso/obtener/instancias/"+id_curso))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  obtenerDatosInstancia(id: number) : Observable<Instancia_curso>{
    return this.http.get<Instancia_curso>(env.api.concat("/curso/obtener/instancia/"+id))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  eliminarInstanciaCurso(id: number): Observable<Boolean>{
    const body = new HttpParams()
    return this.http.post<{ msg: string}>(env.api.concat("/curso/eliminarInstancia/"+id), body)
    .pipe(
      map(result => {
        console.log(result);
        return true;
      })
    );
  }

  modificarInstanciaCurso(data: Instancia_curso): Observable<Boolean>{
    const body = new HttpParams()
    .set('id', data.id.toString())
    .set('periodo', data.periodo.toString())
    .set('seccion', data.seccion)
    .set('anio', data.anio.toString())
    .set('semestre', data.semestre)
    .set('ref_profesor', data.ref_profesor)
    .set('ref_curso', data.ref_curso.toString())

    return this.http.post<{ msg: string}>(env.api.concat("/curso/modificarInstancia"), body)
    .pipe(
      map(result => {
        console.log(result);
        return true;
      })
    );
  }
}
