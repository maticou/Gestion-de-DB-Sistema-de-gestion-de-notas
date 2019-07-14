import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { MostrarAlumnoComponent } from './componentes/alumno/mostrar-alumno/mostrar-alumno.component';
import { ListaProfesorComponent } from './componentes/profesor/lista-profesor/lista-profesor.component';
import { ListaCursoComponent } from './componentes/curso/lista-curso/lista-curso.component';
import { ListaEvaluacionComponent } from './componentes/evaluacion/lista-evaluacion/lista-evaluacion.component';
import { ListaInstanciaComponent } from './componentes/instancia_curso/lista-instancia/lista-instancia.component';
import { ListaMatriculaComponent } from './componentes/matricula/lista-matricula/lista-matricula.component';
import { CursosComponent } from './vista-alumno/cursos/cursos.component';
import { EvaluacionesComponent } from './vista-alumno/evaluaciones/evaluaciones.component';
import { HistorialCursosComponent } from './vista-alumno/historial-cursos/historial-cursos.component';
import { CursosProfesorComponent } from './vista-profesor/cursos-profesor/cursos-profesor.component';
import { ReportesComponent } from './componentes/reportes/reportes.component';
import { LoginComponent } from './login/login/login.component';

const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { path: 'admin/alumno', component: MostrarAlumnoComponent },
  { path: 'admin/profesor', component: ListaProfesorComponent },
  { path: 'admin/curso', component: ListaCursoComponent },
  { path: 'admin/instancia/evaluaciones/:id', component: ListaEvaluacionComponent },
  { path: 'admin/curso/secciones/:id', component: ListaInstanciaComponent },
  { path: 'admin/instancia/alumnos/:id', component: ListaMatriculaComponent },
  { path: 'admin/reportes', component: ReportesComponent },
  { path: 'vista-alumno/:matricula', component: CursosComponent },
  { path: 'vista-alumno/evaluaciones/:id/:matricula', component: EvaluacionesComponent },
  { path: 'vista-alumno/historial', component: HistorialCursosComponent },
  { path: 'vista-profesor/:rut', component: CursosProfesorComponent },
  { path: 'vista-profesor/cursos/evaluaciones/:id', component: ListaEvaluacionComponent },
  { path: 'vista-profesor/seccion/alumnos/:id', component: ListaMatriculaComponent },
  { path: 'vista-profesor/seccion/alumnos/evaluaciones/:id/:matricula', component: EvaluacionesComponent },

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
