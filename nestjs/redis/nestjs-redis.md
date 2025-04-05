================================================
FILE: packages/redis/lib/index.spec.ts
================================================
import * as allExports from '.';

test('each of exports should be defined', () => {
  Object.values(allExports).forEach(value => expect(value).not.toBeNil());
});



================================================
FILE: packages/redis/lib/index.ts
================================================
export { ConnectionNotFoundError, MissingConfigurationsError } from './errors';
export { RedisModule } from './redis/redis.module';
export { DEFAULT_REDIS } from './redis/redis.constants';
export { RedisService } from './redis/redis.service';
export { ClusterModule } from './cluster/cluster.module';
export { DEFAULT_CLUSTER } from './cluster/cluster.constants';
export { ClusterService } from './cluster/cluster.service';

// * Types & Interfaces
export type { Namespace } from './interfaces';
export type {
  RedisModuleOptions,
  RedisModuleAsyncOptions,
  RedisOptionsFactory,
  RedisClientOptions
} from './redis/interfaces';
export type {
  ClusterModuleOptions,
  ClusterModuleAsyncOptions,
  ClusterOptionsFactory,
  ClusterClientOptions
} from './cluster/interfaces';



================================================
FILE: packages/redis/lib/cluster/cluster-logger.spec.ts
================================================
import { Logger } from '@nestjs/common';
import { logger } from './cluster-logger';

jest.mock('@nestjs/common', () => ({
  Logger: jest.fn()
}));

describe('logger', () => {
  test('should be defined', () => {
    expect(logger).toBeInstanceOf(Logger);
    expect(Logger).toHaveBeenCalledTimes(1);
  });
});



================================================
FILE: packages/redis/lib/cluster/cluster-logger.ts
================================================
import { Logger } from '@nestjs/common';
import { CLUSTER_MODULE_ID } from './cluster.constants';

export const logger = new Logger(CLUSTER_MODULE_ID, { timestamp: true });



================================================
FILE: packages/redis/lib/cluster/cluster.constants.spec.ts
================================================
import * as constants from './cluster.constants';

test('each of constants should be defined', () => {
  Object.values(constants).forEach(value => expect(value).not.toBeNil());
});



================================================
FILE: packages/redis/lib/cluster/cluster.constants.ts
================================================
export const CLUSTER_OPTIONS = Symbol();

export const CLUSTER_MERGED_OPTIONS = Symbol();

export const CLUSTER_CLIENTS = Symbol();

/**
 * The default cluster namespace.
 */
export const DEFAULT_CLUSTER = 'default';

export const CLUSTER_MODULE_ID = 'ClusterModule';

export const NAMESPACE_KEY = Symbol();



================================================
FILE: packages/redis/lib/cluster/cluster.module.spec.ts
================================================
import { ModuleRef } from '@nestjs/core';
import { ClusterModule } from './cluster.module';
import { ClusterModuleAsyncOptions } from './interfaces';
import { destroy } from './common';
import { logger } from './cluster-logger';
import { CLUSTER_CLIENTS, CLUSTER_MERGED_OPTIONS } from './cluster.constants';

jest.mock('./common');
jest.mock('./cluster-logger', () => ({
  logger: {
    error: jest.fn()
  }
}));

describe('forRoot', () => {
  test('should work correctly', () => {
    const module = ClusterModule.forRoot({ config: { nodes: [] } });
    expect(module.global).toBe(true);
    expect(module.module).toBe(ClusterModule);
    expect(module.providers?.length).toBeGreaterThanOrEqual(4);
    expect(module.exports?.length).toBeGreaterThanOrEqual(1);
  });
});

describe('forRootAsync', () => {
  test('should work correctly', () => {
    const options: ClusterModuleAsyncOptions = {
      imports: [],
      useFactory: () => ({ config: { nodes: [] } }),
      inject: [],
      extraProviders: [{ provide: '', useValue: '' }]
    };
    const module = ClusterModule.forRootAsync(options);
    expect(module.global).toBe(true);
    expect(module.module).toBe(ClusterModule);
    expect(module.imports).toBeArray();
    expect(module.providers?.length).toBeGreaterThanOrEqual(5);
    expect(module.exports?.length).toBeGreaterThanOrEqual(1);
  });

  test('without extraProviders', () => {
    const options: ClusterModuleAsyncOptions = {
      useFactory: () => ({ config: { nodes: [] } })
    };
    const module = ClusterModule.forRootAsync(options);
    expect(module.providers?.length).toBeGreaterThanOrEqual(4);
  });

  test('should throw an error', () => {
    expect(() => ClusterModule.forRootAsync({})).toThrow();
  });
});

describe('onApplicationShutdown', () => {
  const mockDestroy = destroy as jest.MockedFunction<typeof destroy>;
  const mockError = jest.spyOn(logger, 'error');

  beforeEach(() => {
    mockDestroy.mockClear();
    mockError.mockClear();
  });

  test('should work correctly', async () => {
    mockDestroy.mockResolvedValue([
      [
        { status: 'fulfilled', value: '' },
        { status: 'rejected', reason: new Error('') }
      ]
    ]);

    const module = new ClusterModule({
      get: (token: unknown) => {
        if (token === CLUSTER_MERGED_OPTIONS) return { closeClient: true };
        if (token === CLUSTER_CLIENTS) return new Map();
      }
    } as ModuleRef);
    await module.onApplicationShutdown();
    expect(mockDestroy).toHaveBeenCalledTimes(1);
    expect(mockError).toHaveBeenCalledTimes(1);
  });
});



================================================
FILE: packages/redis/lib/cluster/cluster.module.ts
================================================
import { Module, DynamicModule, Provider, OnApplicationShutdown } from '@nestjs/common';
import { ModuleRef } from '@nestjs/core';
import { ClusterModuleOptions, ClusterModuleAsyncOptions, ClusterClients } from './interfaces';
import { ClusterService } from './cluster.service';
import {
  createOptionsProvider,
  createAsyncProviders,
  clusterClientsProvider,
  mergedOptionsProvider
} from './cluster.providers';
import { CLUSTER_CLIENTS, CLUSTER_MERGED_OPTIONS } from './cluster.constants';
import { isError } from '@/utils';
import { logger } from './cluster-logger';
import { MissingConfigurationsError } from '@/errors';
import { generateErrorMessage } from '@/messages';

@Module({})
export class ClusterModule implements OnApplicationShutdown {
  constructor(private moduleRef: ModuleRef) {}

  /**
   * Registers the module synchronously.
   *
   * @param options - The module options
   * @param isGlobal - Register in the global scope
   * @returns A DynamicModule
   */
  static forRoot(options: ClusterModuleOptions, isGlobal = true): DynamicModule {
    const providers: Provider[] = [
      createOptionsProvider(options),
      clusterClientsProvider,
      mergedOptionsProvider,
      ClusterService
    ];

    return {
      global: isGlobal,
      module: ClusterModule,
      providers,
      exports: [ClusterService]
    };
  }

  /**
   * Registers the module asynchronously.
   *
   * @param options - The async module options
   * @param isGlobal - Register in the global scope
   * @returns A DynamicModule
   */
  static forRootAsync(options: ClusterModuleAsyncOptions, isGlobal = true): DynamicModule {
    if (!options.useFactory && !options.useClass && !options.useExisting) {
      throw new MissingConfigurationsError();
    }

    const providers: Provider[] = [
      ...createAsyncProviders(options),
      clusterClientsProvider,
      mergedOptionsProvider,
      ClusterService,
      ...(options.extraProviders ?? [])
    ];

    return {
      global: isGlobal,
      module: ClusterModule,
      imports: options.imports,
      providers,
      exports: [ClusterService]
    };
  }

  async onApplicationShutdown(): Promise<void> {
    const { closeClient } = this.moduleRef.get<ClusterModuleOptions>(CLUSTER_MERGED_OPTIONS, { strict: false });
    if (closeClient) {
      const clients = this.moduleRef.get<ClusterClients>(CLUSTER_CLIENTS, { strict: false });
      for (const [namespace, client] of clients) {
        if (client.status === 'end') continue;
        if (client.status === 'ready') {
          try {
            await client.quit();
          } catch (e) {
            if (isError(e)) logger.error(generateErrorMessage(namespace, e.message), e.stack);
          }
          continue;
        }
        client.disconnect();
      }
    }
  }
}



================================================
FILE: packages/redis/lib/cluster/cluster.providers.spec.ts
================================================
import { Test, TestingModule } from '@nestjs/testing';
import { Cluster } from 'ioredis';
import {
  createOptionsProvider,
  createAsyncProviders,
  createAsyncOptionsProvider,
  clusterClientsProvider,
  createClusterClientProviders,
  createAsyncOptions,
  mergedOptionsProvider
} from './cluster.providers';
import { ClusterOptionsFactory, ClusterModuleAsyncOptions, ClusterClients, ClusterModuleOptions } from './interfaces';
import { CLUSTER_OPTIONS, CLUSTER_CLIENTS, CLUSTER_MERGED_OPTIONS } from './cluster.constants';
import { namespaces } from './common';
import { ClusterManager } from './cluster-manager';
import { defaultClusterModuleOptions } from './default-options';

