import {EnumModel} from './item.model';

export * from './item.model';
export * from './user';
export * from './security';
export * from './product';
export * from './order';

/**
 *
 * @param code
 * @param enums
 */
export function getEnumByCode(code: string, enums: EnumModel[]): EnumModel {
    return enums.filter(option => {
        return code === option.code;
    }).slice(0, 1)[0] || null;
}

/**
 *
 * @param codes
 * @param enums
 */
export function getEnumsByCode(codes: string[] | string, enums: EnumModel[]): EnumModel[] {
    if (typeof(codes) === 'string') {
        codes = [codes];
    }

    const _codes = [...codes];

    return enums.filter(option => {
        return _codes.some(item => {
            return item === option.code;
        });
    }) || [];
}

