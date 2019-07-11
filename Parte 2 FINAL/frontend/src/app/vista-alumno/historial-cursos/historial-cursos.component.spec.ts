import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { HistorialCursosComponent } from './historial-cursos.component';

describe('HistorialCursosComponent', () => {
  let component: HistorialCursosComponent;
  let fixture: ComponentFixture<HistorialCursosComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ HistorialCursosComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(HistorialCursosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