jest.mock('ioredis', () => ({
  Cluster: jest.fn(() => ({}))
}));

describe('createOptionsProvider', () => {
  test('should work correctly', () => {
    expect(createOptionsProvider({ config: { nodes: [] } })).toEqual({
      provide: CLUSTER_OPTIONS,
      useValue: { config: { nodes: [] } }
    });
  });
});

describe('createAsyncProviders', () => {
  class ClusterConfigService implements ClusterOptionsFactory {
    createClusterOptions(): ClusterModuleOptions {
      return { config: { nodes: [] } };
    }
  }

  test('with useFactory', () => {
    const result = createAsyncProviders({ useFactory: () => ({ config: { nodes: [] } }), inject: [] });
    expect(result).toHaveLength(1);
    expect(result).toPartiallyContain({ provide: CLUSTER_OPTIONS, inject: [] });
    expect(result[0]).toHaveProperty('useFactory');
  });

  test('with useClass', () => {
    const result = createAsyncProviders({ useClass: ClusterConfigService });
    expect(result).toHaveLength(2);
    expect(result).toIncludeAllPartialMembers([
      { provide: ClusterConfigService, useClass: ClusterConfigService },
      { provide: CLUSTER_OPTIONS, inject: [ClusterConfigService] }
    ]);
    expect(result[1]).toHaveProperty('useFactory');
  });

  test('with useExisting', () => {
    const result = createAsyncProviders({ useExisting: ClusterConfigService });
    expect(result).toHaveLength(1);
    expect(result).toIncludeAllPartialMembers([{ provide: CLUSTER_OPTIONS, inject: [ClusterConfigService] }]);
    expect(result[0]).toHaveProperty('useFactory');
  });

  test('without options', () => {
    const result = createAsyncProviders({});
    expect(result).toHaveLength(0);
  });
});

describe('createAsyncOptions', () => {
  test('should work correctly', async () => {
    const clusterConfigService: ClusterOptionsFactory = {
      createClusterOptions(): ClusterModuleOptions {
        return { closeClient: true, config: { nodes: [] } };
      }
    };
    await expect(createAsyncOptions(clusterConfigService)).resolves.toEqual({
      closeClient: true,
      config: { nodes: [] }
    });
  });
});

describe('createAsyncOptionsProvider', () => {
  class ClusterConfigService implements ClusterOptionsFactory {
    createClusterOptions(): ClusterModuleOptions {
      return { config: { nodes: [] } };
    }
  }

  test('with useFactory', () => {
    const options: ClusterModuleAsyncOptions = { useFactory: () => ({ config: { nodes: [] } }), inject: ['token'] };
    expect(createAsyncOptionsProvider(options)).toEqual({ provide: CLUSTER_OPTIONS, ...options });
  });

  test('with useClass', () => {
    const options: ClusterModuleAsyncOptions = { useClass: ClusterConfigService };
    expect(createAsyncOptionsProvider(options)).toHaveProperty('provide', CLUSTER_OPTIONS);
    expect(createAsyncOptionsProvider(options)).toHaveProperty('useFactory');
    expect(createAsyncOptionsProvider(options)).toHaveProperty('inject', [ClusterConfigService]);
  });

  test('with useExisting', () => {
    const options: ClusterModuleAsyncOptions = { useExisting: ClusterConfigService };
    expect(createAsyncOptionsProvider(options)).toHaveProperty('provide', CLUSTER_OPTIONS);
    expect(createAsyncOptionsProvider(options)).toHaveProperty('useFactory');
    expect(createAsyncOptionsProvider(options)).toHaveProperty('inject', [ClusterConfigService]);
  });

  test('without options', () => {
    expect(createAsyncOptionsProvider({})).toEqual({ provide: CLUSTER_OPTIONS, useValue: {} });
  });
});

describe('createClusterClientProviders', () => {
  let clients: ClusterClients;
  let client1: Cluster;
  let client2: Cluster;

  beforeEach(async () => {
    clients = new Map();
    clients.set('client1', new Cluster([]));
    clients.set('client2', new Cluster([]));
    namespaces.set('client1', 'client1');
    namespaces.set('client2', 'client2');

    const module: TestingModule = await Test.createTestingModule({
      providers: [{ provide: CLUSTER_CLIENTS, useValue: clients }, ClusterManager, ...createClusterClientProviders()]
    }).compile();

    client1 = module.get<Cluster>('client1');
    client2 = module.get<Cluster>('client2');
  });

  afterEach(() => {
    namespaces.clear();
  });

  test('should work correctly', () => {
    expect(client1).toBeDefined();
    expect(client2).toBeDefined();
  });
});

describe('clusterClientsProvider', () => {
  test('should be a dynamic module', () => {
    expect(clusterClientsProvider).toHaveProperty('provide', CLUSTER_CLIENTS);
    expect(clusterClientsProvider).toHaveProperty('useFactory');
    expect(clusterClientsProvider).toHaveProperty('inject', [CLUSTER_MERGED_OPTIONS]);
  });

  test('with multiple clients', async () => {
    const options: ClusterModuleOptions = { config: [{ nodes: [] }, { namespace: 'client1', nodes: [] }] };
    const clients = await clusterClientsProvider.useFactory(options);
    expect(clients.size).toBe(2);
  });

  describe('with single client', () => {
    test('with namespace', async () => {
      const options: ClusterModuleOptions = { config: { namespace: 'client1', nodes: [] } };
      const clients = await clusterClientsProvider.useFactory(options);
      expect(clients.size).toBe(1);
    });

    test('without namespace', async () => {
      const options: ClusterModuleOptions = { config: { nodes: [] } };
      const clients = await clusterClientsProvider.useFactory(options);
      expect(clients.size).toBe(1);
    });
  });
});

describe('mergedOptionsProvider', () => {
  test('should be a dynamic module', () => {
    expect(mergedOptionsProvider).toHaveProperty('provide', CLUSTER_MERGED_OPTIONS);
    expect(mergedOptionsProvider).toHaveProperty('useFactory');
    expect(mergedOptionsProvider).toHaveProperty('inject', [CLUSTER_OPTIONS]);
  });

  test('should work correctly', async () => {
    const options: ClusterModuleOptions = { closeClient: false, config: { nodes: [] } };
    const mergedOptions = await mergedOptionsProvider.useFactory(options);
    expect(mergedOptions).toEqual({ ...defaultClusterModuleOptions, ...options });
  });
});



================================================
FILE: packages/redis/lib/cluster/cluster.providers.ts
================================================
import { Provider, FactoryProvider, ValueProvider } from '@nestjs/common';
import { ClusterModuleOptions, ClusterModuleAsyncOptions, ClusterOptionsFactory, ClusterClients } from './interfaces';
import { CLUSTER_OPTIONS, CLUSTER_CLIENTS, DEFAULT_CLUSTER, CLUSTER_MERGED_OPTIONS } from './cluster.constants';
import { createClient } from './common';
import { defaultClusterModuleOptions } from './default-options';

export const createOptionsProvider = (options: ClusterModuleOptions): ValueProvider<ClusterModuleOptions> => ({
  provide: CLUSTER_OPTIONS,
  useValue: options
});

export const createAsyncProviders = (options: ClusterModuleAsyncOptions): Provider[] => {
  if (options.useClass) {
    return [
      {
        provide: options.useClass,
        useClass: options.useClass
      },
      createAsyncOptionsProvider(options)
    ];
  }

  if (options.useExisting || options.useFactory) return [createAsyncOptionsProvider(options)];

  return [];
};

export const createAsyncOptions = async (optionsFactory: ClusterOptionsFactory): Promise<ClusterModuleOptions> => {
  return await optionsFactory.createClusterOptions();
};

export const createAsyncOptionsProvider = (options: ClusterModuleAsyncOptions): Provider => {
  if (options.useFactory) {
    return {
      provide: CLUSTER_OPTIONS,
      useFactory: options.useFactory,
      inject: options.inject
    };
  }

  if (options.useClass) {
    return {
      provide: CLUSTER_OPTIONS,
      useFactory: createAsyncOptions,
      inject: [options.useClass]
    };
  }

  if (options.useExisting) {
    return {
      provide: CLUSTER_OPTIONS,
      useFactory: createAsyncOptions,
      inject: [options.useExisting]
    };
  }

  return {
    provide: CLUSTER_OPTIONS,
    useValue: {}
  };
};

export const clusterClientsProvider: FactoryProvider<ClusterClients> = {
  provide: CLUSTER_CLIENTS,
  useFactory: (options: ClusterModuleOptions) => {
    const clients: ClusterClients = new Map();
    if (Array.isArray(options.config)) {
      options.config.forEach(item =>
        clients.set(
          item.namespace ?? DEFAULT_CLUSTER,
          createClient(item, { readyLog: options.readyLog, errorLog: options.errorLog })
        )
      );
    } else if (options.config) {
      clients.set(
        options.config.namespace ?? DEFAULT_CLUSTER,
        createClient(options.config, { readyLog: options.readyLog, errorLog: options.errorLog })
      );
    }
    return clients;
  },
  inject: [CLUSTER_MERGED_OPTIONS]
};

