import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { IngresarNotaComponent } from './ingresar-nota.component';

describe('IngresarNotaComponent', () => {
  let component: IngresarNotaComponent;
  let fixture: ComponentFixture<IngresarNotaComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ IngresarNotaComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(IngresarNotaComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
