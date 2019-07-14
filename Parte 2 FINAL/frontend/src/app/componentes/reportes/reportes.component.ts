import { Component, OnInit } from '@angular/core';
import { ReportesService } from 'src/app/servicios/reportes.service';
import { MatTableDataSource } from '@angular/material';
import { Alumno, Profesor, Curso } from 'src/app/clases/clases-reportes';
import { FormGroup, FormControl } from '@angular/forms';

@Component({
  selector: 'app-reportes',
  templateUrl: './reportes.component.html',
  styleUrls: ['./reportes.component.scss']
})
export class ReportesComponent implements OnInit {
  form1: FormGroup;
  form2: FormGroup;
  
  reporte1: string;
  col_reporte2: string[] = ["matricula", "nombre", "apellido", "promedio"];
  col_reporte4: string[] = ["matricula", "nombre", "apellido", "num_cursos"];
  col_reporte6: string[] = ["rut", "nombre", "apellido", "num_cursos"];
  col_reporte7: string[] = ["rut", "nombre", "apellido", "num_alumnos"];
  col_reporte9: string[] = ["codigo", "nombre", "porcentaje_alumnos"];
  datos_reporte2: MatTableDataSource<Alumno>;
  datos_reporte3: MatTableDataSource<Alumno>;
  datos_reporte4: MatTableDataSource<Alumno>;
  datos_reporte5: MatTableDataSource<Alumno>;
  datos_reporte6: MatTableDataSource<Profesor>;
  datos_reporte7: MatTableDataSource<Profesor>;
  datos_reporte8: MatTableDataSource<Profesor>;
  datos_reporte9: MatTableDataSource<Curso>;
  reporte10: string;
  reporte11: string;

  constructor(private reportesService: ReportesService) { 
    this.form1 = new FormGroup({
      id_instancia: new FormControl("")
    });

    this.form2 = new FormGroup({
      id_instancia: new FormControl("")
    });
  }

  ngOnInit() {
    this.datos_reporte2 = new MatTableDataSource();
    this.datos_reporte3 = new MatTableDataSource();
    this.datos_reporte4 = new MatTableDataSource();
    this.datos_reporte5 = new MatTableDataSource();
    this.datos_reporte6 = new MatTableDataSource();
    this.datos_reporte7 = new MatTableDataSource();
    this.datos_reporte8 = new MatTableDataSource();
    this.datos_reporte9 = new MatTableDataSource();
    this.porcentaje_alumnos_que_toman_cursos();
  }

  calcularReporte10(){
    let datos = this.form1.value;
    this.porcentaje_aprobado_y_reprobado_de_una_seccion(datos.id_instancia);
  }

  calcularReporte11(){
    let datos = this.form2.value;
    this.promedio_de_una_seccion(datos.id_instancia);
  }

  porcentaje_alumnos_que_toman_cursos(){
    this.reportesService.porcentaje_alumnos_que_toman_cursos().subscribe({
      next: (result) => {this.reporte1 = result[0].reporte_porcentaje_alumnos_que_toman_cursos},
      error: (err) => {console.log(err)}
    });
  }

  alumnos_con_mejor_promedio(){
    this.reportesService.alumnos_con_mejor_promedio().subscribe({
      next: (result) => {this.datos_reporte2.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  alumnos_con_peor_promedio(){
    this.reportesService.alumnos_con_peor_promedio().subscribe({
      next: (result) => {this.datos_reporte3.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  alumnos_con_mas_cursos_aprobados(){
    this.reportesService.alumnos_con_mas_cursos_aprobados().subscribe({
      next: (result) => {this.datos_reporte4.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  alumnos_con_mas_cursos_reprobados(){
    this.reportesService.alumnos_con_mas_cursos_reprobados().subscribe({
      next: (result) => {this.datos_reporte5.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  numero_cursos_dictados_por_profesor(){
    this.reportesService.numero_cursos_dictados_por_profesor().subscribe({
      next: (result) => {this.datos_reporte6.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  profesores_con_numero_de_aprobados(){
    this.reportesService.profesores_con_numero_de_aprobados().subscribe({
      next: (result) => {this.datos_reporte7.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  profesores_con_numero_de_reprobados(){
    this.reportesService.profesores_con_numero_de_reprobados().subscribe({
      next: (result) => {this.datos_reporte8.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  cursos_con_porcentaje_de_reprobados(){
    this.reportesService.cursos_con_porcentaje_de_reprobados().subscribe({
      next: (result) => {this.datos_reporte9.data = result;},
      error: (err) => {console.log(err)}
    });
  }

  porcentaje_aprobado_y_reprobado_de_una_seccion(id_instancia: number){
    this.reportesService.porcentaje_aprobado_y_reprobado_de_una_seccion(id_instancia).subscribe({
      next: (result) => {console.log(result);this.reporte10 = result[0];},
      error: (err) => {console.log(err)}
    });
  }

  promedio_de_una_seccion(id_instancia: number){
    this.reportesService.promedio_de_una_seccion(id_instancia).subscribe({
      next: (result) => {console.log(result);this.reporte11 = result[0].reporte_promedio_de_una_seccion;},
      error: (err) => {console.log(err)}
    });
  }
}
