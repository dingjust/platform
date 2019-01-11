import {FuseNavigation} from '@fuse/types';

export const navigation: FuseNavigation[] = [
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
                    },
                    {
                        id: 'groups',
                        title: 'User Groups',
                        translate: 'NAV.USER_GROUPS',
                        type: 'item',
                        url: '/platform/user/user-groups'
                    },
                    {
                        id: 'roles',
                        title: 'Roles',
                        translate: 'NAV.ROLES',
                        type: 'item',
                        url: '/platform/user/roles'
                    },
                ]
            },
            {
                id: 'product',
                title: 'Product',
                translate: 'NAV.PRODUCT',
                type: 'collapsable',
                icon: 'view_quilt',
                children: [
                    {
                        id: 'categories',
                        title: 'Categories',
                        translate: 'NAV.CATEGORIES',
                        type: 'item',
                        url: '/platform/product/categories'
                    },
                    {
                        id: 'products',
                        title: 'Products',
                        translate: 'NAV.PRODUCTS',
                        type: 'item',
                        url: '/platform/product/products'
                    },
                ]
            },
            {
                id: 'order',
                title: 'Order',
                translate: 'NAV.ORDER',
                type: 'collapsable',
                icon: 'view_quilt',
                children: [
                    {
                        id: 'orders',
                        title: 'Orders',
                        translate: 'NAV.ORDERS',
                        type: 'item',
                        url: '/platform/order/orders'
                    },
                ]
            },
        ]
    },
];