export const mergedOptionsProvider: FactoryProvider<ClusterModuleOptions> = {
  provide: CLUSTER_MERGED_OPTIONS,
  useFactory: (options: ClusterModuleOptions) => ({ ...defaultClusterModuleOptions, ...options }),
  inject: [CLUSTER_OPTIONS]
};



================================================
FILE: packages/redis/lib/cluster/cluster.service.spec.ts
================================================
import { Test, TestingModule } from '@nestjs/testing';
import { Cluster } from 'ioredis';
import { ClusterManager } from './cluster-manager';
import { ClusterClients } from './interfaces';
import { CLUSTER_CLIENTS, DEFAULT_CLUSTER_NAMESPACE } from './cluster.constants';

jest.mock('ioredis', () => ({
  Cluster: jest.fn(() => ({}))
}));

describe('ClusterManager', () => {
  let clients: ClusterClients;
  let manager: ClusterManager;

  beforeEach(async () => {
    clients = new Map();
    clients.set(DEFAULT_CLUSTER_NAMESPACE, new Cluster([]));
    clients.set('client1', new Cluster([]));

    const module: TestingModule = await Test.createTestingModule({
      providers: [{ provide: CLUSTER_CLIENTS, useValue: clients }, ClusterManager]
    }).compile();

    manager = module.get<ClusterManager>(ClusterManager);
  });

  test('should have 2 members', () => {
    expect(manager.clients.size).toBe(2);
  });

  test('should get a client with namespace', () => {
    const client = manager.getClient('client1');
    expect(client).toBeDefined();
  });

  test('should get default client with namespace', () => {
    const client = manager.getClient(DEFAULT_CLUSTER_NAMESPACE);
    expect(client).toBeDefined();
  });

  test('should get default client without namespace', () => {
    const client = manager.getClient();
    expect(client).toBeDefined();
  });

  test('should throw an error when getting a client with an unknown namespace', () => {
    expect(() => manager.getClient('')).toThrow();
  });
});



================================================
FILE: packages/redis/lib/cluster/cluster.service.ts
================================================
import { Injectable, Inject } from '@nestjs/common';
import type { Cluster } from 'ioredis';
import { CLUSTER_CLIENTS, DEFAULT_CLUSTER } from './cluster.constants';
import type { ClusterClients } from './interfaces';
import { parseNamespace } from '@/utils';
import type { Namespace } from '@/interfaces';
import { ConnectionNotFoundError } from '@/errors';

/**
 * Manager for cluster connections.
 */
@Injectable()
export class ClusterService {
  constructor(@Inject(CLUSTER_CLIENTS) private readonly clients: ClusterClients) {}

  /**
   * Retrieves a cluster connection by namespace.
   * However, if the query does not find a connection, it returns ClientNotFoundError: No Connection found error.
   *
   * @param namespace - The namespace
   * @returns A cluster connection
   */
  getOrThrow(namespace: Namespace = DEFAULT_CLUSTER): Cluster {
    const client = this.clients.get(namespace);
    if (!client) throw new ConnectionNotFoundError(parseNamespace(namespace));
    return client;
  }

  /**
   * Retrieves a cluster connection by namespace, if the query does not find a connection, it returns `null`;
   *
   * @param namespace - The namespace
   * @returns A cluster connection or nil
   */
  getOrNil(namespace: Namespace = DEFAULT_CLUSTER): Cluster | null {
    const client = this.clients.get(namespace);
    if (!client) return null;
    return client;
  }
}



================================================
FILE: packages/redis/lib/cluster/default-options.spec.ts
================================================
import { defaultClusterModuleOptions } from './default-options';

describe('defaultClusterModuleOptions', () => {
  test('should validate the defaultClusterModuleOptions', () => {
    expect(defaultClusterModuleOptions.closeClient).toBe(true);
    expect(defaultClusterModuleOptions.readyLog).toBe(false);
    expect(defaultClusterModuleOptions.config).toBeUndefined();
  });
});



================================================
FILE: packages/redis/lib/cluster/default-options.ts
================================================
import { ClusterModuleOptions } from './interfaces';

export const defaultClusterModuleOptions: Partial<ClusterModuleOptions> = {
  closeClient: true,
  readyLog: false,
  errorLog: true,
  config: undefined
};



================================================
FILE: packages/redis/lib/cluster/common/cluster.utils.spec.ts
================================================
import { Cluster } from 'ioredis';
import { createClient, destroy, addListeners } from './cluster.utils';
import { ClusterClients, ClusterClientOptions } from '../interfaces';
import { NAMESPACE_KEY } from '../cluster.constants';

jest.mock('../cluster-logger', () => ({
  logger: {
    log: jest.fn(),
    error: jest.fn()
  }
}));

const mockOn = jest.fn();
jest.mock('ioredis', () => ({
  Cluster: jest.fn(() => ({
    on: mockOn,
    quit: jest.fn(),
    disconnect: jest.fn()
  }))
}));

const MockedCluster = Cluster as jest.MockedClass<typeof Cluster>;
beforeEach(() => {
  MockedCluster.mockClear();
  mockOn.mockReset();
});

describe('createClient', () => {
  test('should create a client with options', () => {
    const options: ClusterClientOptions = {
      nodes: [{ host: '127.0.0.1', port: 16380 }],
      redisOptions: { password: '' }
    };
    const client = createClient(options, {});
    expect(client).toBeDefined();
    expect(MockedCluster).toHaveBeenCalledTimes(1);
    expect(MockedCluster).toHaveBeenCalledWith(options.nodes, { redisOptions: { password: '' } });
    expect(MockedCluster.mock.instances).toHaveLength(1);
  });

  test('should call onClientCreated', () => {
    const mockOnClientCreated = jest.fn();

    const client = createClient({ nodes: [], onClientCreated: mockOnClientCreated }, {});
    expect(client).toBeDefined();
    expect(MockedCluster).toHaveBeenCalledTimes(1);
    expect(MockedCluster).toHaveBeenCalledWith([], {});
    expect(MockedCluster.mock.instances).toHaveLength(1);
    expect(mockOnClientCreated).toHaveBeenCalledTimes(1);
    expect(mockOnClientCreated).toHaveBeenCalledWith(client);
  });
});

describe('destroy', () => {
  let client1: Cluster;
  let client2: Cluster;
  let clients: ClusterClients;

  beforeEach(() => {
    client1 = new Cluster([]);
    client2 = new Cluster([]);
    clients = new Map();
    clients.set('client1', client1);
    clients.set('client2', client2);
  });

  test('when the status is ready', async () => {
    Reflect.set(client1, 'status', 'ready');
    Reflect.set(client2, 'status', 'ready');

    const mockClient1Quit = jest.spyOn(client1, 'quit').mockRejectedValue(new Error());
    const mockClient2Quit = jest.spyOn(client2, 'quit').mockRejectedValue('');

    const results = await destroy(clients);
    expect(mockClient1Quit).toHaveBeenCalled();
    expect(mockClient2Quit).toHaveBeenCalled();
    expect(results).toHaveLength(2);
    expect(results[0][0]).toEqual({ status: 'fulfilled', value: 'client1' });
    expect(results[0][1]).toHaveProperty('status', 'rejected');
    expect(results[1][0]).toEqual({ status: 'fulfilled', value: 'client2' });
    expect(results[1][1]).toEqual({ status: 'rejected', reason: '' });
  });

  test('when the status is ready, end', async () => {
    Reflect.set(client1, 'status', 'ready');
    Reflect.set(client2, 'status', 'end');

    const mockClient1Quit = jest.spyOn(client1, 'quit').mockResolvedValue('OK');

    const results = await destroy(clients);
    expect(mockClient1Quit).toHaveBeenCalled();
    expect(results).toHaveLength(1);
  });

  test('when the status is wait', async () => {
    Reflect.set(client1, 'status', 'wait');
    Reflect.set(client2, 'status', 'wait');

    const mockClient1Disconnect = jest.spyOn(client1, 'disconnect');
    const mockClient2Disconnect = jest.spyOn(client2, 'disconnect');

    const results = await destroy(clients);
    expect(mockClient1Disconnect).toHaveBeenCalled();
    expect(mockClient2Disconnect).toHaveBeenCalled();
    expect(results).toHaveLength(0);
  });
});

describe('addListeners', () => {
  let client: Cluster;

  beforeEach(() => {
    client = new Cluster([]);
  });

  test('should set namespace correctly', () => {
    const namespace = Symbol();
    addListeners({ namespace, instance: client, readyLog: false, errorLog: false });
    expect(Reflect.get(client, NAMESPACE_KEY)).toBe(namespace);
  });

  test('should add ready listener', () => {
    mockOn.mockImplementation((_, fn: (...args: unknown[]) => void) => {
      fn.call(client);
    });
    addListeners({ namespace: '', instance: client, readyLog: true, errorLog: false });
    expect(mockOn).toHaveBeenCalledTimes(1);
  });

  test('should add error listener', () => {
    mockOn.mockImplementation((_, fn: (...args: unknown[]) => void) => {
      fn.call(client, new Error());
    });
    addListeners({ namespace: '', instance: client, readyLog: false, errorLog: true });
    expect(mockOn).toHaveBeenCalledTimes(1);
  });
});



