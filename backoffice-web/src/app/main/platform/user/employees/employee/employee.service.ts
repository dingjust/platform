import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {BehaviorSubject, Observable} from 'rxjs';

import {EmployeeModel} from '@hybris/models/user';

@Injectable()
export class EmployeeService implements Resolve<any> {
    routeParams: any;
    model: EmployeeModel;
    onModelChanged: BehaviorSubject<any>;

    /**
     * Constructor
     *
     * @param {HttpClient} _httpClient
     */
    constructor(
        private _httpClient: HttpClient
    ) {
        // Set the defaults
        this.onModelChanged = new BehaviorSubject({});
    }

    /**
     * Resolver
     *
     * @param {ActivatedRouteSnapshot} route
     * @param {RouterStateSnapshot} state
     * @returns {Observable<any> | Promise<any> | any}
     */
    resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any> | Promise<any> | any {
        this.routeParams = route.params;

        return new Promise((resolve, reject) => {

            Promise.all([
                this.getEmployee()
            ]).then(
                () => {
                    resolve();
                },
                reject
            );
        });
    }

    /**
     * Get model
     *
     * @returns {Promise<EmployeeModel>}
     */
    getEmployee(): Promise<EmployeeModel | boolean> {
        return new Promise((resolve, reject) => {
            if (this.routeParams.id === 'new') {
                this.onModelChanged.next(false);
                resolve(false);
            }
            else {
                this._httpClient.get('api/platform-employees/' + this.routeParams.id)
                    .subscribe((response: EmployeeModel) => {
                        this.model = response;
                        this.onModelChanged.next(this.model);
                        resolve(response);
                    }, reject);
            }
        });
    }

    /**
     * Update model
     *
     * @param model
     * @returns {Promise<any>}
     */
    updateEmployee(model: EmployeeModel): Promise<any> {
        return new Promise((resolve, reject) => {
            this._httpClient.post('api/platform-employees/' + model.id, model)
                .subscribe((response: any) => {
                    resolve(response);
                }, reject);
        });
    }

    /**
     * Add model
     *
     * @param model
     * @returns {Promise<any>}
     */
    addEmployee(model: EmployeeModel): Promise<any> {
        return new Promise((resolve, reject) => {
            this._httpClient.post('api/platform-employees/', model)
                .subscribe((response: any) => {
                    resolve(response);
                }, reject);
        });
    }
}
