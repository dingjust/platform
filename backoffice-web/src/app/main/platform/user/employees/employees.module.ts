import {NgModule} from '@angular/core';
import {RouterModule} from '@angular/router';
import {TranslateModule} from '@ngx-translate/core';

import {FuseSharedModule} from '@fuse/shared.module';

import {EmployeesComponent} from './employees.component';

const routes = [
    {
        path: 'employees',
        component: EmployeesComponent
    }
];

@NgModule({
    declarations: [
        EmployeesComponent
    ],
    imports: [
        RouterModule.forChild(routes),

        TranslateModule,

        FuseSharedModule
    ],
    exports: [
        EmployeesComponent
    ]
})

export class EmployeesModule {
}
