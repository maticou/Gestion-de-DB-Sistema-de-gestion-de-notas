import { Component, OnInit, Inject } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { ProfesorService } from 'src/app/servicios/profesor.service';

@Component({
  selector: 'app-agregar-profesor',
  templateUrl: './agregar-profesor.component.html',
  styleUrls: ['./agregar-profesor.component.scss']
})
export class AgregarProfesorComponent implements OnInit {
  form: FormGroup;

  constructor(public thisDialogRef: MatDialogRef < AgregarProfesorComponent > ,@Inject(MAT_DIALOG_DATA) public data: string,
    private profesorService: ProfesorService) { 

      this.form = new FormGroup({
        rut: new FormControl(""),
        nombre: new FormControl(""),
        apellido: new FormControl(""),
        telefono: new FormControl(""),
        correo: new FormControl("")
      });
    }

  ngOnInit() {
  }

  onCloseConfirm() {
    let datosProfesor = this.form.value;
    this.profesorService.agregarProfesor(datosProfesor).subscribe({
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
