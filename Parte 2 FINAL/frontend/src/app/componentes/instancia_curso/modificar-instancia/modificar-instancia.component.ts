import { Component, OnInit, Inject } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { CursoService } from 'src/app/servicios/curso.service';

@Component({
  selector: 'app-modificar-instancia',
  templateUrl: './modificar-instancia.component.html',
  styleUrls: ['./modificar-instancia.component.scss']
})
export class ModificarInstanciaComponent implements OnInit {
  form: FormGroup;

  constructor(public thisDialogRef: MatDialogRef < ModificarInstanciaComponent > ,@Inject(MAT_DIALOG_DATA) public data: number,
  private cursoService: CursoService) { 

    this.form = new FormGroup({
      id: new FormControl(""),
      periodo: new FormControl(""),
      seccion: new FormControl(""),
      anio: new FormControl(""),
      semestre: new FormControl(""),
      ref_profesor: new FormControl(""),
      ref_curso: new FormControl("")
    });
  }

  ngOnInit() {
    this.obtenerDatosInstancia();
  }

  obtenerDatosInstancia(){
    this.cursoService.obtenerDatosInstancia(this.data).subscribe({
      next: result => {
        this.form.get('id').setValue(result.id);
        this.form.get('periodo').setValue(result.periodo);
        this.form.get('seccion').setValue(result.seccion);
        this.form.get('anio').setValue(result.anio);
        this.form.get('semestre').setValue(result.semestre);
        this.form.get('ref_profesor').setValue(result.ref_profesor);
        this.form.get('ref_curso').setValue(result.ref_curso);
      },
      error: result => {
        console.log(result);
      }
    });
  }

  onCloseConfirm() {
    let datosInstancia = this.form.value;

    this.cursoService.modificarInstanciaCurso(datosInstancia).subscribe({
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
