import { Component, OnInit, Inject } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { CursoService } from 'src/app/servicios/curso.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';

@Component({
  selector: 'app-agregar-curso',
  templateUrl: './agregar-curso.component.html',
  styleUrls: ['./agregar-curso.component.scss']
})
export class AgregarCursoComponent implements OnInit {
  form: FormGroup;

  constructor(public thisDialogRef: MatDialogRef < AgregarCursoComponent > ,@Inject(MAT_DIALOG_DATA) public data: string,
    private cursoService: CursoService) { 

      this.form = new FormGroup({
        nombre: new FormControl(""),
        carrera: new FormControl(""),
        ref_profesor_encargado: new FormControl("")
      });
    }

  ngOnInit() {
  }

  onCloseConfirm() {
    let datosCurso = this.form.value;
    this.cursoService.agregarCurso(datosCurso).subscribe({
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
