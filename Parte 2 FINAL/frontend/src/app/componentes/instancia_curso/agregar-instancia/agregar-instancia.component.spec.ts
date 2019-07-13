import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { AgregarInstanciaComponent } from './agregar-instancia.component';

describe('AgregarInstanciaComponent', () => {
  let component: AgregarInstanciaComponent;
  let fixture: ComponentFixture<AgregarInstanciaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ AgregarInstanciaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(AgregarInstanciaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
