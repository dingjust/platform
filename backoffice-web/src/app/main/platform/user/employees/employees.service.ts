import {Injectable} from '@angular/core';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {HttpClient} from '@angular/common/http';
import {BehaviorSubject, Observable} from 'rxjs';

import {EmployeeModel} from '@hybris/models/user';

@Injectable()
export class EmployeesService implements Resolve<any> {
    models: EmployeeModel[];
    onModelsChanged: BehaviorSubject<any>;

    /**
     * Constructor
     *
     * @param {HttpClient} _httpClient
     */
    constructor(
        private _httpClient: HttpClient
    ) {
        // Set the defaults
        this.onModelsChanged = new BehaviorSubject({});
    }

    /**
     * Resolver
     *
     * @param {ActivatedRouteSnapshot} route
     * @param {RouterStateSnapshot} state
     * @returns {Observable<any> | Promise<any> | any}
     */
    resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any> | Promise<any> | any {
        return new Promise((resolve, reject) => {

            Promise.all([
                this.getEmployees()
            ]).then(
                () => {
                    resolve();
                },
                reject
            );
        });
    }

    /**
     * Get models
     *
     * @returns {Promise<EmployeeModel[]>}
     */
    getEmployees(): Promise<EmployeeModel[]> {
        return new Promise((resolve, reject) => {
            this._httpClient.get('api/platform-employees')
                .subscribe((response: EmployeeModel[]) => {
                    this.models = response;
                    this.onModelsChanged.next(this.models);
                    resolve(response);
                }, reject);
        });
    }
}
