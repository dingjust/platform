import {Component, OnDestroy, OnInit, ViewEncapsulation} from '@angular/core';
import {FormBuilder, FormGroup} from '@angular/forms';
import {Location} from '@angular/common';
import {MatSnackBar} from '@angular/material';
import {Subject} from 'rxjs';
import {takeUntil} from 'rxjs/operators';

import {fuseAnimations} from '@fuse/animations';
import {FuseUtils} from '@fuse/utils';

import {RoleModel} from '@hybris/models/user';

import {RoleService} from './role.service';

@Component({
    selector: 'platform-role',
    templateUrl: './role.component.html',
    styleUrls: ['./role.component.scss'],
    encapsulation: ViewEncapsulation.None,
    animations: fuseAnimations
})
export class RoleComponent implements OnInit, OnDestroy {
    model: RoleModel;
    pageType: string;
    modelForm: FormGroup;

    // Private
    private _unsubscribeAll: Subject<any>;

    /**
     * Constructor
     *
     * @param {RoleService} _roleService
     * @param {FormBuilder} _formBuilder
     * @param {Location} _location
     * @param {MatSnackBar} _matSnackBar
     */
    constructor(
        private _roleService: RoleService,
        private _formBuilder: FormBuilder,
        private _location: Location,
        private _matSnackBar: MatSnackBar
    ) {
        // Set the default
        this.model = new RoleModel();

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
        this._roleService.onModelChanged
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe(model => {
                if (model) {
                    this.model = new RoleModel(model);
                    this.pageType = 'edit';
                }
                else {
                    this.pageType = 'new';
                    this.model = new RoleModel();
                }

                this.modelForm = this.createRoleForm();
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
    createRoleForm(): FormGroup {
        return this._formBuilder.group({
            id: [this.model.id],
            uid: [this.model.uid],
            name: [this.model.name]
        });
    }

    /**
     * Save model
     */
    updateRole(): void {
        const data = this.modelForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._roleService.updateRole(data)
            .then(() => {

                // Trigger the subscription with new data
                this._roleService.onModelChanged.next(data);

                // Show the success message
                this._matSnackBar.open('Role saved', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });
            });
    }

    /**
     * Add model
     */
    addRole(): void {
        const data = this.modelForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._roleService.addRole(data)
            .then(() => {

                // Trigger the subscription with new data
                this._roleService.onModelChanged.next(data);

                // Show the success message
                this._matSnackBar.open('Role added', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });

                // Change the location with new one
                this._location.go('platform/user/roles/' + this.model.id + '/' + this.model.name);
            });
    }
}
