import { Component, OnInit, ViewChild } from '@angular/core';
import { VistaCurso } from 'src/app/clases/curso';
import { MatTableDataSource, MatSort, MatPaginator, MatDialog } from '@angular/material';
import { CursoService } from 'src/app/servicios/curso.service';

@Component({
  selector: 'app-cursos',
  templateUrl: './cursos.component.html',
  styleUrls: ['./cursos.component.scss']
})
export class CursosComponent implements OnInit {

  columnas: string[] = ["nombre", "seccion", "anio", "profesor", "evaluaciones"];
  dataSource: MatTableDataSource<VistaCurso>;

  constructor(private cursoService: CursoService, private dialog: MatDialog) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;
  
  ngOnInit() {
    this.obtenerCursos();
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

  refrescarTabla(){
    this.obtenerCursos();
  }

  obtenerCursos(){
    this.cursoService.obtenerVistaCursos().subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  verEvaluaciones(){
    console.log("Redirigir a lista de evaluaciones ");
  }

}
