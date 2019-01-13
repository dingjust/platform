/**
 * 所在行业
 */
import {EnumModel} from '../../item.model';

export enum LineOfBusiness {
    TRADE = 'TRADE',
    BANK = 'BANK',
    INDUSTRY = 'INDUSTRY',
    BUILDING = 'BUILDING',
    GOVERNMENT = 'GOVERNMENT',
    SERVICE = 'SERVICE'
}

export const LINE_OF_BUSINESS_OPTIONS: EnumModel[] = [
    {
        code: 'TRADE',
        name: '贸易',
    },
    {
        code: 'BANK',
        name: '银行',
    },
    {
        code: 'INDUSTRY',
        name: '工业',
    },
    {
        code: 'BUILDING',
        name: '建筑',
    },
    {
        code: 'GOVERNMENT',
        name: '政府',
    },
    {
        code: 'SERVICE',
        name: '服务业',
    }
];
