import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ModificarCursoComponent } from './modificar-curso.component';

describe('ModificarCursoComponent', () => {
  let component: ModificarCursoComponent;
  let fixture: ComponentFixture<ModificarCursoComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ModificarCursoComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ModificarCursoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
