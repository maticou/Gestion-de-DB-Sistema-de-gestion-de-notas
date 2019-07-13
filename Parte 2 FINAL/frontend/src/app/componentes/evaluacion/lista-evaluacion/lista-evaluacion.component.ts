import { Component, OnInit, ViewChild } from '@angular/core';
import { Evaluacion } from 'src/app/clases/evaluacion';
import { MatTableDataSource, MatDialog, MatSort, MatPaginator } from '@angular/material';
import { EvaluacionService } from 'src/app/servicios/evaluacion.service';
import { Router, ActivatedRoute } from '@angular/router';
import { AgregarEvaluacionComponent } from '../agregar-evaluacion/agregar-evaluacion.component';
import { ModificarEvaluacionComponent } from '../modificar-evaluacion/modificar-evaluacion.component';

@Component({
  selector: 'app-lista-evaluacion',
  templateUrl: './lista-evaluacion.component.html',
  styleUrls: ['./lista-evaluacion.component.scss']
})
export class ListaEvaluacionComponent implements OnInit {

  id_curso: number;
  columnas: string[] = ["codigo", "fecha", "porcentaje", "exigible", "area","tipo", "prorroga", "ref_profesor", "ref_instancia_curso", "detalles"];
  dataSource: MatTableDataSource<Evaluacion>;

  constructor(private evaluacionService: EvaluacionService, private dialog: MatDialog, private route: ActivatedRoute) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;
  
  ngOnInit() {
    this.id_curso = parseInt(this.route.snapshot.paramMap.get('id'));
    this.obtenerEvaluaciones();
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

  obtenerEvaluaciones(){
    this.evaluacionService.obtenerEvaluacionesCurso(this.id_curso).subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }
  refrescarTabla(){
    this.obtenerEvaluaciones();
  }

  agregarEvaluacion(){
    const dialogRef = this.dialog.open(AgregarEvaluacionComponent, {
      width: '500px',
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result === "Confirm"){
        this.refrescarTabla();
        console.log("La evaluación se registro correctamente");
      } 
    });
  }

  modificarEvaluacion(id_evaluacion: number){
    const dialogRef = this.dialog.open(ModificarEvaluacionComponent, {
      width: '500px',
      data: id_evaluacion,
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result === "Confirm"){
        this.refrescarTabla();
        console.log("La evaluación se modificó correctamente");
      } 
    });
  }

}
