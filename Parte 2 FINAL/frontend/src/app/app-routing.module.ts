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

const routes: Routes = [
  { path: 'alumno', component: MostrarAlumnoComponent },
  { path: 'profesor', component: ListaProfesorComponent },
  { path: 'curso', component: ListaCursoComponent },
  { path: 'evaluacion', component: ListaEvaluacionComponent },
  { path: 'instancia', component: ListaInstanciaComponent },
  { path: 'matricula', component: ListaMatriculaComponent },
  { path: 'vista-alumno', component: CursosComponent },
  { path: 'vista-alumno/evaluaciones', component: EvaluacionesComponent },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
