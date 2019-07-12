import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { CursosProfesorComponent } from './cursos-profesor.component';

describe('CursosProfesorComponent', () => {
  let component: CursosProfesorComponent;
  let fixture: ComponentFixture<CursosProfesorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ CursosProfesorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(CursosProfesorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
