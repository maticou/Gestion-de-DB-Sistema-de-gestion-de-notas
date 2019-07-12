import { Component, OnInit, Inject } from '@angular/core';
import { EvaluacionService } from 'src/app/servicios/evaluacion.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { FormControl, FormGroup } from '@angular/forms';

@Component({
  selector: 'app-ingresar-nota',
  templateUrl: './ingresar-nota.component.html',
  styleUrls: ['./ingresar-nota.component.scss']
})
export class IngresarNotaComponent implements OnInit {

  form: FormGroup;

  constructor(public thisDialogRef: MatDialogRef < IngresarNotaComponent > ,@Inject(MAT_DIALOG_DATA) public data: any,
  private evaluacionService: EvaluacionService) { 

    this.form = new FormGroup({
      nota: new FormControl(""),
      ref_alumno: new FormControl(this.data.ref_alumno),
      ref_evaluacion: new FormControl(this.data.ref_evaluacion),
      ref_instancia_curso: new FormControl(this.data.ref_instancia_curso),
    });
  }

  ngOnInit() {
  }

  onCloseConfirm() {
    let datosNota = this.form.value;
    this.evaluacionService.ingresarNota(datosNota).subscribe({
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
