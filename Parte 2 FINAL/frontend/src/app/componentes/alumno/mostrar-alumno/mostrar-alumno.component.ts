import { Component, OnInit, ViewChild } from '@angular/core';
import { Alumno } from 'src/app/clases/alumno';
import { MatTableDataSource, MatDialog, MatPaginator, MatSort } from '@angular/material';
import { AlumnoService } from '../../../servicios/alumno.service';
import { AgregarAlumnoComponent } from '../agregar-alumno/agregar-alumno.component';
import { ModificarAlumnoComponent } from '../modificar-alumno/modificar-alumno.component';

@Component({
  selector: 'app-mostrar-alumno',
  templateUrl: './mostrar-alumno.component.html',
  styleUrls: ['./mostrar-alumno.component.scss']
})
export class MostrarAlumnoComponent implements OnInit {

  columnas: string[] = ["matricula", "rut", "nombre", "apellido_pat", "apellido_mat","correo", "telefono", "detalles","eliminar"];
  dataSource: MatTableDataSource<Alumno>;

  constructor(private alumnoService: AlumnoService, private dialog: MatDialog) { 

  }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;

  ngOnInit() {
    this.obtenerAlumnos();
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

  refrescarTabla(){
    this.obtenerAlumnos();
  }

  obtenerAlumnos(){
    this.alumnoService.obtenerAlumnos().subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  agregarAlumno(){
    const dialogRef = this.dialog.open(AgregarAlumnoComponent, {
      width: '500px',
      height: '95%',
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result === "Confirm"){
        this.refrescarTabla();
        console.log("El alumno se registro correctamente");
      } 
    });
  }

  modificarAlumno(matricula : string){
    const dialogRef = this.dialog.open(ModificarAlumnoComponent, {
      data: matricula,
      width: '500px',
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result == "Confirm"){
        this.refrescarTabla();
        console.log("El alumno se modifico correctamente");
      } 
    });
  }

  eliminarAlumno(matricula: number){
    this.alumnoService.eliminarAlumno(matricula).subscribe({
      next: result =>{
        if(result == true){
          this.refrescarTabla();
          console.log("El alumno se elimino correctamente");
        }
      },
      error: result => {
        console.log("error");
      }
    });
  }

}