================================================
FILE: packages/redis/lib/cluster/common/cluster.utils.ts
================================================
import { Cluster } from 'ioredis';
import { ClusterClientOptions, ClusterModuleOptions } from '../interfaces';
import { Namespace } from '@/interfaces';
import { generateReadyMessage, generateErrorMessage } from '@/messages';
import { logger } from '../cluster-logger';
import { get } from '@/utils';
import { DEFAULT_CLUSTER, NAMESPACE_KEY } from '../cluster.constants';

export const createClient = (
  { namespace, nodes, onClientCreated, ...clusterOptions }: ClusterClientOptions,
  { readyLog, errorLog }: Partial<ClusterModuleOptions>
): Cluster => {
  const client = new Cluster(nodes, clusterOptions);
  Reflect.defineProperty(client, NAMESPACE_KEY, {
    value: namespace ?? DEFAULT_CLUSTER,
    writable: false,
    enumerable: false,
    configurable: false
  });
  if (readyLog) {
    client.on('ready', () => {
      logger.log(generateReadyMessage(get<Namespace>(client, NAMESPACE_KEY)));
    });
  }
  if (errorLog) {
    client.on('error', (error: Error) => {
      logger.error(generateErrorMessage(get<Namespace>(client, NAMESPACE_KEY), error.message), error.stack);
    });
  }
  if (onClientCreated) onClientCreated(client);
  return client;
};



================================================
FILE: packages/redis/lib/cluster/common/index.spec.ts
================================================
import * as allExports from '.';

test('there should be 6 exports', () => {
  expect(Object.keys(allExports)).toHaveLength(6);
});

test('each of exports should be defined', () => {
  Object.values(allExports).forEach(value => expect(value).not.toBeNil());
});



================================================
FILE: packages/redis/lib/cluster/common/index.ts
================================================
export * from './cluster.utils';



================================================
FILE: packages/redis/lib/cluster/interfaces/cluster-module-options.interface.ts
================================================
import { Type, ModuleMetadata, Provider, InjectionToken, OptionalFactoryDependency } from '@nestjs/common';
import type { Cluster, ClusterNode, ClusterOptions } from 'ioredis';
import { Namespace } from '@/interfaces';

export interface ClusterClientOptions extends ClusterOptions {
  /**
   * Name of the client. If the name is not given then it will be set to "default".
   *
   * Please note that you shouldn't have multiple connections without a namespace, or with the same namespace, otherwise they will get overridden.
   *
   * For the default name you can also explicitly import `DEFAULT_CLUSTER`.
   *
   * @defaultValue `"default"`
   */
  namespace?: Namespace;
  /**
   * List of cluster nodes.
   *
   * @example
   * ```ts
   * // Connect with url
   * nodes: ['redis://:authpassword@127.0.0.1:16380']
   * ```
   *
   * @example
   * ```ts
   * // Connect with host, port
   * nodes: [
   *   {
   *     port: 6380,
   *     host: '127.0.0.1'
   *   },
   *   {
   *     port: 6381,
   *     host: '127.0.0.1'
   *   }
   * ]
   * ```
   */
  nodes: ClusterNode[];
  /**
   * Called after the client has been created.
   */
  created?: (client: Cluster) => void;
  /**
   * Function to be executed after the client is created.
   *
   * @deprecated Use the new `created` instead.
   */
  onClientCreated?: (client: Cluster) => void;
}

export interface ClusterModuleOptions {
  /**
   * If set to `true`, all clients will be closed automatically on nestjs application shutdown.
   *
   * @defaultValue `true`
   */
  closeClient?: boolean;
  /**
   * If set to `true`, then ready logging will be displayed when the client is ready.
   *
   * @defaultValue `true`
   */
  readyLog?: boolean;
  /**
   * If set to `true`, then errors that occurred while connecting will be displayed by the built-in logger.
   *
   * @defaultValue `true`
   */
  errorLog?: boolean;
  /**
   * Used to specify single or multiple clients.
   */
  config: ClusterClientOptions | ClusterClientOptions[];
}

export interface ClusterModuleAsyncOptions extends Pick<ModuleMetadata, 'imports'> {
  useFactory?: (...args: unknown[]) => ClusterModuleOptions | Promise<ClusterModuleOptions>;
  useClass?: Type<ClusterOptionsFactory>;
  useExisting?: Type<ClusterOptionsFactory>;
  inject?: (InjectionToken | OptionalFactoryDependency)[];
  extraProviders?: Provider[];
}

export interface ClusterOptionsFactory {
  createClusterOptions: () => ClusterModuleOptions | Promise<ClusterModuleOptions>;
}



================================================
FILE: packages/redis/lib/cluster/interfaces/cluster.interface.ts
================================================
import type { Cluster } from 'ioredis';
import { Namespace } from '@/interfaces';

export type ClusterClients = Map<Namespace, Cluster>;



================================================
FILE: packages/redis/lib/cluster/interfaces/index.ts
================================================
export * from './cluster-module-options.interface';
export * from './cluster.interface';



================================================
FILE: packages/redis/lib/errors/connection-not-found.error.spec.ts
================================================
import { ClientNotFoundError } from './client-not-found.error';

describe('ClientNotFoundError', () => {
  test('should create an instance for redis', () => {
    const error = new ClientNotFoundError('name', 'redis');
    expect(error.name).toBe(ClientNotFoundError.name);
    expect(error.message).toContain('name');
    expect(error.message).toContain('redis');
    expect(error.stack).toBeDefined();
  });

  test('should create an instance for cluster', () => {
    const error = new ClientNotFoundError('name', 'cluster');
    expect(error.name).toBe(ClientNotFoundError.name);
    expect(error.message).toContain('name');
    expect(error.message).toContain('cluster');
    expect(error.stack).toBeDefined();
  });
});



================================================
FILE: packages/redis/lib/errors/connection-not-found.error.ts
================================================
/**
 * Thrown when consumer tries to get connection that does not exist.
 */
export class ConnectionNotFoundError extends Error {
  constructor(namespace: string) {
    super(`Connection "${namespace}" was not found.`);
    this.name = this.constructor.name;
  }
}



================================================
FILE: packages/redis/lib/errors/index.spec.ts
================================================
import * as allExports from '.';

test('there should be 2 exports', () => {
  expect(Object.keys(allExports)).toHaveLength(2);
});

test('each of exports should be defined', () => {
  Object.values(allExports).forEach(value => expect(value).not.toBeNil());
});



================================================
FILE: packages/redis/lib/errors/index.ts
================================================
export * from './missing-configurations.error';
export * from './connection-not-found.error';



================================================
FILE: packages/redis/lib/errors/missing-configuration.error.spec.ts
================================================
import { MissingConfigurationsError } from './missing-configurations.error';

describe('MissingConfigurationsError', () => {
  test('should create an instance', () => {
    const error = new MissingConfigurationsError();
    expect(error.name).toBe(MissingConfigurationsError.name);
    expect(error.message).toBeString();
    expect(error.stack).toBeDefined();
  });
});



================================================
FILE: packages/redis/lib/errors/missing-configurations.error.ts
================================================
/**
 * Thrown when async configurations are missing.
 */
export class MissingConfigurationsError extends Error {
  constructor() {
    super(`Missing required asynchronous configurations. Expected one of: "useFactory", "useClass", "useExisting".`);
    this.name = this.constructor.name;
  }
}



================================================
FILE: packages/redis/lib/interfaces/index.ts
================================================
/* eslint-disable @typescript-eslint/no-explicit-any */

export type Namespace = string | symbol;

export type Constructor<T, Arguments extends unknown[] = any[]> = new (...arguments_: Arguments) => T;

export type Class<T, Arguments extends unknown[] = any[]> = Constructor<T, Arguments> & { prototype: T };



================================================
FILE: packages/redis/lib/messages/index.spec.ts
================================================
import { READY_LOG, ERROR_LOG } from '.';

describe('READY_LOG', () => {
  test('should return a string', () => {
    expect(READY_LOG('name')).toBe(`name: connected successfully to the server`);
  });
});

describe('ERROR_LOG', () => {
  test('should return a string', () => {
    expect(ERROR_LOG('name', 'message')).toBe(`name: message`);
  });
});



================================================
FILE: packages/redis/lib/messages/index.ts
================================================
import { Namespace } from '@/interfaces';
import { parseNamespace } from '@/utils';

export const generateReadyMessage = (namespace: Namespace) =>
  `${parseNamespace(namespace)}: the connection was successfully established`;

export const generateErrorMessage = (namespace: Namespace, message: string) =>
  `${parseNamespace(namespace)}: ${message}`;



