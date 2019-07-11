import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { environment as env } from '../../environments/environment';
import { map } from 'rxjs/operators';
import { Observable } from "rxjs";
import { Alumno } from '../clases/alumno';

@Injectable({
  providedIn: 'root'
})
export class AlumnoService {

  constructor(private http: HttpClient) { }

  agregarAlumno(data: Alumno): Observable<boolean>{
    const body = new HttpParams()
    .set('matricula_id', data.matricula_id.toString())
    .set('rut', data.rut)
    .set('nombre', data.nombre)
    .set('apellido_paterno', data.apellido_paterno)
    .set('apellido_materno', data.apellido_materno)
    .set('correo', data.correo)
    .set('telefono', data.telefono.toString())

    console.log(body);
    return this.http.put<{ msg: string}>(env.api.concat("/alumno/agregar"), body)
    .pipe(
      map(result => {
        console.log(result.msg);
        return true;
      })
    );
  }

  obtenerDatosAlumno(matricula: number): Observable<Alumno>{
    return this.http.get<Alumno>(env.api.concat("/alumno/obtener/"+matricula))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  obtenerAlumnos(): Observable<Alumno[]>{
    return this.http.get<Alumno[]>(env.api.concat("/alumno/obtener"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  eliminarAlumno(matricula: number){
    const body = new HttpParams()
    .set('matricula_id', matricula.toString());

    return this.http.post<{ msg: string}>(env.api.concat("/alumno/eliminar/"+matricula), body)
    .pipe(
      map(result =>{
        return true;
      })
    );
  }

  modificarAlumno(data: Alumno): Observable<boolean>{
    console.log(data);
    const body = new HttpParams()
    .set('matricula_id', data.matricula_id.toString())
    .set('rut', data.rut)
    .set('nombre', data.nombre)
    .set('apellido_paterno', data.apellido_paterno)
    .set('apellido_materno', data.apellido_materno)
    .set('correo', data.correo)
    .set('telefono', data.telefono.toString())

    return this.http.post<{ msg: string}>(env.api.concat("/alumno/modificar"), body)
    .pipe(
      map(result => {
        console.log(result);
        return true;
      })
    );
  }
}
