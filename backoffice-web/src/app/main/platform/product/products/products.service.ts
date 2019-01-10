import {Injectable} from '@angular/core';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {HttpClient} from '@angular/common/http';
import {BehaviorSubject, Observable} from 'rxjs';

import {ProductModel} from '@hybris/models/product/product.model';

@Injectable()
export class ProductsService implements Resolve<any> {
    products: ProductModel[];
    onProductsChanged: BehaviorSubject<any>;

    /**
     * Constructor
     *
     * @param {HttpClient} _httpClient
     */
    constructor(
        private _httpClient: HttpClient
    ) {
        // Set the defaults
        this.onProductsChanged = new BehaviorSubject({});
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
                this.getProducts()
            ]).then(
                () => {
                    resolve();
                },
                reject
            );
        });
    }

    /**
     * Get products
     *
     * @returns {Promise<ProductModel[]>}
     */
    getProducts(): Promise<ProductModel[]> {
        return new Promise((resolve, reject) => {
            this._httpClient.get('api/platform-products')
                .subscribe((response: ProductModel[]) => {
                    this.products = response;
                    this.onProductsChanged.next(this.products);
                    resolve(response);
                }, reject);
        });
    }
}
