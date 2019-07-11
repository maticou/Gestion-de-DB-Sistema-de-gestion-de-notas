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

const routes: Routes = [
  { path: 'admin/alumno', component: MostrarAlumnoComponent },
  { path: 'admin/profesor', component: ListaProfesorComponent },
  { path: 'admin/curso', component: ListaCursoComponent },
  { path: 'admin/evaluacion', component: ListaEvaluacionComponent },
  { path: 'admin/instancia/:id', component: ListaInstanciaComponent },
  { path: 'admin/matricula', component: ListaMatriculaComponent },
  { path: 'vista-alumno', component: CursosComponent },
  { path: 'vista-alumno/evaluaciones/:id', component: EvaluacionesComponent },
  { path: 'vista-alumno/historial', component: HistorialCursosComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
