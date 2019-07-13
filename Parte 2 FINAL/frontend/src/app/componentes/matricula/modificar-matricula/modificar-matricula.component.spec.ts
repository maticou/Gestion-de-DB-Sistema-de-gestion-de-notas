import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ModificarMatriculaComponent } from './modificar-matricula.component';

describe('ModificarMatriculaComponent', () => {
  let component: ModificarMatriculaComponent;
  let fixture: ComponentFixture<ModificarMatriculaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ModificarMatriculaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ModificarMatriculaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
