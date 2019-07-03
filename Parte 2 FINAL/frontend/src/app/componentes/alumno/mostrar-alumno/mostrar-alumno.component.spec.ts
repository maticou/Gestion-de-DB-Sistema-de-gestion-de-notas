import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { MostrarAlumnoComponent } from './mostrar-alumno.component';

describe('MostrarAlumnoComponent', () => {
  let component: MostrarAlumnoComponent;
  let fixture: ComponentFixture<MostrarAlumnoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ MostrarAlumnoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(MostrarAlumnoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
