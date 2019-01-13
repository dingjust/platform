export class ItemModel {
    id?: number;

    constructor(props?) {
        props = props || {};
        this.id = props.id;
    }
}

/**
 * 枚举Model
 */
export class EnumModel {
    code: string;
    name: string;

    constructor(props?) {
        props = props || {};
        this.code = props.code;
        this.name = props.name;
    }
}

/**
 * 分页数据
 */
export class PaginationData {
    pageSize: number;
    currentPage: number;
    numberOfPages: number;
    totalNumberOfResults: number;

    constructor(props?) {
        props = props || {};
        this.pageSize = props.pageSize || 10;
        this.currentPage = props.currentPage || 0;
        this.numberOfPages = props.numberOfPages || 0;
        this.totalNumberOfResults = props.totalNumberOfResults || 0;
    }
}

/**
 * 分页
 */
export class Page<T> {
    content: T[];
    pagination: PaginationData;

    constructor(props?) {
        props = props || {};
        this.content = props.content || [];
        this.pagination = props.pagination || {};
    }
}
