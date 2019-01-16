import {Component} from '@angular/core';

import {FileUploader} from 'ng2-file-upload';

@Component({
    template: `
         <input type="file" ng2FileSelect [uploader]="uploader"
                       (change)="selectedFileOnChanged($event)"/>
    `
})
export class FileUploadDemoComponent {
    uploader: FileUploader = new FileUploader({
        url: 'http://www.download.com:80/uploadFile',
        method: 'POST',
        itemAlias: 'uploadedfile'
    });


    selectedFileOnChanged(): void {
        // 这里是文件选择完成后的操作处理
        this.uploader.queue[0].onSuccess = (response, status, headers) => {
            // 上传文件成功
            if (status === 200) {
                // 上传文件后获取服务器返回的数据
                const tempRes = JSON.parse(response);
            } else {
                // 上传文件后获取服务器返回的数据错误
            }
        };

        this.uploader.queue[0].upload(); // 开始上传
    }
}

