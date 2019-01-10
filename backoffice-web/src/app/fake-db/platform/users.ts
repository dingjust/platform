import {CountryModel} from '@hybris/models/i18n/i18n.model';
import {
    CompanyModel,
    CustomerModel,
    EmployeeModel,
    RoleModel,
    UserGroupModel,
    UserModel,
    LineOfBusiness
} from '@hybris/models/user';

export class PlatformUsersFakeDb {
    public static companies: CompanyModel[] = [
        {
            id: 1,
            uid: 'com000001',
            name: '定制加（深圳）科技有限公司',
            contact: new UserModel({uid: 'zhanhongbo', name: '湛红波'}),
            country: new CountryModel({isocode: 'CN', name: '中国'}),
            lineOfBusiness: LineOfBusiness.BANK,
            members: []
        }
    ];
    public static employees: EmployeeModel[] = [
        {
            id: 1,
            uid: 'admin',
            name: '系统管理员'
        }
    ];
    public static customers: CustomerModel[] = [
        {
            id: 1,
            uid: 'zhanhongbo',
            name: '湛红波'
        }
    ];
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
