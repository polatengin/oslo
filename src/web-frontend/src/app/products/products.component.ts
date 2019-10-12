import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/internal/Observable';

@Component({
  selector: 'app-products',
  templateUrl: './products.component.html',
  styleUrls: ['./products.component.scss']
})
export class ProductsComponent implements OnInit {

  constructor(private http: HttpClient) { }

  productList: Observable<any[]>;

  ngOnInit() {
    this.productList = this.http.get<any[]>('/api/products/')
  }

}
