import {Component, OnDestroy, OnInit, ViewEncapsulation} from '@angular/core';
import {FormBuilder, FormGroup} from '@angular/forms';
import {Location} from '@angular/common';
import {MatSnackBar} from '@angular/material';
import {Subject} from 'rxjs';
import {takeUntil} from 'rxjs/operators';

import {fuseAnimations} from '@fuse/animations';
import {FuseUtils} from '@fuse/utils';

import {EmployeeModel} from '@hybris/models/user';

import {EmployeeService} from './employee.service';

@Component({
    selector: 'platform-employee',
    templateUrl: './employee.component.html',
    styleUrls: ['./employee.component.scss'],
    encapsulation: ViewEncapsulation.None,
    animations: fuseAnimations
})
export class EmployeeComponent implements OnInit, OnDestroy {
    model: EmployeeModel;
    pageType: string;
    modelForm: FormGroup;

    // Private
    private _unsubscribeAll: Subject<any>;

    /**
     * Constructor
     *
     * @param {EmployeeService} _employeeService
     * @param {FormBuilder} _formBuilder
     * @param {Location} _location
     * @param {MatSnackBar} _matSnackBar
     */
    constructor(
        private _employeeService: EmployeeService,
        private _formBuilder: FormBuilder,
        private _location: Location,
        private _matSnackBar: MatSnackBar
    ) {
        // Set the default
        this.model = new EmployeeModel();

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
        this._employeeService.onModelChanged
            .pipe(takeUntil(this._unsubscribeAll))
            .subscribe(model => {
                if (model) {
                    this.model = new EmployeeModel(model);
                    this.pageType = 'edit';
                }
                else {
                    this.pageType = 'new';
                    this.model = new EmployeeModel();
                }

                this.modelForm = this.createEmployeeForm();
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
    createEmployeeForm(): FormGroup {
        return this._formBuilder.group({
            id: [this.model.id],
            uid: [this.model.uid],
            name: [this.model.name]
        });
    }

    /**
     * Save model
     */
    updateEmployee(): void {
        const data = this.modelForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._employeeService.updateEmployee(data)
            .then(() => {

                // Trigger the subscription with new data
                this._employeeService.onModelChanged.next(data);

                // Show the success message
                this._matSnackBar.open('Employee saved', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });
            });
    }

    /**
     * Add model
     */
    addEmployee(): void {
        const data = this.modelForm.getRawValue();
        data.handle = FuseUtils.handleize(data.name);

        this._employeeService.addEmployee(data)
            .then(() => {

                // Trigger the subscription with new data
                this._employeeService.onModelChanged.next(data);

                // Show the success message
                this._matSnackBar.open('Employee added', 'OK', {
                    verticalPosition: 'top',
                    duration: 2000
                });

                // Change the location with new one
                this._location.go('platform/user/employees/' + this.model.id + '/' + this.model.name);
            });
    }
}