================================================
FILE: packages/redis/lib/redis/default-options.spec.ts
================================================
import { defaultRedisModuleOptions } from './default-options';

describe('defaultRedisModuleOptions', () => {
  test('should validate the defaultRedisModuleOptions', () => {
    expect(defaultRedisModuleOptions.closeClient).toBe(true);
    expect(defaultRedisModuleOptions.readyLog).toBe(false);
    expect(defaultRedisModuleOptions.config).toBeUndefined();
    expect(defaultRedisModuleOptions.commonOptions).toBeUndefined();
  });
});



================================================
FILE: packages/redis/lib/redis/default-options.ts
================================================
import { RedisModuleOptions } from './interfaces';

export const defaultRedisModuleOptions: RedisModuleOptions = {
  closeClient: true,
  commonOptions: undefined,
  readyLog: true,
  errorLog: true,
  config: {}
};



================================================
FILE: packages/redis/lib/redis/redis-logger.spec.ts
================================================
import { Logger } from '@nestjs/common';
import { logger } from './redis-logger';

jest.mock('@nestjs/common', () => ({
  Logger: jest.fn()
}));

describe('logger', () => {
  test('should be defined', () => {
    expect(logger).toBeInstanceOf(Logger);
    expect(Logger).toHaveBeenCalledTimes(1);
  });
});



================================================
FILE: packages/redis/lib/redis/redis-logger.ts
================================================
import { Logger } from '@nestjs/common';

export const logger = new Logger('RedisModule', { timestamp: true });



================================================
FILE: packages/redis/lib/redis/redis.constants.spec.ts
================================================
import * as constants from './redis.constants';

test('each of constants should be defined', () => {
  Object.values(constants).forEach(value => expect(value).not.toBeNil());
});



================================================
FILE: packages/redis/lib/redis/redis.constants.ts
================================================
export const REDIS_OPTIONS = Symbol();

export const REDIS_MERGED_OPTIONS = Symbol();

export const REDIS_CLIENTS = Symbol();

export const NAMESPACE_KEY = Symbol();

/**
 * The default redis namespace.
 */
export const DEFAULT_REDIS = 'default';



================================================
FILE: packages/redis/lib/redis/redis.module.spec.ts
================================================
import { ModuleRef } from '@nestjs/core';
import { RedisModule } from './redis.module';
import { RedisModuleAsyncOptions } from './interfaces';
import { destroy } from './common';
import { logger } from './redis-logger';
import { REDIS_CLIENTS, REDIS_MERGED_OPTIONS } from './redis.constants';

jest.mock('./common');
jest.mock('./redis-logger', () => ({
  logger: {
    error: jest.fn()
  }
}));

describe('forRoot', () => {
  test('should work correctly', () => {
    const module = RedisModule.forRoot();
    expect(module.global).toBe(true);
    expect(module.module).toBe(RedisModule);
    expect(module.providers?.length).toBeGreaterThanOrEqual(4);
    expect(module.exports?.length).toBeGreaterThanOrEqual(1);
  });
});

describe('forRootAsync', () => {
  test('should work correctly', () => {
    const options: RedisModuleAsyncOptions = {
      imports: [],
      useFactory: () => ({}),
      inject: [],
      extraProviders: [{ provide: '', useValue: '' }]
    };
    const module = RedisModule.forRootAsync(options);
    expect(module.global).toBe(true);
    expect(module.module).toBe(RedisModule);
    expect(module.imports).toBeArray();
    expect(module.providers?.length).toBeGreaterThanOrEqual(5);
    expect(module.exports?.length).toBeGreaterThanOrEqual(1);
  });

  test('without extraProviders', () => {
    const options: RedisModuleAsyncOptions = {
      useFactory: () => ({})
    };
    const module = RedisModule.forRootAsync(options);
    expect(module.providers?.length).toBeGreaterThanOrEqual(4);
  });

  test('should throw an error', () => {
    expect(() => RedisModule.forRootAsync({})).toThrow();
  });
});

describe('onApplicationShutdown', () => {
  const mockDestroy = destroy as jest.MockedFunction<typeof destroy>;
  const mockError = jest.spyOn(logger, 'error');

  beforeEach(() => {
    mockDestroy.mockClear();
    mockError.mockClear();
  });

  test('should work correctly', async () => {
    mockDestroy.mockResolvedValue([
      [
        { status: 'fulfilled', value: '' },
        { status: 'rejected', reason: new Error('') }
      ]
    ]);

    const module = new RedisModule({
      get: (token: unknown) => {
        if (token === REDIS_MERGED_OPTIONS) return { closeClient: true };
        if (token === REDIS_CLIENTS) return new Map();
      }
    } as ModuleRef);
    await module.onApplicationShutdown();
    expect(mockDestroy).toHaveBeenCalledTimes(1);
    expect(mockError).toHaveBeenCalledTimes(1);
  });
});



================================================
FILE: packages/redis/lib/redis/redis.module.ts
================================================
import { Module, DynamicModule, Provider, OnApplicationShutdown } from '@nestjs/common';
import { ModuleRef } from '@nestjs/core';
import { RedisModuleOptions, RedisModuleAsyncOptions, RedisClients } from './interfaces';
import { RedisService } from './redis.service';
import {
  createOptionsProvider,
  createAsyncProviders,
  redisClientsProvider,
  mergedOptionsProvider
} from './redis.providers';
import { REDIS_CLIENTS, REDIS_MERGED_OPTIONS } from './redis.constants';
import { isError } from '@/utils';
import { logger } from './redis-logger';
import { MissingConfigurationsError } from '@/errors';
import { generateErrorMessage } from '@/messages';
import { removeListeners } from './common';

@Module({})
export class RedisModule implements OnApplicationShutdown {
  constructor(private moduleRef: ModuleRef) {}

  /**
   * Registers the module synchronously.
   *
   * @param options - The module options
   * @param isGlobal - Whether to register in the global scope
   * @returns A DynamicModule
   */
  static forRoot(options: RedisModuleOptions = {}, isGlobal = true): DynamicModule {
    const providers: Provider[] = [
      createOptionsProvider(options),
      redisClientsProvider,
      mergedOptionsProvider,
      RedisService
    ];

    return {
      global: isGlobal,
      module: RedisModule,
      providers,
      exports: [RedisService]
    };
  }

  /**
   * Registers the module asynchronously.
   *
   * @param options - The async module options
   * @param isGlobal - Whether to register in the global scope
   * @returns A DynamicModule
   */
  static forRootAsync(options: RedisModuleAsyncOptions, isGlobal = true): DynamicModule {
    if (!options.useFactory && !options.useClass && !options.useExisting) {
      throw new MissingConfigurationsError();
    }

    const providers: Provider[] = [
      ...createAsyncProviders(options),
      redisClientsProvider,
      mergedOptionsProvider,
      RedisService,
      ...(options.extraProviders ?? [])
    ];

    return {
      global: isGlobal,
      module: RedisModule,
      imports: options.imports,
      providers,
      exports: [RedisService]
    };
  }

  async onApplicationShutdown() {
    const { closeClient } = this.moduleRef.get<RedisModuleOptions>(REDIS_MERGED_OPTIONS, { strict: false });
    if (!closeClient) return;
    const clients = this.moduleRef.get<RedisClients>(REDIS_CLIENTS, { strict: false });
    for (const [namespace, client] of clients) {
      try {
        if (client.status === 'end') continue;
        await client.quit();
      } catch (e) {
        if (isError(e)) logger.error(generateErrorMessage(namespace, e.message), e.stack);
      } finally {
        removeListeners(client);
      }
    }
  }
}



================================================
FILE: packages/redis/lib/redis/redis.providers.spec.ts
================================================
import { Test, TestingModule } from '@nestjs/testing';
import Redis from 'ioredis';
import {
  createOptionsProvider,
  createAsyncProviders,
  createAsyncOptionsProvider,
  redisClientsProvider,
  createRedisClientProviders,
  createAsyncOptions,
  mergedOptionsProvider
} from './redis.providers';
import { RedisOptionsFactory, RedisModuleAsyncOptions, RedisClients, RedisModuleOptions } from './interfaces';
import { REDIS_OPTIONS, REDIS_CLIENTS, REDIS_MERGED_OPTIONS } from './redis.constants';
import { namespaces } from './common';
import { RedisManager } from './redis-manager';
import { defaultRedisModuleOptions } from './default-options';

jest.mock('ioredis', () => jest.fn(() => ({})));

describe('createOptionsProvider', () => {
  test('should work correctly', () => {
    expect(createOptionsProvider({})).toEqual({
      provide: REDIS_OPTIONS,
      useValue: {}
    });
  });
});

