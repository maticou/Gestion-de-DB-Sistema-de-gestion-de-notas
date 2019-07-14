import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { environment as env } from '../../environments/environment';
import { map } from 'rxjs/operators';
import { Observable } from "rxjs";

@Injectable({
  providedIn: 'root'
})
export class LoginService {

  constructor(private http: HttpClient) { 

  }

  ingresar_como_alumno(data: any): Observable<{results: string, tipo:string}>{
    const body = new HttpParams()
    .set('alumno_id', data.matricula)
    .set('contrasena', data.contrasena)

    return this.http.post<{results: string, tipo:string}>(env.api.concat("/login/alumno"), body)
    .pipe(
      map(result => {
        console.log(result);
        return result;
      })
    );
  }

  ingresar_como_profesor(data: any): Observable<{results: string, tipo:string}>{
    const body = new HttpParams()
    .set('profesor_id', data.rut)
    .set('contrasena', data.contrasena)

    return this.http.post<{results: string, tipo:string}>(env.api.concat("/login/profesor"), body)
    .pipe(
      map(result => {
        console.log(result);
        return result;
      })
    );
  }
}
