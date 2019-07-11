import { Component, OnInit, Inject } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { CursoService } from 'src/app/servicios/curso.service';

@Component({
  selector: 'app-modificar-curso',
  templateUrl: './modificar-curso.component.html',
  styleUrls: ['./modificar-curso.component.scss']
})
export class ModificarCursoComponent implements OnInit {
  form: FormGroup;

  constructor(public thisDialogRef: MatDialogRef < ModificarCursoComponent > ,@Inject(MAT_DIALOG_DATA) public data: number,
  private cursoService: CursoService) { 

    this.form = new FormGroup({
      nombre: new FormControl(""),
      carrera: new FormControl(""),
      ref_profesor_encargado: new FormControl("")
    });
  }

  ngOnInit() {
    this.obtenerDatosCurso(this.data);
  }

  obtenerDatosCurso(codigo: number){
    this.cursoService.obtenerDatosCurso(codigo).subscribe({
      next: result => {
        this.form.get('codigo').setValue(result.codigo);
        this.form.get('nombre').setValue(result.nombre);
        this.form.get('carrera').setValue(result.carrera);
        this.form.get('ref_profesor_encargado').setValue(result.ref_profesor_ecargado);
      },
      error: result => {
        console.log(result);
      }
    });
  }

  onCloseConfirm() {
    let datosCurso = this.form.value;
    this.cursoService.modificarCurso(datosCurso).subscribe({
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
