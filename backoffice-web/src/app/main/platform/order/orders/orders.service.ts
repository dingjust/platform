import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {BehaviorSubject, Observable} from 'rxjs';

import {OrderModel} from '@hybris/models/order/order.model';

@Injectable()
export class OrdersService implements Resolve<any> {
    orders: OrderModel[];
    onOrdersChanged: BehaviorSubject<any>;

    /**
     * Constructor
     *
     * @param {HttpClient} _httpClient
     */
    constructor(
        private _httpClient: HttpClient
    ) {
        // Set the defaults
        this.onOrdersChanged = new BehaviorSubject({});
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
                this.getOrders()
            ]).then(
                () => {
                    resolve();
                },
                reject
            );
        });
    }

    /**
     * Get orders
     *
     * @returns {Promise<OrderModel[]>}
     */
    getOrders(): Promise<OrderModel[]> {
        return new Promise((resolve, reject) => {
            this._httpClient.get('api/platform-orders')
                .subscribe((response: OrderModel[]) => {
                    this.orders = response;
                    this.onOrdersChanged.next(this.orders);
                    resolve(response);
                }, reject);
        });
    }
}
