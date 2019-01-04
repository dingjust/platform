import {Component} from '@angular/core';

import {FuseTranslationLoaderService} from '@fuse/services/translation-loader.service';

import {locale as english} from './i18n/en';
import {locale as chinese} from './i18n/zh';

@Component({
    selector: 'sample',
    templateUrl: './sample.component.html',
    styleUrls: ['./sample.component.scss']
})
export class SampleComponent {
    dataSet = [
        {
            key    : '1',
            name   : 'John Brown',
            age    : 32,
            address: 'New York No. 1 Lake Park'
        },
        {
            key    : '2',
            name   : 'Jim Green',
            age    : 42,
            address: 'London No. 1 Lake Park'
        },

        {
            key    : '3',
            name   : 'Joe Black',
            age    : 32,
            address: 'Sidney No. 1 Lake Park'
        }
    ];

    /**
     * Constructor
     *
     * @param {FuseTranslationLoaderService} _fuseTranslationLoaderService
     */
    constructor(
        private _fuseTranslationLoaderService: FuseTranslationLoaderService
    ) {
        this._fuseTranslationLoaderService.loadTranslations(english, chinese);
    }
}
