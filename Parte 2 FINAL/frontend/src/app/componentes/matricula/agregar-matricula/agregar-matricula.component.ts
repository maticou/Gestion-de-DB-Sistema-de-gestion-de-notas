import { Component, OnInit, Inject } from '@angular/core';
import { MatriculaService } from 'src/app/servicios/matricula.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-agregar-matricula',
  templateUrl: './agregar-matricula.component.html',
  styleUrls: ['./agregar-matricula.component.scss']
})
export class AgregarMatriculaComponent implements OnInit {
  form: FormGroup;

  constructor(public thisDialogRef: MatDialogRef < AgregarMatriculaComponent > ,@Inject(MAT_DIALOG_DATA) public data: number,
  private matriculaService: MatriculaService) { 

    this.form = new FormGroup({
      ref_alumno: new FormControl(""),
      ref_instancia_curso: new FormControl(this.data),
    });
  }

  ngOnInit() {
  }

  onCloseConfirm() {
    let datosAlumno = this.form.value;
    this.matriculaService.agregarMatricula(datosAlumno).subscribe({
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
