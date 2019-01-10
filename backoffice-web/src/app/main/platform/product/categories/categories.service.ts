import {Injectable} from '@angular/core';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {HttpClient} from '@angular/common/http';
import {BehaviorSubject, Observable} from 'rxjs';

import {CategoryModel} from '@hybris/models/product/product.model';

@Injectable()
export class CategoriesService implements Resolve<any> {
    models: CategoryModel[];
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
                this.getCategories()
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
     * @returns {Promise<CategoryModel[]>}
     */
    getCategories(): Promise<CategoryModel[]> {
        return new Promise((resolve, reject) => {
            this._httpClient.get('api/platform-categories')
                .subscribe((response: CategoryModel[]) => {
                    this.models = response;
                    this.onModelsChanged.next(this.models);
                    resolve(response);
                }, reject);
        });
    }
}
