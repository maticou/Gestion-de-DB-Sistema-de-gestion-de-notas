import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { CursoService } from 'src/app/servicios/curso.service';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-agregar-instancia',
  templateUrl: './agregar-instancia.component.html',
  styleUrls: ['./agregar-instancia.component.scss']
})
export class AgregarInstanciaComponent implements OnInit {
  form: FormGroup;

  constructor(public thisDialogRef: MatDialogRef < AgregarInstanciaComponent > ,@Inject(MAT_DIALOG_DATA) public data: number,
  private cursoService: CursoService) { 

    this.form = new FormGroup({
      seccion: new FormControl(""),
      anio: new FormControl(""),
      semestre: new FormControl(""),
      ref_profesor: new FormControl(""),
      ref_curso: new FormControl("")
    });
  }

  ngOnInit() {
  }

  onCloseConfirm() {
    let datosInstancia = this.form.value;
    this.form.get('ref_curso').setValue(this.data);
    this.cursoService.agregarInstanciaCurso(datosInstancia).subscribe({
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
