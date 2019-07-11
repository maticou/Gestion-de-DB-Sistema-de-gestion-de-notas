import { Component, OnInit, ViewChild } from '@angular/core';
import { Curso } from 'src/app/clases/curso';
import { MatTableDataSource, MatDialog, MatSort, MatPaginator } from '@angular/material';
import { CursoService } from 'src/app/servicios/curso.service';
import { AgregarCursoComponent } from '../agregar-curso/agregar-curso.component';
import { ModificarCursoComponent } from '../modificar-curso/modificar-curso.component';
import { Router } from '@angular/router';

@Component({
  selector: 'app-lista-curso',
  templateUrl: './lista-curso.component.html',
  styleUrls: ['./lista-curso.component.scss']
})
export class ListaCursoComponent implements OnInit {

  columnas: string[] = ["codigo", "nombre", "carrera", "ref_profesor_encargado", "secciones","detalles"];
  dataSource: MatTableDataSource<Curso>;

  constructor(private cursoService: CursoService, private dialog: MatDialog, public router: Router) { }

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
    this.cursoService.obtenerCursos().subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  redirigirASecciones(codigo: number){
    this.router.navigate(['admin/curso/secciones/', codigo]);
  }

  agregarCurso(){
    const dialogRef = this.dialog.open(AgregarCursoComponent, {
      width: '500px',
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result === "Confirm"){
        this.refrescarTabla();
        console.log("El curso se registro correctamente");
      } 
    });
  }

  modificarCurso(codigo: number){
    const dialogRef = this.dialog.open(ModificarCursoComponent, {
      data: codigo,
      width: '500px',
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result == "Confirm"){
        this.refrescarTabla();
        console.log("El curso se modifico correctamente");
      } 
    });
  }

}
