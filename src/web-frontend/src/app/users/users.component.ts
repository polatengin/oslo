import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs/internal/Observable';

@Component({
  selector: 'app-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.scss']
})
export class UsersComponent implements OnInit {

  constructor(private http: HttpClient) { }

  userList: Observable<any[]>;

  ngOnInit() {
    this.userList = this.http.get<any[]>('/api/users/')
  }

}
