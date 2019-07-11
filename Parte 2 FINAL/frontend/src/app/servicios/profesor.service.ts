import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Profesor } from '../clases/profesor';
import { Observable } from 'rxjs';
import { environment as env } from '../../environments/environment';
import { map } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class ProfesorService {

  constructor(private http: HttpClient) { }

  agregarProfesor(data: Profesor): Observable<boolean>{
    const body = new HttpParams()
    .set('rut', data.rut)
    .set('nombre', data.nombre)
    .set('apellido', data.apellido)
    .set('correo', data.correo)
    .set('telefono', data.telefono)

    console.log(body);
    return this.http.put<{ msg: string}>(env.api.concat("/profesor/agregar"), body)
    .pipe(
      map(result => {
        console.log(result.msg);
        return true;
      })
    );
  }

  obtenerDatosProfesor(rut: string): Observable<Profesor>{
    return this.http.get<Profesor>(env.api.concat("/profesor/obtener/"+rut))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  obtenerProfesores(): Observable<Profesor[]>{
    return this.http.get<Profesor[]>(env.api.concat("/profesor/obtener"))
    .pipe(
      map(result => {
        return result;
      })
    );
  }

  eliminarProfesor(rut: string){
    const body = new HttpParams()
    .set('rut', rut);

    return this.http.post<{ msg: string}>(env.api.concat("/profesor/eliminar/"+rut), body)
    .pipe(
      map(result =>{
        return true;
      })
    );
  }

  modificarProfesor(data: Profesor): Observable<boolean>{
    const body = new HttpParams()
    .set('rut', data.rut)
    .set('nombre', data.nombre)
    .set('apellido', data.apellido)
    .set('correo', data.correo)
    .set('telefono', data.telefono)

    return this.http.post<{ msg: string}>(env.api.concat("/profesor/modificar"), body)
    .pipe(
      map(result => {
        console.log(result);
        return true;
      })
    );
  }
}
