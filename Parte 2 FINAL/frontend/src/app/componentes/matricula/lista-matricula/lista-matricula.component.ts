import { Component, OnInit, ViewChild } from '@angular/core';
import { Matricula } from 'src/app/clases/matricula';
import { MatTableDataSource, MatDialog, MatSort, MatPaginator } from '@angular/material';
import { MatriculaService } from 'src/app/servicios/matricula.service';

@Component({
  selector: 'app-lista-matricula',
  templateUrl: './lista-matricula.component.html',
  styleUrls: ['./lista-matricula.component.scss']
})
export class ListaMatriculaComponent implements OnInit {

  columnas: string[] = ["codigo_matricula", "nota_final", "ref_alumno", "ref_instancia_curso", "situacion", "detalles","eliminar"];
  dataSource: MatTableDataSource<Matricula>;

  constructor(private matriculaService: MatriculaService, private dialog: MatDialog) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;

  ngOnInit() {
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

}
