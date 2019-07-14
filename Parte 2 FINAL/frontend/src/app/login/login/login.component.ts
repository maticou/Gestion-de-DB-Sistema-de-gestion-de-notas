import { Component, OnInit } from '@angular/core';
import { LoginService } from 'src/app/servicios/login.service';
import { FormGroup, FormControl } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  alumno: FormGroup;
  profesor: FormGroup;

  usuario: string = 'NULL';
  tipo_usuario: string;

  constructor(private loginService: LoginService, public router: Router) { 

    this.alumno = new FormGroup({
      matricula: new FormControl(""),
      contrasena: new FormControl("")
    });

    this.profesor = new FormGroup({
      rut: new FormControl(""),
      contrasena: new FormControl("")
    });
  }

  ngOnInit() {
  }

  ingresar_como_alumno(){
    let datos = this.alumno.value;

    this.loginService.ingresar_como_alumno(datos).subscribe({
      next: (result) => {this.usuario = result.results; 
        this.tipo_usuario = result.tipo;
        if(this.usuario == 'NULL'){
          console.log("El usuario o la clave son incorrectos");
        }
        else{
          this.router.navigate(['vista-alumno/'+this.usuario])
        }
      },
      error: (err) => {console.log(err)}
    });
  }

  ingresar_como_profesor(){
    let datos = this.profesor.value;
    this.loginService.ingresar_como_profesor(datos).subscribe({
      next: (result) => {this.usuario = result.results; 
        this.tipo_usuario = result.tipo; 
        if(this.usuario == 'NULL'){
          console.log("El usuario o la clave son incorrectos");
        }
        else{
          this.router.navigate(['vista-profesor/'+this.usuario])
        }},
      error: (err) => {console.log(err)}
    });
  }

}
