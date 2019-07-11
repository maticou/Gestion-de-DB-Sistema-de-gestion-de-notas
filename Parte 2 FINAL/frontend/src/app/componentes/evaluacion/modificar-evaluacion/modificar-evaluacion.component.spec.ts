import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ModificarEvaluacionComponent } from './modificar-evaluacion.component';

describe('ModificarEvaluacionComponent', () => {
  let component: ModificarEvaluacionComponent;
  let fixture: ComponentFixture<ModificarEvaluacionComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ModificarEvaluacionComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ModificarEvaluacionComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
