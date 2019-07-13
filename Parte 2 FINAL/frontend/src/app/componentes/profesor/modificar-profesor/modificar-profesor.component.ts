import { Component, OnInit, Inject } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { ProfesorService } from 'src/app/servicios/profesor.service';

@Component({
  selector: 'app-modificar-profesor',
  templateUrl: './modificar-profesor.component.html',
  styleUrls: ['./modificar-profesor.component.scss']
})
export class ModificarProfesorComponent implements OnInit {
  form: FormGroup;
  
  constructor(public thisDialogRef: MatDialogRef < ModificarProfesorComponent > ,@Inject(MAT_DIALOG_DATA) public data: string,
  private profesorService: ProfesorService) { 

    this.form = new FormGroup({
      rut: new FormControl(""),
      nombre: new FormControl(""),
      apellido: new FormControl(""),
      telefono: new FormControl(""),
      correo: new FormControl(""),
    });
  }

  ngOnInit() {
    this.obtenerDatosProfesor(this.data);
  }

  obtenerDatosProfesor(rut: string){
    this.profesorService.obtenerDatosProfesor(rut).subscribe({
      next: result => {
        this.form.get('rut').setValue(result.rut);
        this.form.get('nombre').setValue(result.nombre);
        this.form.get('apellido').setValue(result.apellido);
        this.form.get('telefono').setValue(result.telefono);
        this.form.get('correo').setValue(result.correo);
      },
      error: result => {
        console.log(result);
      }
    });
  }

  onCloseConfirm() {
    let datosProfesor = this.form.value;
    this.profesorService.modificarProfesor(datosProfesor).subscribe({
      next: result => {
        this.thisDialogRef.close('Confirm');
      },
      error: result => {}
    });
  }

  onCloseCancel() {
    this.thisDialogRef.close("Cancel");
  }

}
