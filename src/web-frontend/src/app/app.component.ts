import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  template: `
  <span id="version">version: {{ version }}</span>
  <header class="navbar">
      <div class="navbar-primary">
        <a routerLink="/" class="btn btn-link selected">Oslo Project Home</a>
        <a routerLink="/" class="btn btn-link">About</a>
        <a routerLink="/products" class="btn btn-link">Products</a>
        <a routerLink="/users" class="btn btn-link">Users</a>
    </div>
    </header>
    <router-outlet></router-outlet>
  `,
  styles: []
})
export class AppComponent {
  title = 'web-frontend';
}
