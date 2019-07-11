import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ListaEvaluacionComponent } from './lista-evaluacion.component';

describe('ListaEvaluacionComponent', () => {
  let component: ListaEvaluacionComponent;
  let fixture: ComponentFixture<ListaEvaluacionComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ListaEvaluacionComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ListaEvaluacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
