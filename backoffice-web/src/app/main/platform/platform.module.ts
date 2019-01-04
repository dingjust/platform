import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';

import {UserModule} from './user/user.module';

const routes: Routes = [
    {
        path: 'user',
        loadChildren: './user/user.module#UserModule'
    },
];

@NgModule({
    imports: [
        RouterModule.forChild(routes),

        UserModule,
    ]
})
export class PlatformModule {
}
