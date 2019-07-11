import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ModificarProfesorComponent } from './modificar-profesor.component';

describe('ModificarProfesorComponent', () => {
  let component: ModificarProfesorComponent;
  let fixture: ComponentFixture<ModificarProfesorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ModificarProfesorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ModificarProfesorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
