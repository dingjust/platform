import {Component, OnDestroy, OnInit, ViewEncapsulation} from '@angular/core';
import {FormBuilder, FormGroup} from '@angular/forms';
import {Location} from '@angular/common';
import {MatSnackBar} from '@angular/material';
import {Subject} from 'rxjs';
import {takeUntil} from 'rxjs/operators';

import {fuseAnimations} from '@fuse/animations';
import {FuseUtils} from '@fuse/utils';

import {CategoryModel} from '@hybris/models/product/product.model';

import {CategoryService} from './category.service';

@Component({
    selector: 'platform-category',
    templateUrl: './category.component.html',
    styleUrls: ['./category.component.scss'],
    encapsulation: ViewEncapsulation.None,
    animations: fuseAnimations
})
export class CategoryComponent implements OnInit, OnDestroy {
    model: CategoryModel;
    pageType: string;
    modelForm: FormGroup;

    // Private
    private _unsubscribeAll: Subject<any>;

    /**
     * Constructor
     *
     * @param {CategoryService} _categoryService
     * @param {FormBuilder} _formBuilder
     * @param {Location} _location
     * @param {MatSnackBar} _matSnackBar
     */
    constructor(
        private _categoryService: CategoryService,
        private _formBuilder: FormBuilder,
        private _location: Location,
        private _matSnackBar: MatSnackBar
    ) {
        // Set the default
        this.model = new CategoryModel();

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
        // Subscribe to update model on changes
        this._categoryService.onModelChanged
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe(model => {
                if (model) {
                    this.model = new CategoryModel(model);
                    this.pageType = 'edit';
                }
                else {
                    this.pageType = 'new';
                    this.model = new CategoryModel();
                }

                this.modelForm = this.createCategoryForm();
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
     * Create model form
     *
     * @returns {FormGroup}
     */
    createCategoryForm(): FormGroup {
        return this._formBuilder.group({
            id: [this.model.id],
            code: [this.model.code],
            name: [this.model.name]
        });
    }

    /**
     * Save model
     */
    updateCategory(): void {
        const data = this.modelForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._categoryService.updateCategory(data)
            .then(() => {

                // Trigger the subscription with new data
                this._categoryService.onModelChanged.next(data);

                // Show the success message
                this._matSnackBar.open('Category saved', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });
            });
    }

    /**
     * Add model
     */
    addCategory(): void {
        const data = this.modelForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._categoryService.addCategory(data)
            .then(() => {

                // Trigger the subscription with new data
                this._categoryService.onModelChanged.next(data);

                // Show the success message
                this._matSnackBar.open('Category added', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });

                // Change the location with new one
                this._location.go('platform/product/categories/' + this.model.id + '/' + this.model.name);
            });
    }
}
