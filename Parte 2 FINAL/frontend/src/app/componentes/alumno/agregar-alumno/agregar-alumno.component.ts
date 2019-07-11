import { Component, OnInit, Inject } from '@angular/core';
import { AlumnoService } from 'src/app/servicios/alumno.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-agregar-alumno',
  templateUrl: './agregar-alumno.component.html',
  styleUrls: ['./agregar-alumno.component.scss']
})
export class AgregarAlumnoComponent implements OnInit {
  form: FormGroup;
  
  constructor(public thisDialogRef: MatDialogRef < AgregarAlumnoComponent > ,@Inject(MAT_DIALOG_DATA) public data: string,
    private alumnoService: AlumnoService) { 

      this.form = new FormGroup({
        rut: new FormControl(""),
        nombre: new FormControl(""),
        apellido_paterno: new FormControl(""),
        apellido_materno: new FormControl(""),
        matricula_id: new FormControl(""),
        correo: new FormControl(""),
        telefono: new FormControl("")
      });
    }

  ngOnInit() {
  }

  onCloseConfirm() {
    let datosAlumno = this.form.value;
    this.alumnoService.agregarAlumno(datosAlumno).subscribe({
      next: result => {
        console.log(result);
        this.thisDialogRef.close('Confirm');
      },
      error: result => {}
    });
  }

  onCloseCancel() {
    this.thisDialogRef.close("Cancel");
  }

}
