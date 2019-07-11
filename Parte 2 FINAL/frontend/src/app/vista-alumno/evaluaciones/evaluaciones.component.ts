import { Component, OnInit, ViewChild } from '@angular/core';
import { Evaluacion } from 'src/app/clases/evaluacion';
import { MatTableDataSource, MatDialog, MatSort, MatPaginator } from '@angular/material';
import { EvaluacionService } from 'src/app/servicios/evaluacion.service';

@Component({
  selector: 'app-evaluaciones',
  templateUrl: './evaluaciones.component.html',
  styleUrls: ['./evaluaciones.component.scss']
})
export class EvaluacionesComponent implements OnInit {

  columnas: string[] = ["tipo", "exigible", "fecha", "porcentaje", "nota"];
  dataSource: MatTableDataSource<Evaluacion>;

  constructor(private evaluacionService: EvaluacionService, private dialog: MatDialog) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;

  ngOnInit() {
    //obtenerEvaluaciones();
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

  obtenerEvaluaciones(codigo: number, matricula: number){
    this.evaluacionService.evaluacionesAlumno(codigo, matricula).subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }

}
