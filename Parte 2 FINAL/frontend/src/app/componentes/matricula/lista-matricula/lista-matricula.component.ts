import { Component, OnInit, ViewChild } from '@angular/core';
import { Matricula } from 'src/app/clases/matricula';
import { MatTableDataSource, MatDialog, MatSort, MatPaginator } from '@angular/material';
import { MatriculaService } from 'src/app/servicios/matricula.service';
import { Observable } from 'rxjs';
import { Alumno } from 'src/app/clases/alumno';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-lista-matricula',
  templateUrl: './lista-matricula.component.html',
  styleUrls: ['./lista-matricula.component.scss']
})
export class ListaMatriculaComponent implements OnInit {

  id_curso: number;
  columnas: string[] = ["matricula", "rut", "nombre", "apellido_paterno", "apellido_materno","correo","telefono","estado","evaluaciones","nota_final","eliminar"];
  dataSource: MatTableDataSource<Alumno>;

  constructor(private matriculaService: MatriculaService, private dialog: MatDialog, public router: Router, private route: ActivatedRoute) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;

  ngOnInit() {
    this.id_curso = parseInt(this.route.snapshot.paramMap.get('id'));
    this.obtenerAlumnosMatriculados(this.id_curso);
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

  obtenerAlumnosMatriculados(id_instancia: number){
    this.matriculaService.obtenerAlumnosInstancia(id_instancia).subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  redirigirAEvaluacionesAlumno(matricula: number){
    this.router.navigate(['vista-alumno/evaluaciones/'+ this.id_curso + '/'+matricula]);
  }

  calcularNotaFinal(matricula_id: number){
    this.matriculaService.calcularNotaFinal(matricula_id, this.id_curso).subscribe({
      next: (result) => {console.log(result);},
      error: (err) => {console.log(err)}
    });
  }
}
