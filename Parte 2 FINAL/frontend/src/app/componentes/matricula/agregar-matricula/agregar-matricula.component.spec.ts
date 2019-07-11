import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AgregarMatriculaComponent } from './agregar-matricula.component';

describe('AgregarMatriculaComponent', () => {
  let component: AgregarMatriculaComponent;
  let fixture: ComponentFixture<AgregarMatriculaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AgregarMatriculaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AgregarMatriculaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