describe('createAsyncProviders', () => {
  class RedisConfigService implements RedisOptionsFactory {
    createRedisOptions(): RedisModuleOptions {
      return {};
    }
  }

  test('with useFactory', () => {
    const result = createAsyncProviders({ useFactory: () => ({}), inject: [] });
    expect(result).toHaveLength(1);
    expect(result).toPartiallyContain({ provide: REDIS_OPTIONS, inject: [] });
    expect(result[0]).toHaveProperty('useFactory');
  });

  test('with useClass', () => {
    const result = createAsyncProviders({ useClass: RedisConfigService });
    expect(result).toHaveLength(2);
    expect(result).toIncludeAllPartialMembers([
      { provide: RedisConfigService, useClass: RedisConfigService },
      { provide: REDIS_OPTIONS, inject: [RedisConfigService] }
    ]);
    expect(result[1]).toHaveProperty('useFactory');
  });

  test('with useExisting', () => {
    const result = createAsyncProviders({ useExisting: RedisConfigService });
    expect(result).toHaveLength(1);
    expect(result).toIncludeAllPartialMembers([{ provide: REDIS_OPTIONS, inject: [RedisConfigService] }]);
    expect(result[0]).toHaveProperty('useFactory');
  });

  test('without options', () => {
    const result = createAsyncProviders({});
    expect(result).toHaveLength(0);
  });
});

describe('createAsyncOptions', () => {
  test('should work correctly', async () => {
    const redisConfigService: RedisOptionsFactory = {
      createRedisOptions(): RedisModuleOptions {
        return { closeClient: true };
      }
    };
    await expect(createAsyncOptions(redisConfigService)).resolves.toEqual({ closeClient: true });
  });
});

describe('createAsyncOptionsProvider', () => {
  class RedisConfigService implements RedisOptionsFactory {
    createRedisOptions(): RedisModuleOptions {
      return {};
    }
  }

  test('with useFactory', () => {
    const options: RedisModuleAsyncOptions = { useFactory: () => ({}), inject: ['token'] };
    expect(createAsyncOptionsProvider(options)).toEqual({ provide: REDIS_OPTIONS, ...options });
  });

  test('with useClass', () => {
    const options: RedisModuleAsyncOptions = { useClass: RedisConfigService };
    expect(createAsyncOptionsProvider(options)).toHaveProperty('provide', REDIS_OPTIONS);
    expect(createAsyncOptionsProvider(options)).toHaveProperty('useFactory');
    expect(createAsyncOptionsProvider(options)).toHaveProperty('inject', [RedisConfigService]);
  });

  test('with useExisting', () => {
    const options: RedisModuleAsyncOptions = { useExisting: RedisConfigService };
    expect(createAsyncOptionsProvider(options)).toHaveProperty('provide', REDIS_OPTIONS);
    expect(createAsyncOptionsProvider(options)).toHaveProperty('useFactory');
    expect(createAsyncOptionsProvider(options)).toHaveProperty('inject', [RedisConfigService]);
  });

  test('without options', () => {
    expect(createAsyncOptionsProvider({})).toEqual({ provide: REDIS_OPTIONS, useValue: {} });
  });
});

describe('createRedisClientProviders', () => {
  let clients: RedisClients;
  let client1: Redis;
  let client2: Redis;

  beforeEach(async () => {
    clients = new Map();
    clients.set('client1', new Redis());
    clients.set('client2', new Redis());
    namespaces.set('client1', 'client1');
    namespaces.set('client2', 'client2');

    const module: TestingModule = await Test.createTestingModule({
      providers: [{ provide: REDIS_CLIENTS, useValue: clients }, RedisManager, ...createRedisClientProviders()]
    }).compile();

    client1 = module.get<Redis>('client1');
    client2 = module.get<Redis>('client2');
  });

  afterEach(() => {
    namespaces.clear();
  });

  test('should work correctly', () => {
    expect(client1).toBeDefined();
    expect(client2).toBeDefined();
  });
});

describe('redisClientsProvider', () => {
  test('should be a dynamic module', () => {
    expect(redisClientsProvider).toHaveProperty('provide', REDIS_CLIENTS);
    expect(redisClientsProvider).toHaveProperty('useFactory');
    expect(redisClientsProvider).toHaveProperty('inject', [REDIS_MERGED_OPTIONS]);
  });

  test('with multiple clients', async () => {
    const options: RedisModuleOptions = { config: [{}, { namespace: 'client1' }] };
    const clients = await redisClientsProvider.useFactory(options);
    expect(clients.size).toBe(2);
  });

  describe('with single client', () => {
    test('with namespace', async () => {
      const options: RedisModuleOptions = { config: { namespace: 'client1' } };
      const clients = await redisClientsProvider.useFactory(options);
      expect(clients.size).toBe(1);
    });

    test('without namespace', async () => {
      const options: RedisModuleOptions = { config: {} };
      const clients = await redisClientsProvider.useFactory(options);
      expect(clients.size).toBe(1);
    });
  });
});

describe('mergedOptionsProvider', () => {
  test('should be a dynamic module', () => {
    expect(mergedOptionsProvider).toHaveProperty('provide', REDIS_MERGED_OPTIONS);
    expect(mergedOptionsProvider).toHaveProperty('useFactory');
    expect(mergedOptionsProvider).toHaveProperty('inject', [REDIS_OPTIONS]);
  });

  test('should work correctly', async () => {
    const options: RedisModuleOptions = { closeClient: false };
    const mergedOptions = await mergedOptionsProvider.useFactory(options);
    expect(mergedOptions).toEqual({ ...defaultRedisModuleOptions, ...options });
  });
});



================================================
FILE: packages/redis/lib/redis/redis.providers.ts
================================================
import { Provider, FactoryProvider, ValueProvider } from '@nestjs/common';
import { RedisModuleOptions, RedisModuleAsyncOptions, RedisOptionsFactory, RedisClients } from './interfaces';
import { REDIS_OPTIONS, REDIS_CLIENTS, DEFAULT_REDIS, REDIS_MERGED_OPTIONS } from './redis.constants';
import { create } from './common';
import { defaultRedisModuleOptions } from './default-options';

export const createOptionsProvider = (options: RedisModuleOptions): ValueProvider<RedisModuleOptions> => ({
  provide: REDIS_OPTIONS,
  useValue: options
});

export const createAsyncProviders = (options: RedisModuleAsyncOptions): Provider[] => {
  if (options.useClass) {
    return [
      {
        provide: options.useClass,
        useClass: options.useClass
      },
      createAsyncOptionsProvider(options)
    ];
  }

  if (options.useExisting || options.useFactory) return [createAsyncOptionsProvider(options)];

  return [];
};

export const createAsyncOptions = async (optionsFactory: RedisOptionsFactory): Promise<RedisModuleOptions> => {
  return await optionsFactory.createRedisOptions();
};

export const createAsyncOptionsProvider = (options: RedisModuleAsyncOptions): Provider => {
  if (options.useFactory) {
    return {
      provide: REDIS_OPTIONS,
      useFactory: options.useFactory,
      inject: options.inject
    };
  }

  if (options.useClass) {
    return {
      provide: REDIS_OPTIONS,
      useFactory: createAsyncOptions,
      inject: [options.useClass]
    };
  }

  if (options.useExisting) {
    return {
      provide: REDIS_OPTIONS,
      useFactory: createAsyncOptions,
      inject: [options.useExisting]
    };
  }

  return {
    provide: REDIS_OPTIONS,
    useValue: {}
  };
};

export const redisClientsProvider: FactoryProvider<RedisClients> = {
  provide: REDIS_CLIENTS,
  useFactory: (options: RedisModuleOptions) => {
    const clients: RedisClients = new Map();
    if (Array.isArray(options.config)) {
      for (const item of options.config) {
        clients.set(
          item.namespace ?? DEFAULT_REDIS,
          create(
            { ...options.commonOptions, ...item },
            { readyLog: options.readyLog, errorLog: options.errorLog, beforeCreate: options.beforeCreate }
          )
        );
      }
    } else if (options.config) {
      clients.set(
        options.config.namespace ?? DEFAULT_REDIS,
        create(
          { ...options.commonOptions, ...options.config },
          {
            readyLog: options.readyLog,
            errorLog: options.errorLog,
            beforeCreate: options.beforeCreate
          }
        )
      );
    }
    return clients;
  },
  inject: [REDIS_MERGED_OPTIONS]
};

export const mergedOptionsProvider: FactoryProvider<RedisModuleOptions> = {
  provide: REDIS_MERGED_OPTIONS,
  useFactory: (options: RedisModuleOptions) => ({ ...defaultRedisModuleOptions, ...options }),
  inject: [REDIS_OPTIONS]
};



================================================
FILE: packages/redis/lib/redis/redis.service.spec.ts
================================================
import { Test, TestingModule } from '@nestjs/testing';
import Redis from 'ioredis';
import { RedisManager } from './redis-manager';
import { RedisClients } from './interfaces';
import { REDIS_CLIENTS, DEFAULT_REDIS_NAMESPACE } from './redis.constants';

jest.mock('ioredis', () => jest.fn(() => ({})));

