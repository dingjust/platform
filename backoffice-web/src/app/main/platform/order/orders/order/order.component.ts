import {Component, OnDestroy, OnInit, ViewEncapsulation} from '@angular/core';
import {FormBuilder, FormGroup} from '@angular/forms';
import {Subject} from 'rxjs';
import {takeUntil} from 'rxjs/operators';

import {fuseAnimations} from '@fuse/animations';

import {OrderModel} from '@hybris/models/order/order.model';

import {orderStatuses} from './order-statuses';
import {OrderService} from './order.service';

@Component({
    selector: 'platform-order',
    templateUrl: './order.component.html',
    styleUrls: ['./order.component.scss'],
    encapsulation: ViewEncapsulation.None,
    animations: fuseAnimations
})
export class OrderComponent implements OnInit, OnDestroy {
    order: OrderModel;
    orderStatuses: any;
    statusForm: FormGroup;

    // Private
    private _unsubscribeAll: Subject<any>;

    /**
     * Constructor
     *
     * @param {OrderService} _ecommerceOrderService
     * @param {FormBuilder} _formBuilder
     */
    constructor(
        private _ecommerceOrderService: OrderService,
        private _formBuilder: FormBuilder
    ) {
        // Set the defaults
        this.order = new OrderModel();
        this.orderStatuses = orderStatuses;

        // Set the private defaults
        this._unsubscribeAll = new Subject();
    }

    // -----------------------------------------------------------------------------------------------------
    // @ Lifecycle hooks
    // -----------------------------------------------------------------------------------------------------

    /**
     * On init
     */
    ngOnInit(): void {
        // Subscribe to update order on changes
        this._ecommerceOrderService.onOrderChanged
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe(order => {
                this.order = new OrderModel(order);
            });

        this.statusForm = this._formBuilder.group({
            newStatus: ['']
        });
    }

    /**
     * On destroy
     */
    ngOnDestroy(): void {
        // Unsubscribe from all subscriptions
        this._unsubscribeAll.next();
        this._unsubscribeAll.complete();
    }

    // -----------------------------------------------------------------------------------------------------
    // @ Public methods
    // -----------------------------------------------------------------------------------------------------

    /**
     * Update status
     */
    updateStatus(): void {
        const newStatusId = Number.parseInt(this.statusForm.get('newStatus').value);

        if (!newStatusId) {
            return;
        }

        const newStatus = this.orderStatuses.find((status) => {
            return status.id === newStatusId;
        });

        newStatus['date'] = new Date().toString();

        this.order.status.unshift(newStatus);
    }
}
