import {NgModule, CUSTOM_ELEMENTS_SCHEMA} from '@angular/core';
import {RouterModule} from '@angular/router';
import {TranslateModule} from '@ngx-translate/core';

import {NgZorroAntdModule} from 'ng-zorro-antd';

import {FuseSharedModule} from '@fuse/shared.module';

import {SampleComponent} from './sample.component';

const routes = [
    {
        path: 'sample',
        component: SampleComponent
    }
];

@NgModule({
    schemas: [CUSTOM_ELEMENTS_SCHEMA],
    declarations: [
        SampleComponent
    ],
    imports: [
        RouterModule.forChild(routes),

        TranslateModule,

        NgZorroAntdModule,

        FuseSharedModule
    ],
    exports: [
        SampleComponent
    ]
})

export class SampleModule {
}
