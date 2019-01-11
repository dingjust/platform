import {Injectable} from '@angular/core';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {HttpClient} from '@angular/common/http';
import {BehaviorSubject, Observable} from 'rxjs';

import {RoleModel} from '@hybris/models/user';

@Injectable()
export class RolesService implements Resolve<any> {
    models: RoleModel[];
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
                this.getRoles()
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
     * @returns {Promise<RoleModel[]>}
     */
    getRoles(): Promise<RoleModel[]> {
        return new Promise((resolve, reject) => {
            this._httpClient.get('api/platform-roles')
                .subscribe((response: RoleModel[]) => {
                    this.models = response;
                    this.onModelsChanged.next(this.models);
                    resolve(response);
                }, reject);
        });
    }
}
