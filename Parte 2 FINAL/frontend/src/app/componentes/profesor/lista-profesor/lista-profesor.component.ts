import { Component, OnInit, ViewChild } from '@angular/core';
import { Profesor } from 'src/app/clases/profesor';
import { MatTableDataSource, MatDialog, MatSort, MatPaginator } from '@angular/material';
import { ProfesorService } from 'src/app/servicios/profesor.service';
import { AgregarProfesorComponent } from '../agregar-profesor/agregar-profesor.component';
import { ModificarProfesorComponent } from '../modificar-profesor/modificar-profesor.component';

@Component({
  selector: 'app-lista-profesor',
  templateUrl: './lista-profesor.component.html',
  styleUrls: ['./lista-profesor.component.scss']
})
export class ListaProfesorComponent implements OnInit {

  columnas: string[] = ["rut", "nombre", "apellido","correo", "telefono", "detalles","eliminar"];
  dataSource: MatTableDataSource<Profesor>;

  constructor(private profesorService: ProfesorService, private dialog: MatDialog) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;
  
  ngOnInit() {
    this.obtenerProfesores();
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

  obtenerProfesores(){
    this.profesorService.obtenerProfesores().subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  refrescarTabla(){
    this.obtenerProfesores();
  }

  agregarProfesor(){
    const dialogRef = this.dialog.open(AgregarProfesorComponent, {
      width: '500px',
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result === "Confirm"){
        this.refrescarTabla();
        console.log("El profesor se registro correctamente");
      } 
    });
  }

  modificarProfesor(rut : string){
    const dialogRef = this.dialog.open(ModificarProfesorComponent, {
      data: rut,
      width: '500px',
      disableClose: true,
      autoFocus: true
    });
  
    dialogRef.afterClosed().subscribe(result => {
      console.log(result);
      if(result == "Confirm"){
        this.refrescarTabla();
        console.log("El profesor se modifico correctamente");
      } 
    });
  }

  eliminarProfesor(rut: string){
    this.profesorService.eliminarProfesor(rut).subscribe({
      next: result =>{
        if(result == true){
          this.refrescarTabla();
          console.log("El profesor se elimino correctamente");
        }
      },
      error: result => {
        console.log("error");
      }
    });
  }

}
