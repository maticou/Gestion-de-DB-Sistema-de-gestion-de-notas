import { Component, OnInit, ViewChild } from '@angular/core';
import { Evaluacion } from 'src/app/clases/evaluacion';
import { MatTableDataSource, MatDialog, MatSort, MatPaginator } from '@angular/material';
import { EvaluacionService } from 'src/app/servicios/evaluacion.service';
import { ActivatedRoute } from '@angular/router';

@Component({
  selector: 'app-evaluaciones',
  templateUrl: './evaluaciones.component.html',
  styleUrls: ['./evaluaciones.component.scss']
})
export class EvaluacionesComponent implements OnInit {

  matricula: number;
  id_instancia: number;
  columnas: string[] = ["tipo", "exigible", "fecha", "porcentaje", "nota"];
  dataSource: MatTableDataSource<Evaluacion>;

  constructor(private evaluacionService: EvaluacionService, private dialog: MatDialog,  private route: ActivatedRoute) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;

  ngOnInit() {
    this.matricula = parseInt(this.route.snapshot.paramMap.get('matricula'));
    this.id_instancia = parseInt(this.route.snapshot.paramMap.get('id'));
    this.obtenerEvaluaciones(this.id_instancia, this.matricula);
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
