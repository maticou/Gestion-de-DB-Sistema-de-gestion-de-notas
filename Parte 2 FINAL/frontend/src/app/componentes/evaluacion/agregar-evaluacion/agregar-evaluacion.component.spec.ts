import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AgregarEvaluacionComponent } from './agregar-evaluacion.component';

describe('AgregarEvaluacionComponent', () => {
  let component: AgregarEvaluacionComponent;
  let fixture: ComponentFixture<AgregarEvaluacionComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AgregarEvaluacionComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AgregarEvaluacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