describe('RedisManager', () => {
  let clients: RedisClients;
  let manager: RedisManager;

  beforeEach(async () => {
    clients = new Map();
    clients.set(DEFAULT_REDIS_NAMESPACE, new Redis());
    clients.set('client1', new Redis());

    const module: TestingModule = await Test.createTestingModule({
      providers: [{ provide: REDIS_CLIENTS, useValue: clients }, RedisManager]
    }).compile();

    manager = module.get<RedisManager>(RedisManager);
  });

  test('should have 2 members', () => {
    expect(manager.clients.size).toBe(2);
  });

  test('should get a client with namespace', () => {
    const client = manager.getClient('client1');
    expect(client).toBeDefined();
  });

  test('should get default client with namespace', () => {
    const client = manager.getClient(DEFAULT_REDIS_NAMESPACE);
    expect(client).toBeDefined();
  });

  test('should get default client without namespace', () => {
    const client = manager.getClient();
    expect(client).toBeDefined();
  });

  test('should throw an error when getting a client with an unknown namespace', () => {
    expect(() => manager.getClient('')).toThrow();
  });
});



================================================
FILE: packages/redis/lib/redis/redis.service.ts
================================================
import { Injectable, Inject } from '@nestjs/common';
import type { Redis } from 'ioredis';
import { REDIS_CLIENTS, DEFAULT_REDIS } from './redis.constants';
import type { RedisClients } from './interfaces';
import { parseNamespace } from '@/utils';
import type { Namespace } from '@/interfaces';
import { ConnectionNotFoundError } from '@/errors';

/**
 * The redis connections manager.
 */
@Injectable()
export class RedisService {
  constructor(@Inject(REDIS_CLIENTS) private readonly clients: RedisClients) {}

  /**
   * Retrieves a redis connection by namespace.
   * However, if the retrieving does not find a connection, it returns ClientNotFoundError: No Connection found error.
   *
   * @param namespace - The namespace
   * @returns A redis connection
   */
  getOrThrow(namespace: Namespace = DEFAULT_REDIS): Redis {
    const client = this.clients.get(namespace);
    if (!client) throw new ConnectionNotFoundError(parseNamespace(namespace));
    return client;
  }

  /**
   * Retrieves a redis connection by namespace, if the retrieving does not find a connection, it returns `null`;
   *
   * @param namespace - The namespace
   * @returns A redis connection or `null`
   */
  getOrNil(namespace: Namespace = DEFAULT_REDIS): Redis | null {
    const client = this.clients.get(namespace);
    if (!client) return null;
    return client;
  }
}



================================================
FILE: packages/redis/lib/redis/common/index.spec.ts
================================================
import * as allExports from '.';

test('there should be 6 exports', () => {
  expect(Object.keys(allExports)).toHaveLength(6);
});

test('each of exports should be defined', () => {
  Object.values(allExports).forEach(value => expect(value).not.toBeNil());
});



================================================
FILE: packages/redis/lib/redis/common/index.ts
================================================
export * from './redis.utils';



================================================
FILE: packages/redis/lib/redis/common/redis.utils.spec.ts
================================================
import Redis from 'ioredis';
import { createClient, destroy, addListeners } from './redis.utils';
import { RedisClients, RedisClientOptions } from '../interfaces';
import { NAMESPACE_KEY } from '../redis.constants';

jest.mock('../redis-logger', () => ({
  logger: {
    log: jest.fn(),
    error: jest.fn()
  }
}));

const mockOn = jest.fn();
jest.mock('ioredis', () =>
  jest.fn(() => ({
    on: mockOn,
    quit: jest.fn(),
    disconnect: jest.fn()
  }))
);

const MockedRedis = Redis as jest.MockedClass<typeof Redis>;
beforeEach(() => {
  MockedRedis.mockClear();
  mockOn.mockReset();
});

describe('createClient', () => {
  describe('with URL', () => {
    const url = 'redis://:authpassword@127.0.0.1:6380/4';

    test('should create a client with a URL', () => {
      const client = createClient({ url }, {});
      expect(client).toBeDefined();
      expect(MockedRedis).toHaveBeenCalledTimes(1);
      expect(MockedRedis).toHaveBeenCalledWith(url, {});
      expect(MockedRedis.mock.instances).toHaveLength(1);
    });

    test('should create a client with a URL and options', () => {
      const client = createClient({ url, lazyConnect: true }, {});
      expect(client).toBeDefined();
      expect(MockedRedis).toHaveBeenCalledTimes(1);
      expect(MockedRedis).toHaveBeenCalledWith(url, { lazyConnect: true });
      expect(MockedRedis.mock.instances).toHaveLength(1);
    });
  });

  describe('with path', () => {
    test('should create a client with a path', () => {
      const path = '/run/redis.sock';
      const client = createClient({ path, lazyConnect: true }, {});
      expect(client).toBeDefined();
      expect(MockedRedis).toHaveBeenCalledTimes(1);
      expect(MockedRedis).toHaveBeenCalledWith(path, { lazyConnect: true });
      expect(MockedRedis.mock.instances).toHaveLength(1);
    });
  });

  describe('with options', () => {
    test('should create a client with options', () => {
      const options: RedisClientOptions = { host: '127.0.0.1', port: 6380 };
      const client = createClient(options, {});
      expect(client).toBeDefined();
      expect(MockedRedis).toHaveBeenCalledTimes(1);
      expect(MockedRedis).toHaveBeenCalledWith(options);
      expect(MockedRedis.mock.instances).toHaveLength(1);
    });

    test('should call onClientCreated', () => {
      const mockOnClientCreated = jest.fn();

      const client = createClient({ onClientCreated: mockOnClientCreated }, {});
      expect(client).toBeDefined();
      expect(MockedRedis).toHaveBeenCalledTimes(1);
      expect(MockedRedis).toHaveBeenCalledWith({});
      expect(MockedRedis.mock.instances).toHaveLength(1);
      expect(mockOnClientCreated).toHaveBeenCalledTimes(1);
      expect(mockOnClientCreated).toHaveBeenCalledWith(client);
    });
  });
});

describe('destroy', () => {
  let client1: Redis;
  let client2: Redis;
  let clients: RedisClients;

  beforeEach(() => {
    client1 = new Redis();
    client2 = new Redis();
    clients = new Map();
    clients.set('client1', client1);
    clients.set('client2', client2);
  });

  test('when the status is ready', async () => {
    Reflect.set(client1, 'status', 'ready');
    Reflect.set(client2, 'status', 'ready');

    const mockClient1Quit = jest.spyOn(client1, 'quit').mockRejectedValue(new Error());
    const mockClient2Quit = jest.spyOn(client2, 'quit').mockRejectedValue('');

    const results = await destroy(clients);
    expect(mockClient1Quit).toHaveBeenCalled();
    expect(mockClient2Quit).toHaveBeenCalled();
    expect(results).toHaveLength(2);
    expect(results[0][0]).toEqual({ status: 'fulfilled', value: 'client1' });
    expect(results[0][1]).toHaveProperty('status', 'rejected');
    expect(results[1][0]).toEqual({ status: 'fulfilled', value: 'client2' });
    expect(results[1][1]).toEqual({ status: 'rejected', reason: '' });
  });

  test('when the status is ready, end', async () => {
    Reflect.set(client1, 'status', 'ready');
    Reflect.set(client2, 'status', 'end');

    const mockClient1Quit = jest.spyOn(client1, 'quit').mockResolvedValue('OK');

    const results = await destroy(clients);
    expect(mockClient1Quit).toHaveBeenCalled();
    expect(results).toHaveLength(1);
  });

  test('when the status is wait', async () => {
    Reflect.set(client1, 'status', 'wait');
    Reflect.set(client2, 'status', 'wait');

    const mockClient1Disconnect = jest.spyOn(client1, 'disconnect');
    const mockClient2Disconnect = jest.spyOn(client2, 'disconnect');

    const results = await destroy(clients);
    expect(mockClient1Disconnect).toHaveBeenCalled();
    expect(mockClient2Disconnect).toHaveBeenCalled();
    expect(results).toHaveLength(0);
  });
});

describe('addListeners', () => {
  let client: Redis;

  beforeEach(() => {
    client = new Redis();
  });

  test('should set namespace correctly', () => {
    const namespace = Symbol();
    addListeners({ namespace, instance: client, readyLog: false, errorLog: false });
    expect(Reflect.get(client, NAMESPACE_KEY)).toBe(namespace);
  });

  test('should add ready listener', () => {
    mockOn.mockImplementation((_, fn: (...args: unknown[]) => void) => {
      fn.call(client);
    });
    addListeners({ namespace: '', instance: client, readyLog: true, errorLog: false });
    expect(mockOn).toHaveBeenCalledTimes(1);
  });

  test('should add error listener', () => {
    mockOn.mockImplementation((_, fn: (...args: unknown[]) => void) => {
      fn.call(client, new Error());
    });
    addListeners({ namespace: '', instance: client, readyLog: false, errorLog: true });
    expect(mockOn).toHaveBeenCalledTimes(1);
  });
});



