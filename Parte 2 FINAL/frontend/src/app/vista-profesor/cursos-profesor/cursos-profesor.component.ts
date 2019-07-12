import { Component, OnInit, ViewChild } from '@angular/core';
import { MatTableDataSource, MatSort, MatPaginator, MatDialog } from '@angular/material';
import { CursoAlumno } from 'src/app/clases/curso';
import { CursoService } from 'src/app/servicios/curso.service';
import { Router, ActivatedRoute } from '@angular/router';
import { AgregarMatriculaComponent } from 'src/app/componentes/matricula/agregar-matricula/agregar-matricula.component';

@Component({
  selector: 'app-cursos-profesor',
  templateUrl: './cursos-profesor.component.html',
  styleUrls: ['./cursos-profesor.component.scss']
})
export class CursosProfesorComponent implements OnInit {

  rut: string;
  columnas: string[] = ["nombre", "seccion", "anio", "semestre", "alumnos", "inscribir", "evaluaciones"];
  dataSource: MatTableDataSource<CursoAlumno>;

  constructor(private cursoService: CursoService, private dialog: MatDialog, public router: Router, private route: ActivatedRoute) { }

  @ViewChild(MatSort, { read: true, static: false }) sort: MatSort;
  @ViewChild(MatPaginator, { read: true, static: false }) paginator: MatPaginator;
  
  ngOnInit() {
    this.rut = this.route.snapshot.paramMap.get('rut');
    this.obtenerCursos(this.rut);
    this.dataSource = new MatTableDataSource();
    this.dataSource.sort = this.sort;
  }

  refrescarTabla(){
    this.obtenerCursos(this.rut);
  }

  obtenerCursos(rut: string){
    this.cursoService.obtenerVistaCursosProfesor(rut).subscribe({
      next: (result) => {this.dataSource.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  redirigirAEvaluaciones(id_instancia: number){
    this.router.navigate(['vista-profesor/cursos/evaluaciones/'+ id_instancia]);
  }

  verAlumnosInscritos(id_instancia: number){
    this.router.navigate(['vista-profesor/seccion/alumnos/', id_instancia]);
  }

  inscribirAlumno(id_instancia: number){
    const dialogRef = this.dialog.open(AgregarMatriculaComponent, {
      data: id_instancia,
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

}
