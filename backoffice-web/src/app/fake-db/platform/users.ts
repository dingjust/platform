import {
    EmployeeModel,
    RoleModel,
    UserGroupModel,
} from '@hybris/models/user';
import {Page, PaginationData} from '../../../@hybris/models/item.model';

export class PlatformUsersFakeDb {
    public static employees: EmployeeModel[] = [
        {
            id: 1,
            uid: 'admin',
            name: '系统管理员'
        }
    ];

    public static pagedEmployees: Page<EmployeeModel> = {
        pagination: new PaginationData({
            pageSize: 10,
            currentPage: 0,
            numberOfPages: 1,
            totalNumberOfResults: 1
        }),
        content: PlatformUsersFakeDb.employees
    };

    public static userGroups: UserGroupModel[] = [
        {
            id: 1,
            uid: 'admingroup',
            name: '管理员组',
            members: []
        }
    ];
    public static roles: RoleModel[] = [
        {
            id: 1,
            uid: 'adminrole',
            name: '系统管理员',
            members: [],
            authorities: []
        }
    ];
}
