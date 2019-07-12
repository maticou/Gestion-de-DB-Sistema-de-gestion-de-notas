import { Component, OnInit, ViewChild } from '@angular/core';
import { Instancia_curso } from 'src/app/clases/instancia_curso';
import { CursoService } from 'src/app/servicios/curso.service';
import { MatDialog, MatTableDataSource, MatSort, MatPaginator } from '@angular/material';
import { AgregarInstanciaComponent } from '../agregar-instancia/agregar-instancia.component';
import { ModificarInstanciaComponent } from '../modificar-instancia/modificar-instancia.component';
import { ActivatedRoute, Router } from '@angular/router';
import { AgregarMatriculaComponent } from '../../matricula/agregar-matricula/agregar-matricula.component';

@Component({
  selector: 'app-lista-instancia',
  templateUrl: './lista-instancia.component.html',
  styleUrls: ['./lista-instancia.component.scss']
})
export class ListaInstanciaComponent implements OnInit {
  id_curso : number;
  columnas: string[] = ["id", "seccion", "anio", "semestre", "ref_profesor", "evaluaciones", "alumnos","matricula","detalles", "eliminar"];
  dataSource: MatTableDataSource<Instancia_curso>;

  constructor(private cursoService: CursoService, private dialog: MatDialog, public router: Router, private route: ActivatedRoute) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;
  
  ngOnInit() {
    this.id_curso = parseInt(this.route.snapshot.paramMap.get('id'));
    this.obtenerInstancias(this.id_curso);
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

  refrescarTabla(){
    this.obtenerInstancias(this.id_curso);
  }

  obtenerInstancias(id_curso: number){
    this.cursoService.obtenerInstanciasCurso(id_curso).subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  eliminarInstancia(id: number){
    this.cursoService.eliminarInstanciaCurso(id).subscribe({
      next: result =>{
        if(result == true){
          this.refrescarTabla();
          console.log("La seccion se elimino correctamente");
        }
      },
      error: result => {
        console.log("error");
      }
    });
  }

  agregarInstancia(){
    const dialogRef = this.dialog.open(AgregarInstanciaComponent, {
      width: '500px',
      data: this.id_curso,
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result === "Confirm"){
        this.refrescarTabla();
        console.log("El instancia se registro correctamente");
      } 
    });
  }

  modificarInstancia(id: number){
    const dialogRef = this.dialog.open(ModificarInstanciaComponent, {
      data: id,
      width: '500px',
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result == "Confirm"){
        this.refrescarTabla();
        console.log("La instancia se modifico correctamente");
      } 
    });
  }

  inscribirAlumno(id: number){
    const dialogRef = this.dialog.open(AgregarMatriculaComponent, {
      data: id,
      width: '500px',
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result == "Confirm"){
        this.refrescarTabla();
        console.log("El alumno se ha inscrito correctamente");
      } 
    });
  }

  redirigirAEvaluaciones(codigo: number){
    this.router.navigate(['admin/instancia/evaluaciones/', codigo]);
  }

  redirigirAMatriculas(codigo: number){
    this.router.navigate(['admin/instancia/alumnos/', codigo]);
  }

}
