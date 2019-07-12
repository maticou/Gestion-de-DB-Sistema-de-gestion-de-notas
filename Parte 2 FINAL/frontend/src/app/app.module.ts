import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { FlexLayoutModule } from "@angular/flex-layout";

import { MaterialModule } from './material.module';

import { AgregarAlumnoComponent } from './componentes/alumno/agregar-alumno/agregar-alumno.component';
import { ModificarAlumnoComponent } from './componentes/alumno/modificar-alumno/modificar-alumno.component';
import { EliminarAlumnoComponent } from './componentes/alumno/eliminar-alumno/eliminar-alumno.component';
import { MostrarAlumnoComponent } from './componentes/alumno/mostrar-alumno/mostrar-alumno.component';
import { ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AgregarCursoComponent } from './componentes/curso/agregar-curso/agregar-curso.component';
import { ListaCursoComponent } from './componentes/curso/lista-curso/lista-curso.component';
import { ModificarCursoComponent } from './componentes/curso/modificar-curso/modificar-curso.component';
import { AgregarEvaluacionComponent } from './componentes/evaluacion/agregar-evaluacion/agregar-evaluacion.component';
import { ListaEvaluacionComponent } from './componentes/evaluacion/lista-evaluacion/lista-evaluacion.component';
import { ModificarEvaluacionComponent } from './componentes/evaluacion/modificar-evaluacion/modificar-evaluacion.component';
import { AgregarInstanciaComponent } from './componentes/instancia_curso/agregar-instancia/agregar-instancia.component';
import { ListaInstanciaComponent } from './componentes/instancia_curso/lista-instancia/lista-instancia.component';
import { ModificarInstanciaComponent } from './componentes/instancia_curso/modificar-instancia/modificar-instancia.component';
import { AgregarMatriculaComponent } from './componentes/matricula/agregar-matricula/agregar-matricula.component';
import { ModificarMatriculaComponent } from './componentes/matricula/modificar-matricula/modificar-matricula.component';
import { ListaMatriculaComponent } from './componentes/matricula/lista-matricula/lista-matricula.component';
import { ListaProfesorComponent } from './componentes/profesor/lista-profesor/lista-profesor.component';
import { AgregarProfesorComponent } from './componentes/profesor/agregar-profesor/agregar-profesor.component';
import { ModificarProfesorComponent } from './componentes/profesor/modificar-profesor/modificar-profesor.component';
import { CursosComponent } from './vista-alumno/cursos/cursos.component';
import { HistorialCursosComponent } from './vista-alumno/historial-cursos/historial-cursos.component';
import { EvaluacionesComponent } from './vista-alumno/evaluaciones/evaluaciones.component';
import { CursosProfesorComponent } from './vista-profesor/cursos-profesor/cursos-profesor.component';
import { LoginComponent } from './login/login/login.component'; 

@NgModule({
  declarations: [
    AppComponent,
    AgregarAlumnoComponent,
    ModificarAlumnoComponent,
    EliminarAlumnoComponent,
    MostrarAlumnoComponent,
    AgregarCursoComponent,
    ListaCursoComponent,
    ModificarCursoComponent,
    AgregarEvaluacionComponent,
    ListaEvaluacionComponent,
    ModificarEvaluacionComponent,
    AgregarInstanciaComponent,
    ListaInstanciaComponent,
    ModificarInstanciaComponent,
    AgregarMatriculaComponent,
    ModificarMatriculaComponent,
    ListaMatriculaComponent,
    ListaProfesorComponent,
    AgregarProfesorComponent,
    ModificarProfesorComponent,
    CursosComponent,
    HistorialCursosComponent,
    EvaluacionesComponent,
    CursosProfesorComponent,
    LoginComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    FlexLayoutModule,
    AppRoutingModule,
    MaterialModule,
    ReactiveFormsModule,
    HttpClientModule
  ],
  providers: [],
  entryComponents: [
    AgregarAlumnoComponent,
    ModificarAlumnoComponent,
    AgregarProfesorComponent,
    ModificarProfesorComponent,
    AgregarCursoComponent,
    ModificarCursoComponent,
    AgregarEvaluacionComponent,
    ModificarEvaluacionComponent,
    AgregarInstanciaComponent,
    ModificarInstanciaComponent,
    AgregarMatriculaComponent,
    ModificarMatriculaComponent
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
