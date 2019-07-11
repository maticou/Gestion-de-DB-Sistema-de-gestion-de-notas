import { Component, OnInit, Inject } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { AgregarAlumnoComponent } from '../../alumno/agregar-alumno/agregar-alumno.component';
import { EvaluacionService } from 'src/app/servicios/evaluacion.service';
import { CursoService } from 'src/app/servicios/curso.service';

@Component({
  selector: 'app-agregar-evaluacion',
  templateUrl: './agregar-evaluacion.component.html',
  styleUrls: ['./agregar-evaluacion.component.scss']
})
export class AgregarEvaluacionComponent implements OnInit {
  form: FormGroup;
  
  constructor(public thisDialogRef: MatDialogRef < AgregarAlumnoComponent > ,@Inject(MAT_DIALOG_DATA) public data: number,
  private evaluacionService: EvaluacionService, private cursoService: CursoService) { 

    this.form = new FormGroup({
      codigo: new FormControl(""),
      fecha: new FormControl(""),
      porcentaje: new FormControl(""),
      exigible: new FormControl(""),
      area: new FormControl(""),
      tipo: new FormControl(""),
      prorroga: new FormControl(""),
      ref_profesor: new FormControl(""),
      ref_instancia_curso: new FormControl("")
    });
  }

  ngOnInit() {
  }

  onCloseConfirm() {
    let datosEvaluacion = this.form.value;
    this.evaluacionService.agregarEvaluacion(datosEvaluacion).subscribe({
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
