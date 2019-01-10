import {CatalogModel, CatalogVersionModel, CategoryModel, UnitModel} from '@hybris/models/product/product.model';

const DEFAULT_CATALOG = new CatalogModel({
    id: 'apparelProductCatalog',
    name: '服装产品目录'
});

export class PlatformProductsFakeDb {
    public static units: UnitModel[] = [
        {
            id: 1,
            code: 'pieces',
            name: '件'
        }
    ];
    public static catalogs: CatalogModel[] = [
        {
            id: 'apparelProductCatalog',
            name: '服装产品目录'
        }
    ];
    public static catalogVersions: CatalogVersionModel[] = [
        {
            id: 1,
            catalog: DEFAULT_CATALOG,
            version: 'Online'
        },
        {
            id: 2,
            catalog: DEFAULT_CATALOG,
            version: 'Stage'
        }
    ];
    public static categories: CategoryModel[] = [
        {
            id: 1,
            code: 'categories',
            name: '产品分类根目录',
            catalogVersion: new CatalogVersionModel({
                id: 1,
                catalog: DEFAULT_CATALOG,
                version: 'Online'
            })
        }
    ];
    public static products = [
        {
            'id': '1',
            'name': 'A Walk Amongst Friends - Canvas Print',
            'handle': 'a-walk-amongst-friends-canvas-print',
            'description': 'Officia amet eiusmod eu sunt tempor voluptate laboris velit nisi amet enim proident et. Consequat laborum non eiusmod cillum eu exercitation. Qui adipisicing est fugiat eiusmod esse. Sint aliqua cupidatat pariatur mollit ad est proident reprehenderit. Eiusmod adipisicing laborum incididunt sit aliqua ullamco.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 1,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 9.309,
            'priceTaxIncl': 10.24,
            'taxRate': 10,
            'comparedPrice': 19.90,
            'quantity': 3,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '2',
            'name': 'Braies Lake - Canvas Print',
            'handle': 'braies-lake-canvas-print',
            'description': 'Duis anim est non exercitation consequat. Ullamco ut ipsum dolore est elit est ea elit ad fugiat exercitation. Adipisicing eu ad sit culpa sint. Minim irure Lorem eiusmod minim nisi sit est consectetur.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 2,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 22.381,
            'priceTaxIncl': 24.62,
            'taxRate': 10,
            'comparedPrice': 29.90,
            'quantity': 92,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '3',
            'name': 'Fall Glow - Canvas Print',
            'handle': 'fall-glow-canvas-print',
            'description': 'Sit ipsum esse eu consequat veniam sit consectetur consectetur anim. Ut Lorem dolor ullamco do. Laboris excepteur consectetur tempor nisi commodo amet deserunt duis.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 3,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 44.809,
            'priceTaxIncl': 49.29,
            'taxRate': 10,
            'comparedPrice': 59.90,
            'quantity': 60,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '4',
            'name': 'First Snow - Canvas Print',
            'handle': 'first-snow-canvas-print',
            'description': 'Incididunt nostrud culpa labore nostrud veniam nostrud dolore velit sunt laborum ad reprehenderit. Excepteur enim irure ut labore elit ut deserunt qui qui consequat quis do nostrud ad. Aliqua dolor labore ut occaecat laborum irure. Aute in deserunt do aute laborum sit et reprehenderit minim voluptate proident do est.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 4,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 62.827,
            'priceTaxIncl': 69.11,
            'taxRate': 10,
            'comparedPrice': 79.90,
            'quantity': 101,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': false
        },
        {
            'id': '5',
            'name': 'Lago di Braies - Canvas Print',
            'handle': 'lago-di-braies-canvas-print',
            'description': 'Laboris laborum minim qui reprehenderit duis fugiat ea anim labore incididunt duis. Officia adipisicing anim amet in sit aliqua fugiat quis do sint non velit eu. Labore occaecat labore elit voluptate Lorem adipisicing et ipsum id et reprehenderit ullamco. Elit in nulla laborum nulla quis dolor deserunt magna dolor ad anim magna. Esse aute reprehenderit anim sit est et quis est. Ex reprehenderit culpa deserunt qui sint eiusmod reprehenderit ipsum consequat ut.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 5,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 9.309,
            'priceTaxIncl': 10.24,
            'taxRate': 10,
            'comparedPrice': 19.90,
            'quantity': 19,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '6',
            'name': 'Lago di Sorapis - Canvas Print',
            'handle': 'lago-di-sorapis-canvas-print',
            'description': 'Tempor sunt tempor veniam non culpa excepteur. Ea irure elit non cupidatat cillum dolore. Sit incididunt qui dolore ipsum commodo aliqua amet cupidatat incididunt nisi qui consectetur. Cillum eu aute qui irure aute adipisicing cupidatat magna.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 6,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 53.963,
            'priceTaxIncl': 59.36,
            'taxRate': 10,
            'comparedPrice': 69.90,
            'quantity': 101,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '7',
            'name': 'Never Stop Changing - Canvas Print',
            'handle': 'never-stop-changing-canvas-print',
            'description': 'Excepteur commodo ipsum in ex esse elit ea id voluptate id occaecat. Sunt Lorem ipsum ut proident eu aliquip velit non minim. Sunt velit deserunt veniam eu non veniam. Eiusmod sit ex et id incididunt labore aliqua eu aute dolor cillum ex mollit mollit. Incididunt voluptate adipisicing eiusmod non ipsum cupidatat excepteur enim in pariatur eu. Labore dolor qui exercitation amet labore laboris Lorem do adipisicing. Minim non consectetur adipisicing esse ut occaecat incididunt eiusmod commodo et cillum pariatur.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 7,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 58.372,
            'priceTaxIncl': 64.21,
            'taxRate': 10,
            'comparedPrice': 69.90,
            'quantity': 34,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '8',
            'name': 'Reaching - Canvas Print',
            'handle': 'reaching-canvas-print',
            'description': 'Velit cillum cupidatat eiusmod ea quis sit. Consequat dolore elit sunt sunt voluptate irure incididunt consectetur non. Dolore veniam ipsum anim commodo ex. Proident ipsum nostrud ullamco sit. Ad dolore nulla qui mollit laborum ex ipsum.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 8,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 63.390,
            'priceTaxIncl': 69.73,
            'taxRate': 10,
            'comparedPrice': 79.90,
            'quantity': 4,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': false
        },
        {
            'id': '9',
            'name': 'Morain Lake - Canvas Print',
            'handle': 'morain-lake-canvas-print',
            'description': 'Consequat minim velit commodo Lorem ipsum velit elit amet ut. In deserunt id duis nisi labore. Proident cillum et reprehenderit excepteur ex nulla enim.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 9,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 52.154,
            'priceTaxIncl': 57.37,
            'taxRate': 10,
            'comparedPrice': 59.90,
            'quantity': 58,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '10',
            'name': 'Yosemite - Canvas Print',
            'handle': 'yosemite-canvas-print',
            'description': 'Proident do sunt dolor tempor aliquip adipisicing dolor reprehenderit officia proident. Culpa non reprehenderit velit anim consequat velit elit eu culpa quis incididunt id. Eu incididunt exercitation nostrud est mollit officia. Laboris deserunt dolore sit occaecat exercitation quis sunt sunt nisi commodo.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 9,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 62.18,
            'priceTaxIncl': 68.40,
            'taxRate': 10,
            'comparedPrice': 69.90,
            'quantity': 125,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '11',
            'name': 'A Walk Amongst Friends - Canvas Print',
            'handle': 'a-walk-amongst-friends-canvas-print',
            'description': 'Officia amet eiusmod eu sunt tempor voluptate laboris velit nisi amet enim proident et. Consequat laborum non eiusmod cillum eu exercitation. Qui adipisicing est fugiat eiusmod esse. Sint aliqua cupidatat pariatur mollit ad est proident reprehenderit. Eiusmod adipisicing laborum incididunt sit aliqua ullamco.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 1,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 9.309,
            'priceTaxIncl': 10.24,
            'taxRate': 10,
            'comparedPrice': 19.90,
            'quantity': 3,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '12',
            'name': 'Never Stop Changing - Canvas Print',
            'handle': 'never-stop-changing-canvas-print',
            'description': 'Excepteur commodo ipsum in ex esse elit ea id voluptate id occaecat. Sunt Lorem ipsum ut proident eu aliquip velit non minim. Sunt velit deserunt veniam eu non veniam. Eiusmod sit ex et id incididunt labore aliqua eu aute dolor cillum ex mollit mollit. Incididunt voluptate adipisicing eiusmod non ipsum cupidatat excepteur enim in pariatur eu. Labore dolor qui exercitation amet labore laboris Lorem do adipisicing. Minim non consectetur adipisicing esse ut occaecat incididunt eiusmod commodo et cillum pariatur.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 7,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 58.372,
            'priceTaxIncl': 64.21,
            'taxRate': 10,
            'comparedPrice': 69.90,
            'quantity': 34,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '13',
            'name': 'Morain Lake - Canvas Print',
            'handle': 'morain-lake-canvas-print',
            'description': 'Consequat minim velit commodo Lorem ipsum velit elit amet ut. In deserunt id duis nisi labore. Proident cillum et reprehenderit excepteur ex nulla enim.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 9,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 52.154,
            'priceTaxIncl': 57.37,
            'taxRate': 10,
            'comparedPrice': 59.90,
            'quantity': 58,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '14',
            'name': 'Braies Lake - Canvas Print',
            'handle': 'braies-lake-canvas-print',
            'description': 'Duis anim est non exercitation consequat. Ullamco ut ipsum dolore est elit est ea elit ad fugiat exercitation. Adipisicing eu ad sit culpa sint. Minim irure Lorem eiusmod minim nisi sit est consectetur.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 2,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 22.381,
            'priceTaxIncl': 24.62,
            'taxRate': 10,
            'comparedPrice': 29.90,
            'quantity': 92,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '15',
            'name': 'Lago di Braies - Canvas Print',
            'handle': 'lago-di-braies-canvas-print',
            'description': 'Laboris laborum minim qui reprehenderit duis fugiat ea anim labore incididunt duis. Officia adipisicing anim amet in sit aliqua fugiat quis do sint non velit eu. Labore occaecat labore elit voluptate Lorem adipisicing et ipsum id et reprehenderit ullamco. Elit in nulla laborum nulla quis dolor deserunt magna dolor ad anim magna. Esse aute reprehenderit anim sit est et quis est. Ex reprehenderit culpa deserunt qui sint eiusmod reprehenderit ipsum consequat ut.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 5,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 9.309,
            'priceTaxIncl': 10.24,
            'taxRate': 10,
            'comparedPrice': 19.90,
            'quantity': 19,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '16',
            'name': 'Fall Glow - Canvas Print',
            'handle': 'fall-glow-canvas-print',
            'description': 'Sit ipsum esse eu consequat veniam sit consectetur consectetur anim. Ut Lorem dolor ullamco do. Laboris excepteur consectetur tempor nisi commodo amet deserunt duis.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 3,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 44.809,
            'priceTaxIncl': 49.29,
            'taxRate': 10,
            'comparedPrice': 59.90,
            'quantity': 60,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '17',
            'name': 'Lago di Sorapis - Canvas Print',
            'handle': 'lago-di-sorapis-canvas-print',
            'description': 'Tempor sunt tempor veniam non culpa excepteur. Ea irure elit non cupidatat cillum dolore. Sit incididunt qui dolore ipsum commodo aliqua amet cupidatat incididunt nisi qui consectetur. Cillum eu aute qui irure aute adipisicing cupidatat magna.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 6,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 53.963,
            'priceTaxIncl': 59.36,
            'taxRate': 10,
            'comparedPrice': 69.90,
            'quantity': 101,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        },
        {
            'id': '18',
            'name': 'Reaching - Canvas Print',
            'handle': 'reaching-canvas-print',
            'description': 'Velit cillum cupidatat eiusmod ea quis sit. Consequat dolore elit sunt sunt voluptate irure incididunt consectetur non. Dolore veniam ipsum anim commodo ex. Proident ipsum nostrud ullamco sit. Ad dolore nulla qui mollit laborum ex ipsum.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 8,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 63.390,
            'priceTaxIncl': 69.73,
            'taxRate': 10,
            'comparedPrice': 79.90,
            'quantity': 4,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': false
        },
        {
            'id': '19',
            'name': 'First Snow - Canvas Print',
            'handle': 'first-snow-canvas-print',
            'description': 'Incididunt nostrud culpa labore nostrud veniam nostrud dolore velit sunt laborum ad reprehenderit. Excepteur enim irure ut labore elit ut deserunt qui qui consequat quis do nostrud ad. Aliqua dolor labore ut occaecat laborum irure. Aute in deserunt do aute laborum sit et reprehenderit minim voluptate proident do est.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 4,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 62.827,
            'priceTaxIncl': 69.11,
            'taxRate': 10,
            'comparedPrice': 79.90,
            'quantity': 101,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': false
        },
        {
            'id': '20',
            'name': 'Yosemite - Canvas Print',
            'handle': 'yosemite-canvas-print',
            'description': 'Proident do sunt dolor tempor aliquip adipisicing dolor reprehenderit officia proident. Culpa non reprehenderit velit anim consequat velit elit eu culpa quis incididunt id. Eu incididunt exercitation nostrud est mollit officia. Laboris deserunt dolore sit occaecat exercitation quis sunt sunt nisi commodo.',
            'categories': [
                'Canvas Print',
                'Nature'
            ],
            'tags': [
                'canvas-print',
                'nature'
            ],
            'featuredImageId': 9,
            'images': [
                {
                    'id': 0,
                    'url': 'assets/images/ecommerce/a-walk-amongst-friends.jpg',
                    'type': 'image'
                },
                {
                    'id': 1,
                    'url': 'assets/images/ecommerce/braies-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 2,
                    'url': 'assets/images/ecommerce/fall-glow.jpg',
                    'type': 'image'
                },
                {
                    'id': 3,
                    'url': 'assets/images/ecommerce/first-snow.jpg',
                    'type': 'image'
                },
                {
                    'id': 4,
                    'url': 'assets/images/ecommerce/lago-di-braies.jpg',
                    'type': 'image'
                },
                {
                    'id': 5,
                    'url': 'assets/images/ecommerce/lago-di-sorapis.jpg',
                    'type': 'image'
                },
                {
                    'id': 6,
                    'url': 'assets/images/ecommerce/never-stop-changing.jpg',
                    'type': 'image'
                },
                {
                    'id': 7,
                    'url': 'assets/images/ecommerce/reaching.jpg',
                    'type': 'image'
                },
                {
                    'id': 8,
                    'url': 'assets/images/ecommerce/morain-lake.jpg',
                    'type': 'image'
                },
                {
                    'id': 9,
                    'url': 'assets/images/ecommerce/yosemite.jpg',
                    'type': 'image'
                }
            ],
            'priceTaxExcl': 62.18,
            'priceTaxIncl': 68.40,
            'taxRate': 10,
            'comparedPrice': 69.90,
            'quantity': 125,
            'sku': 'A445BV',
            'width': '22',
            'height': '24',
            'depth': '15',
            'weight': '3',
            'extraShippingFee': 3.00,
            'active': true
        }
    ];
}
