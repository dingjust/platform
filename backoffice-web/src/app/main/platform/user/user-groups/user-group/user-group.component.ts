import {Component, OnDestroy, OnInit, ViewEncapsulation} from '@angular/core';
import {FormBuilder, FormGroup} from '@angular/forms';
import {Location} from '@angular/common';
import {MatSnackBar} from '@angular/material';
import {Subject} from 'rxjs';
import {takeUntil} from 'rxjs/operators';

import {fuseAnimations} from '@fuse/animations';
import {FuseUtils} from '@fuse/utils';

import {UserGroupModel} from '@hybris/models/user';

import {UserGroupService} from './user-group.service';

@Component({
    selector: 'platform-user-group',
    templateUrl: './user-group.component.html',
    styleUrls: ['./user-group.component.scss'],
    encapsulation: ViewEncapsulation.None,
    animations: fuseAnimations
})
export class UserGroupComponent implements OnInit, OnDestroy {
    model: UserGroupModel;
    pageType: string;
    modelForm: FormGroup;

    // Private
    private _unsubscribeAll: Subject<any>;

    /**
     * Constructor
     *
     * @param {UserGroupService} _userGroupService
     * @param {FormBuilder} _formBuilder
     * @param {Location} _location
     * @param {MatSnackBar} _matSnackBar
     */
    constructor(
        private _userGroupService: UserGroupService,
        private _formBuilder: FormBuilder,
        private _location: Location,
        private _matSnackBar: MatSnackBar
    ) {
        // Set the default
        this.model = new UserGroupModel();

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
        this._userGroupService.onModelChanged
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe(model => {
                if (model) {
                    this.model = new UserGroupModel(model);
                    this.pageType = 'edit';
                }
                else {
                    this.pageType = 'new';
                    this.model = new UserGroupModel();
                }

                this.modelForm = this.createUserGroupForm();
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
    createUserGroupForm(): FormGroup {
        return this._formBuilder.group({
            id: [this.model.id],
            uid: [this.model.uid],
            name: [this.model.name]
        });
    }

    /**
     * Save model
     */
    updateUserGroup(): void {
        const data = this.modelForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._userGroupService.updateUserGroup(data)
            .then(() => {

                // Trigger the subscription with new data
                this._userGroupService.onModelChanged.next(data);

                // Show the success message
                this._matSnackBar.open('User Group saved', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });
            });
    }

    /**
     * Add model
     */
    addUserGroup(): void {
        const data = this.modelForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._userGroupService.addUserGroup(data)
            .then(() => {

                // Trigger the subscription with new data
                this._userGroupService.onModelChanged.next(data);

                // Show the success message
                this._matSnackBar.open('User Group added', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });

                // Change the location with new one
                this._location.go('platform/user/user-groups/' + this.model.id + '/' + this.model.name);
            });
    }
}
