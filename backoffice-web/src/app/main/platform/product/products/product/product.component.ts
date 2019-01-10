import {Component, OnDestroy, OnInit, ViewEncapsulation} from '@angular/core';
import {FormBuilder, FormGroup} from '@angular/forms';
import {Location} from '@angular/common';
import {MatSnackBar} from '@angular/material';
import {Subject} from 'rxjs';
import {takeUntil} from 'rxjs/operators';

import {fuseAnimations} from '@fuse/animations';
import {FuseUtils} from '@fuse/utils';

import {ProductModel} from '@hybris/models/product/product.model';

import {ProductService} from './product.service';

@Component({
    selector: 'platform-product',
    templateUrl: './product.component.html',
    styleUrls: ['./product.component.scss'],
    encapsulation: ViewEncapsulation.None,
    animations: fuseAnimations
})
export class ProductComponent implements OnInit, OnDestroy {
    product: ProductModel;
    pageType: string;
    productForm: FormGroup;

    // Private
    private _unsubscribeAll: Subject<any>;

    /**
     * Constructor
     *
     * @param {ProductService} _productService
     * @param {FormBuilder} _formBuilder
     * @param {Location} _location
     * @param {MatSnackBar} _matSnackBar
     */
    constructor(
        private _productService: ProductService,
        private _formBuilder: FormBuilder,
        private _location: Location,
        private _matSnackBar: MatSnackBar
    ) {
        // Set the default
        this.product = new ProductModel();

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
        // Subscribe to update product on changes
        this._productService.onProductChanged
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe(product => {
                if (product) {
                    this.product = new ProductModel(product);
                    this.pageType = 'edit';
                } else {
                    this.pageType = 'new';
                    this.product = new ProductModel();
                }

                this.productForm = this.createForm();
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
     * Create form
     *
     * @returns {FormGroup}
     */
    createForm(): FormGroup {
        return this._formBuilder.group({
            id: [this.product.id],
            name: [this.product.name],
            handle: [this.product.handle],
            description: [this.product.description],
            categories: [this.product.categories],
            tags: [this.product.tags],
            images: [this.product.images],
            priceTaxExcl: [this.product.priceTaxExcl],
            priceTaxIncl: [this.product.priceTaxIncl],
            taxRate: [this.product.taxRate],
            comparedPrice: [this.product.comparedPrice],
            quantity: [this.product.quantity],
            sku: [this.product.sku],
            width: [this.product.width],
            height: [this.product.height],
            depth: [this.product.depth],
            weight: [this.product.weight],
            extraShippingFee: [this.product.extraShippingFee],
            active: [this.product.active]
        });
    }

    /**
     * Save product
     */
    saveProduct(): void {
        const data = this.productForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._productService.saveProduct(data)
            .then(() => {
                // Trigger the subscription with new data
                this._productService.onProductChanged.next(data);

                // Show the success message
                this._matSnackBar.open('Product saved', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });
            });
    }

    /**
     * Add product
     */
    addProduct(): void {
        const data = this.productForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._productService.addProduct(data)
            .then(() => {

                // Trigger the subscription with new data
                this._productService.onProductChanged.next(data);

                // Show the success message
                this._matSnackBar.open('Product added', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });

                // Change the location with new one
                this._location.go('platform/product/products/' + this.product.id + '/' + this.product.handle);
            });
    }
}
