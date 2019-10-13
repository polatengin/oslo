import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-product-detail',
  templateUrl: './product-detail.component.html',
  styleUrls: ['./product-detail.component.scss']
})
export class ProductDetailComponent implements OnInit {

  constructor(private http: HttpClient) {
  }

  product: any;

  ngOnInit() {
    this.http.get<{}>('/api/products/random/').subscribe(_ => {
      this.product = _;
    });
  }

}
