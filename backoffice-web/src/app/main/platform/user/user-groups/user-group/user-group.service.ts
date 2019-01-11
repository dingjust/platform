import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {BehaviorSubject, Observable} from 'rxjs';

import {UserGroupModel} from '@hybris/models/user';

@Injectable()
export class UserGroupService implements Resolve<any> {
    routeParams: any;
    model: UserGroupModel;
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
                this.getUserGroup()
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
     * @returns {Promise<UserGroupModel>}
     */
    getUserGroup(): Promise<UserGroupModel | boolean> {
        return new Promise((resolve, reject) => {
            if (this.routeParams.id === 'new') {
                this.onModelChanged.next(false);
                resolve(false);
            }
            else {
                this._httpClient.get('api/platform-user-groups/' + this.routeParams.id)
                    .subscribe((response: UserGroupModel) => {
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
    updateUserGroup(model: UserGroupModel): Promise<any> {
        return new Promise((resolve, reject) => {
            this._httpClient.post('api/platform-user-groups/' + model.id, model)
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
    addUserGroup(model: UserGroupModel): Promise<any> {
        return new Promise((resolve, reject) => {
            this._httpClient.post('api/platform-user-groups/', model)
                .subscribe((response: any) => {
                    resolve(response);
                }, reject);
        });
    }
}
