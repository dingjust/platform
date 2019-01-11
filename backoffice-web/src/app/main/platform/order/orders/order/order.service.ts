import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {ActivatedRouteSnapshot, Resolve, RouterStateSnapshot} from '@angular/router';
import {BehaviorSubject, Observable} from 'rxjs';

import {OrderModel} from '@hybris/models/order/order.model';

@Injectable()
export class OrderService implements Resolve<any> {
    routeParams: any;
    order: OrderModel;
    onOrderChanged: BehaviorSubject<any>;

    /**
     * Constructor
     *
     * @param {HttpClient} _httpClient
     */
    constructor(
        private _httpClient: HttpClient
    ) {
        // Set the defaults
        this.onOrderChanged = new BehaviorSubject({});
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
                this.getOrder()
            ]).then(
                () => {
                    resolve();
                },
                reject
            );
        });
    }

    /**
     * Get order
     *
     * @returns {Promise<OrderModel>}
     */
    getOrder(): Promise<OrderModel> {
        return new Promise((resolve, reject) => {
            this._httpClient.get('api/platform-orders/' + this.routeParams.id)
                .subscribe((response: OrderModel) => {
                    this.order = response;
                    this.onOrderChanged.next(this.order);
                    resolve(response);
                }, reject);
        });
    }

    /**
     * Save order
     *
     * @param order
     * @returns {Promise<any>}
     */
    saveOrder(order: OrderModel): Promise<any> {
        return new Promise((resolve, reject) => {
            this._httpClient.post('api/platform-orders/' + order.id, order)
                .subscribe((response: any) => {
                    resolve(response);
                }, reject);
        });
    }

    /**
     * Add order
     *
     * @param order
     * @returns {Promise<any>}
     */
    addOrder(order: OrderModel): Promise<any> {
        return new Promise((resolve, reject) => {
            this._httpClient.post('api/platform-orders/', order)
                .subscribe((response: any) => {
                    resolve(response);
                }, reject);
        });
    }
}
