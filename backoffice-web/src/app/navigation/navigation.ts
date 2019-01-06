import {FuseNavigation} from '@fuse/types';

export const navigation: FuseNavigation[] = [
    {
        id: 'applications',
        title: 'Applications',
        translate: 'NAV.APPLICATIONS',
        type: 'group',
        children: [
            {
                id: 'sample',
                title: 'Sample',
                translate: 'NAV.SAMPLE.TITLE',
                type: 'item',
                icon: 'email',
                url: '/sample'
            }
        ]
    },
    {
        id: 'platform',
        title: 'Platform',
        translate: 'NAV.PLATFORM',
        type: 'group',
        icon: 'platform',
        children: [
            {
                id: 'user',
                title: 'User',
                translate: 'NAV.USER',
                type: 'collapsable',
                icon: 'view_quilt',
                children: [
                    {
                        id: 'employees',
                        title: 'Employees',
                        translate: 'NAV.EMPLOYEES',
                        type: 'item',
                        url: '/platform/user/employees'
                    }
                ]
            }
        ]
    }
];
