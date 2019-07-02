import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';

import { MaterialModule } from './material.module';

import { AgregarAlumnoComponent } from './componentes/alumno/agregar-alumno/agregar-alumno.component';
import { ModificarAlumnoComponent } from './componentes/alumno/modificar-alumno/modificar-alumno.component';
import { EliminarAlumnoComponent } from './componentes/alumno/eliminar-alumno/eliminar-alumno.component';
import { MostrarAlumnoComponent } from './componentes/alumno/mostrar-alumno/mostrar-alumno.component';

@NgModule({
  declarations: [
    AppComponent,
    AgregarAlumnoComponent,
    ModificarAlumnoComponent,
    EliminarAlumnoComponent,
    MostrarAlumnoComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MaterialModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