================================================
FILE: packages/redis/lib/redis/common/redis.utils.ts
================================================
import { Redis } from 'ioredis';
import { RedisClientOptions, RedisModuleOptions } from '../interfaces';
import { Namespace } from '@/interfaces';
import { generateErrorMessage, generateReadyMessage } from '@/messages';
import { logger } from '../redis-logger';
import { get, isDirectInstanceOf } from '@/utils';
import { DEFAULT_REDIS, NAMESPACE_KEY } from '../redis.constants';

export function readyCallback(this: Redis) {
  logger.log(generateReadyMessage(get<Namespace>(this, NAMESPACE_KEY)));
}

export function errorCallback(this: Redis, error: Error) {
  logger.error(generateErrorMessage(get<Namespace>(this, NAMESPACE_KEY), error.message), error.stack);
}

export function removeListeners(instance: Redis) {
  instance.removeListener('ready', readyCallback);
  instance.removeListener('error', errorCallback);
}

export const create = (
  { namespace, url, path, onClientCreated, created, provide, ...redisOptions }: RedisClientOptions,
  { readyLog, errorLog, beforeCreate }: RedisModuleOptions
): Redis => {
  let client: Redis;
  if (beforeCreate) beforeCreate();
  if (provide) client = provide();
  else if (url) client = new Redis(url, redisOptions);
  else if (path) client = new Redis(path, redisOptions);
  else client = new Redis(redisOptions);
  if (!isDirectInstanceOf(client, Redis)) throw new TypeError('A valid instance of ioredis is required.');
  Reflect.defineProperty(client, NAMESPACE_KEY, { value: namespace ?? DEFAULT_REDIS, writable: false });
  if (readyLog) client.on('ready', readyCallback);
  if (errorLog) client.on('error', errorCallback);
  if (created) created(client);
  if (onClientCreated) onClientCreated(client);
  return client;
};



================================================
FILE: packages/redis/lib/redis/interfaces/index.ts
================================================
export * from './redis-module-options.interface';
export * from './redis.interface';



================================================
FILE: packages/redis/lib/redis/interfaces/redis-module-options.interface.ts
================================================
import { Type, ModuleMetadata, Provider, InjectionToken, OptionalFactoryDependency } from '@nestjs/common';
import type { Redis, RedisOptions } from 'ioredis';
import { Namespace } from '@/interfaces';

export interface RedisClientOptions extends RedisOptions {
  /**
   * Name of the connection. If the name is not given then it will be set to "default".
   *
   * Please note that you shouldn't have multiple connections without a namespace, or with the same namespace, otherwise they will get overridden.
   *
   * For the default name you can also explicitly import `DEFAULT_REDIS`.
   *
   * @defaultValue `"default"`
   */
  namespace?: Namespace;
  /**
   * Connection url to be used to specify connection options as a redis:// URL or rediss:// URL when using TLS.
   *
   * - redis - https://www.iana.org/assignments/uri-schemes/prov/redis
   * - rediss - https://www.iana.org/assignments/uri-schemes/prov/rediss
   *
   * @example
   * ```ts
   * // Connect to 127.0.0.1:6380, db 4, using password "authpassword":
   * url: 'redis://:authpassword@127.0.0.1:6380/4'
   * ```
   *
   * @example
   * ```ts
   * // Username can also be passed via URI.
   * url: 'redis://username:authpassword@127.0.0.1:6380/4'
   * ```
   */
  url?: string;
  /**
   * Used to specify the path to Unix domain sockets.
   */
  path?: string;
  /**
   * Manually providing a redis instance.
   *
   * @example
   * ```ts
   * provide() {
   *   // 192.168.1.1:6379
   *   return new Redis(6379, '192.168.1.1');
   * }
   * ```
   */
  provide?: () => Redis;
  /**
   * Called after the connection has been created.
   */
  created?: (client: Redis) => void;
  /**
   * Function to be executed after the connection is created.
   *
   * @deprecated Use the new `created` instead.
   */
  onClientCreated?: (client: Redis) => void;
}

export interface RedisModuleOptions {
  /**
   * If set to `true`, all connections will be closed automatically on nestjs application shutdown.
   *
   * @defaultValue `true`
   */
  closeClient?: boolean;
  /**
   * Common options to be passed to each `config`.
   */
  commonOptions?: RedisOptions;
  /**
   * If set to `true`, then ready logging will be displayed when the connection is ready.
   *
   * @defaultValue `true`
   */
  readyLog?: boolean;
  /**
   * If set to `true`, then errors that occurred while connecting will be displayed by the built-in logger.
   *
   * @defaultValue `true`
   */
  errorLog?: boolean;
  /**
   * Used to specify single or multiple connections.
   */
  config?: RedisClientOptions | RedisClientOptions[];
  /**
   * Called before the connection is created.
   */
  beforeCreate?: () => void;
}

export interface RedisModuleAsyncOptions extends Pick<ModuleMetadata, 'imports'> {
  useFactory?: (...args: any[]) => RedisModuleOptions | Promise<RedisModuleOptions>;
  useClass?: Type<RedisOptionsFactory>;
  useExisting?: Type<RedisOptionsFactory>;
  inject?: (InjectionToken | OptionalFactoryDependency)[];
  extraProviders?: Provider[];
}

export interface RedisOptionsFactory {
  createRedisOptions: () => RedisModuleOptions | Promise<RedisModuleOptions>;
}



================================================
FILE: packages/redis/lib/redis/interfaces/redis.interface.ts
================================================
import type { Redis } from 'ioredis';
import { Namespace } from '@/interfaces';

export type RedisClients = Map<Namespace, Redis>;



================================================
FILE: packages/redis/lib/utils/index.spec.ts
================================================
import * as allExports from '.';

test('there should be 6 exports', () => {
  expect(Object.keys(allExports)).toHaveLength(6);
});

test('each of exports should be defined', () => {
  Object.values(allExports).forEach(value => expect(value).not.toBeNil());
});



================================================
FILE: packages/redis/lib/utils/index.ts
================================================
export * from './is';
export * from './parsers';
export * from './reflect';



================================================
FILE: packages/redis/lib/utils/is.spec.ts
================================================
import { isString, isError } from './is';

describe('isString', () => {
  test('should work correctly', () => {
    expect(isString('')).toBe(true);
    expect(isString('a')).toBe(true);
    expect(isString(1)).toBe(false);
    expect(isString(true)).toBe(false);
    expect(isString(undefined)).toBe(false);
    expect(isString(null)).toBe(false);
    expect(isString(Symbol())).toBe(false);
  });
});

describe('isError', () => {
  test('should work correctly', () => {
    class CustomError extends Error {}
    class User {}

    expect(isError(new Error())).toBe(true);
    expect(isError(new CustomError())).toBe(true);
    expect(isError(new User())).toBe(false);
    expect(isError('')).toBe(false);
    expect(isError(0)).toBe(false);
    expect(isError(true)).toBe(false);
    expect(isError(undefined)).toBe(false);
    expect(isError(null)).toBe(false);
    expect(isError(Symbol())).toBe(false);
  });
});



================================================
FILE: packages/redis/lib/utils/is.ts
================================================
import { Class } from '@/interfaces';

/**
 * Returns `true` if the value is of type `string`.
 *
 * @param value - Any value
 * @returns A boolean value for Type Guard
 */
export const isString = (value: unknown): value is string => typeof value === 'string';

/**
 * Returns `true` if the value is an instance of `Error`.
 *
 * @param value - Any value
 * @returns A boolean value for Type Guard
 */
export const isError = (value: unknown): value is Error => {
  const typeName = Object.prototype.toString.call(value).slice(8, -1);
  return typeName === 'Error';
};

/**
 * Returns `true` if value is a direct instance of class.
 *
 * @param instance - Any value
 * @param class_ - A class or function that can be instantiated
 * @returns A boolean value for Type Guard
 */
export const isDirectInstanceOf = <T>(instance: unknown, class_: Class<T>): instance is T => {
  if (instance === undefined || instance === null) return false;
  return Object.getPrototypeOf(instance) === class_.prototype;
};



================================================
FILE: packages/redis/lib/utils/parsers.spec.ts
================================================
import { parseNamespace } from './parsers';

describe('parseNamespace', () => {
  test('should work correctly', () => {
    const namespace1 = 'namespace';
    const namespace2 = Symbol('namespace');
    expect(parseNamespace(namespace1)).toBe(namespace1);
    expect(parseNamespace(namespace2)).toBe(namespace2.toString());
  });
});



================================================
FILE: packages/redis/lib/utils/parsers.ts
================================================
import { isString } from './is';
import { Namespace } from '@/interfaces';

/**
 * Parses namespace to string.
 *
 * @param namespace - The namespace
 * @returns A string value
 */
export const parseNamespace = (namespace: Namespace): string =>
  isString(namespace) ? namespace : namespace.toString();



================================================
FILE: packages/redis/lib/utils/reflect.spec.ts
================================================



================================================
FILE: packages/redis/lib/utils/reflect.ts
================================================
/**
 * This is equivalent to `Reflect.get()`.
 *
 * @param target - The target object
 * @param key - The property name
 * @returns Unknown value
 */
export const get = <T>(target: object, key: PropertyKey) => Reflect.get(target, key) as T;


