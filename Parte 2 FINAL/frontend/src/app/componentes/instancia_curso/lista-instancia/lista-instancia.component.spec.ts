import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ListaInstanciaComponent } from './lista-instancia.component';

describe('ListaInstanciaComponent', () => {
  let component: ListaInstanciaComponent;
  let fixture: ComponentFixture<ListaInstanciaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ListaInstanciaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ListaInstanciaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
