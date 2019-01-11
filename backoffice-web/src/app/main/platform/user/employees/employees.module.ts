import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {
    MatButtonModule,
    MatChipsModule,
    MatExpansionModule,
    MatFormFieldModule,
    MatIconModule,
    MatInputModule,
    MatPaginatorModule,
    MatRippleModule,
    MatSelectModule,
    MatSnackBarModule,
    MatSortModule,
    MatTableModule,
    MatTabsModule
} from '@angular/material';

import {FuseSharedModule} from '@fuse/shared.module';
import {FuseWidgetModule} from '@fuse/components';

import {EmployeesComponent} from './employees.component';
import {EmployeesService} from './employees.service';
import {EmployeeComponent} from './employee/employee.component';
import {EmployeeService} from './employee/employee.service';

const routes: Routes = [
    {
        path: 'employees',
        component: EmployeesComponent,
        resolve: {
            data: EmployeesService
        }
    },
    {
        path: 'employees/:id',
        component: EmployeeComponent,
        resolve: {
            data: EmployeeService
        }
    },
    {
        path: 'employees/:id/:name',
        component: EmployeeComponent,
        resolve: {
            data: EmployeeService
        }
    }
];

@NgModule({
    declarations: [
        EmployeesComponent,
        EmployeeComponent
    ],
    imports: [
        RouterModule.forChild(routes),

        MatButtonModule,
        MatChipsModule,
        MatExpansionModule,
        MatFormFieldModule,
        MatIconModule,
        MatInputModule,
        MatPaginatorModule,
        MatRippleModule,
        MatSelectModule,
        MatSortModule,
        MatSnackBarModule,
        MatTableModule,
        MatTabsModule,

        FuseSharedModule,
        FuseWidgetModule
    ],
    providers: [
        EmployeesService,
        EmployeeService
    ]
})
export class EmployeesModule {
}
