import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {BehaviorSubject, Observable} from 'rxjs';

import {RoleModel} from '@hybris/models/user';

@Injectable()
export class RoleService implements Resolve<any> {
    routeParams: any;
    model: RoleModel;
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
                this.getRole()
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
     * @returns {Promise<RoleModel>}
     */
    getRole(): Promise<RoleModel | boolean> {
        return new Promise((resolve, reject) => {
            if (this.routeParams.id === 'new') {
                this.onModelChanged.next(false);
                resolve(false);
            }
            else {
                this._httpClient.get('api/platform-roles/' + this.routeParams.id)
                    .subscribe((response: RoleModel) => {
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
    updateRole(model: RoleModel): Promise<any> {
        return new Promise((resolve, reject) => {
            this._httpClient.post('api/platform-roles/' + model.id, model)
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
    addRole(model: RoleModel): Promise<any> {
        return new Promise((resolve, reject) => {
            this._httpClient.post('api/platform-roles/', model)
                .subscribe((response: any) => {
                    resolve(response);
                }, reject);
        });
    }
}
