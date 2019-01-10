import {NgModule} from '@angular/core';
import {RouterModule} from '@angular/router';

import {FuseSharedModule} from '@fuse/shared.module';

const routes = [
    {
        path: 'chat',
        loadChildren: './chat/chat.module#ChatModule'
    }
];

@NgModule({
    imports: [
        RouterModule.forChild(routes),
        FuseSharedModule
    ]
})
export class AppsModule {
}
