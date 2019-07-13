import { Component, OnInit, Inject } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { AgregarAlumnoComponent } from '../../alumno/agregar-alumno/agregar-alumno.component';
import { EvaluacionService } from 'src/app/servicios/evaluacion.service';

@Component({
  selector: 'app-modificar-evaluacion',
  templateUrl: './modificar-evaluacion.component.html',
  styleUrls: ['./modificar-evaluacion.component.scss']
})
export class ModificarEvaluacionComponent implements OnInit {

  form: FormGroup;

  constructor(public thisDialogRef: MatDialogRef < AgregarAlumnoComponent > ,@Inject(MAT_DIALOG_DATA) public data: number,
  private evaluacionService: EvaluacionService) { 

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
    this.obtenerDatosCurso();
  }

  obtenerDatosCurso(){
    this.evaluacionService.obtenerDatosEvaluacion(this.data).subscribe({
      next: result => {
        this.form.get('codigo').setValue(this.data);
        this.form.get('fecha').setValue(result.fecha);
        this.form.get('porcentaje').setValue(result.porcentaje);
        this.form.get('exigible').setValue(result.exigible);
        this.form.get('area').setValue(result.area);
        this.form.get('tipo').setValue(result.tipo);
        this.form.get('prorroga').setValue(result.prorroga);
        this.form.get('ref_profesor').setValue(result.ref_profesor);
        this.form.get('ref_instancia_curso').setValue(result.ref_instancia_curso);
      },
      error: result => {
        console.log(result);
      }
    });
  }

  onCloseConfirm() {
    let datosEvaluacion = this.form.value;
    this.evaluacionService.modificarEvaluacion(datosEvaluacion).subscribe({
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
