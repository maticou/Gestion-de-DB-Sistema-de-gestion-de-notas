import { Component, OnInit, ViewChild } from '@angular/core';
import { MatTableDataSource, MatSort, MatPaginator } from '@angular/material';
import { CursoAlumno } from 'src/app/clases/curso';
import { CursoService } from 'src/app/servicios/curso.service';
import { Router, ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-historial-cursos',
  templateUrl: './historial-cursos.component.html',
  styleUrls: ['./historial-cursos.component.scss']
})
export class HistorialCursosComponent implements OnInit {

  matricula: number;
  id_instancia: number;
  columnas: string[] = ["nombre", "seccion", "anio", "profesor", "evaluaciones"];
  dataSource: MatTableDataSource<CursoAlumno>;

  constructor(private cursoService: CursoService, public router: Router) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;
  
  ngOnInit() {
    this.obtenerCursos(this.matricula);
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

  refrescarTabla(){
    this.obtenerCursos(this.matricula);
  }

  obtenerCursos(matricula: number){
    this.cursoService.obtenerVistaCursos(matricula).subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  verEvaluaciones(codigo: number){
    this.router.navigate(['vista-alumno/evaluaciones/'+codigo+'/'+this.matricula]);
  }
}
