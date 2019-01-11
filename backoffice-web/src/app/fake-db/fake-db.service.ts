import {InMemoryDbService} from 'angular-in-memory-web-api';

import {PlatformProductsFakeDb} from './platform/products';
import {PlatformOrdersFakeDb} from './platform/orders';
import {PlatformUsersFakeDb} from './platform/users';

import {ChatFakeDb} from 'app/fake-db/chat';
import {ChatPanelFakeDb} from 'app/fake-db/chat-panel';
import {QuickPanelFakeDb} from 'app/fake-db/quick-panel';

export class FakeDbService implements InMemoryDbService {
    createDb(): any {
        return {
            // Platform
            'platform-categories': PlatformProductsFakeDb.categories,
            'platform-products': PlatformProductsFakeDb.products,
            'platform-orders': PlatformOrdersFakeDb.orders,
            'platform-employees': PlatformUsersFakeDb.employees,
            'platform-user-groups': PlatformUsersFakeDb.userGroups,
            'platform-roles': PlatformUsersFakeDb.roles,

            // Chat
            'chat-contacts': ChatFakeDb.contacts,
            'chat-chats': ChatFakeDb.chats,
            'chat-user': ChatFakeDb.user,

            // Chat Panel
            'chat-panel-contacts': ChatPanelFakeDb.contacts,
            'chat-panel-chats': ChatPanelFakeDb.chats,
            'chat-panel-user': ChatPanelFakeDb.user,

            // Quick Panel
            'quick-panel-events': QuickPanelFakeDb.events
        };
    }
}
