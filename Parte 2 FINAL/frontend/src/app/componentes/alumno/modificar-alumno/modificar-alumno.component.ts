import { Component, OnInit, Inject } from '@angular/core';
import { AlumnoService } from 'src/app/servicios/alumno.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-modificar-alumno',
  templateUrl: './modificar-alumno.component.html',
  styleUrls: ['./modificar-alumno.component.scss']
})
export class ModificarAlumnoComponent implements OnInit {
  form: FormGroup;

  constructor(public thisDialogRef: MatDialogRef < ModificarAlumnoComponent > ,@Inject(MAT_DIALOG_DATA) public data: number,
  private alumnoService: AlumnoService) { 

    this.form = new FormGroup({
      matricula_id: new FormControl(""),
      rut: new FormControl(""),
      nombre: new FormControl(""),
      apellido_paterno: new FormControl(""),
      apellido_materno: new FormControl(""),
      correo: new FormControl(""),
      telefono: new FormControl("")
    });
  }

  ngOnInit() {
    this.obtenerDatosAlumno(this.data);
  }

  obtenerDatosAlumno(matricula: number){
    this.alumnoService.obtenerDatosAlumno(matricula).subscribe({
      next: result => {
        this.form.get('matricula_id').setValue(result.matricula_id);
        this.form.get('rut').setValue(result.rut);
        this.form.get('nombre').setValue(result.nombre);
        this.form.get('apellido_paterno').setValue(result.apellido_paterno);
        this.form.get('apellido_materno').setValue(result.apellido_materno);
        this.form.get('correo').setValue(result.correo);
        this.form.get('telefono').setValue(result.telefono);
      },
      error: result => {
        console.log(result);
      }
    });
  }

  onCloseConfirm() {
    let datosAlumno = this.form.value;
    this.alumnoService.modificarAlumno(datosAlumno).subscribe({
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
