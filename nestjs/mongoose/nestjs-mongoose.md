Directory structure:
└── lib/
    ├── index.ts
    ├── mongoose-core.module.ts
    ├── mongoose.constants.ts
    ├── mongoose.module.ts
    ├── mongoose.providers.ts
    ├── common/
    │   ├── index.ts
    │   ├── mongoose.decorators.ts
    │   └── mongoose.utils.ts
    ├── decorators/
    │   ├── index.ts
    │   ├── prop.decorator.ts
    │   ├── schema.decorator.ts
    │   └── virtual.decorator.ts
    ├── errors/
    │   ├── cannot-determine-type.error.ts
    │   └── index.ts
    ├── factories/
    │   ├── definitions.factory.ts
    │   ├── index.ts
    │   ├── schema.factory.ts
    │   └── virtuals.factory.ts
    ├── interfaces/
    │   ├── async-model-factory.interface.ts
    │   ├── index.ts
    │   ├── model-definition.interface.ts
    │   └── mongoose-options.interface.ts
    ├── metadata/
    │   ├── property-metadata.interface.ts
    │   ├── schema-metadata.interface.ts
    │   └── virtual-metadata.interface.ts
    ├── pipes/
    │   ├── index.ts
    │   ├── is-object-id.pipe.ts
    │   └── parse-object-id.pipe.ts
    ├── storages/
    │   └── type-metadata.storage.ts
    └── utils/
        ├── index.ts
        ├── is-target-equal-util.ts
        └── raw.util.ts

================================================
FILE: lib/index.ts
================================================
export * from './common';
export * from './decorators';
export * from './errors';
export * from './factories';
export * from './interfaces';
export * from './mongoose.module';
export * from './pipes';
export * from './utils';



================================================
FILE: lib/mongoose-core.module.ts
================================================
import {
  DynamicModule,
  Global,
  Inject,
  Module,
  OnApplicationShutdown,
  Provider,
  Type,
} from '@nestjs/common';
import { ModuleRef } from '@nestjs/core';
import * as mongoose from 'mongoose';
import { ConnectOptions, Connection } from 'mongoose';
import { defer, lastValueFrom } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { getConnectionToken, handleRetry } from './common/mongoose.utils';
import {
  MongooseModuleAsyncOptions,
  MongooseModuleFactoryOptions,
  MongooseModuleOptions,
  MongooseOptionsFactory,
} from './interfaces/mongoose-options.interface';
import {
  MONGOOSE_CONNECTION_NAME,
  MONGOOSE_MODULE_OPTIONS,
} from './mongoose.constants';

@Global()
@Module({})
export class MongooseCoreModule implements OnApplicationShutdown {
  constructor(
    @Inject(MONGOOSE_CONNECTION_NAME) private readonly connectionName: string,
    private readonly moduleRef: ModuleRef,
  ) {}

  static forRoot(
    uri: string,
    options: MongooseModuleOptions = {},
  ): DynamicModule {
    const {
      retryAttempts,
      retryDelay,
      connectionName,
      connectionFactory,
      connectionErrorFactory,
      lazyConnection,
      onConnectionCreate,
      verboseRetryLog,
      ...mongooseOptions
    } = options;

    const mongooseConnectionFactory =
      connectionFactory || ((connection) => connection);

    const mongooseConnectionError =
      connectionErrorFactory || ((error) => error);

    const mongooseConnectionName = getConnectionToken(connectionName);

    const mongooseConnectionNameProvider = {
      provide: MONGOOSE_CONNECTION_NAME,
      useValue: mongooseConnectionName,
    };

    const connectionProvider = {
      provide: mongooseConnectionName,
      useFactory: async (): Promise<any> =>
        await lastValueFrom(
          defer(async () =>
            mongooseConnectionFactory(
              await this.createMongooseConnection(uri, mongooseOptions, {
                lazyConnection,
                onConnectionCreate,
              }),
              mongooseConnectionName,
            ),
          ).pipe(
            handleRetry(retryAttempts, retryDelay, verboseRetryLog),
            catchError((error) => {
              throw mongooseConnectionError(error);
            }),
          ),
        ),
    };
    return {
      module: MongooseCoreModule,
      providers: [connectionProvider, mongooseConnectionNameProvider],
      exports: [connectionProvider],
    };
  }

  static forRootAsync(options: MongooseModuleAsyncOptions): DynamicModule {
    const mongooseConnectionName = getConnectionToken(options.connectionName);

    const mongooseConnectionNameProvider = {
      provide: MONGOOSE_CONNECTION_NAME,
      useValue: mongooseConnectionName,
    };

    const connectionProvider = {
      provide: mongooseConnectionName,
      useFactory: async (
        mongooseModuleOptions: MongooseModuleFactoryOptions,
      ): Promise<any> => {
        const {
          retryAttempts,
          retryDelay,
          uri,
          connectionFactory,
          connectionErrorFactory,
          lazyConnection,
          onConnectionCreate,
          verboseRetryLog,
          ...mongooseOptions
        } = mongooseModuleOptions;

        const mongooseConnectionFactory =
          connectionFactory || ((connection) => connection);

        const mongooseConnectionError =
          connectionErrorFactory || ((error) => error);

        return await lastValueFrom(
          defer(async () =>
            mongooseConnectionFactory(
              await this.createMongooseConnection(
                uri as string,
                mongooseOptions,
                { lazyConnection, onConnectionCreate },
              ),
              mongooseConnectionName,
            ),
          ).pipe(
            handleRetry(retryAttempts, retryDelay, verboseRetryLog),
            catchError((error) => {
              throw mongooseConnectionError(error);
            }),
          ),
        );
      },
      inject: [MONGOOSE_MODULE_OPTIONS],
    };
    const asyncProviders = this.createAsyncProviders(options);
    return {
      module: MongooseCoreModule,
      imports: options.imports,
      providers: [
        ...asyncProviders,
        connectionProvider,
        mongooseConnectionNameProvider,
      ],
      exports: [connectionProvider],
    };
  }

  private static createAsyncProviders(
    options: MongooseModuleAsyncOptions,
  ): Provider[] {
    if (options.useExisting || options.useFactory) {
      return [this.createAsyncOptionsProvider(options)];
    }
    const useClass = options.useClass as Type<MongooseOptionsFactory>;
    return [
      this.createAsyncOptionsProvider(options),
      {
        provide: useClass,
        useClass,
      },
    ];
  }

  private static createAsyncOptionsProvider(
    options: MongooseModuleAsyncOptions,
  ): Provider {
    if (options.useFactory) {
      return {
        provide: MONGOOSE_MODULE_OPTIONS,
        useFactory: options.useFactory,
        inject: options.inject || [],
      };
    }
    // `as Type<MongooseOptionsFactory>` is a workaround for microsoft/TypeScript#31603
    const inject = [
      (options.useClass || options.useExisting) as Type<MongooseOptionsFactory>,
    ];
    return {
      provide: MONGOOSE_MODULE_OPTIONS,
      useFactory: async (optionsFactory: MongooseOptionsFactory) =>
        await optionsFactory.createMongooseOptions(),
      inject,
    };
  }

  private static async createMongooseConnection(
    uri: string,
    mongooseOptions: ConnectOptions,
    factoryOptions: {
      lazyConnection?: boolean;
      onConnectionCreate?: MongooseModuleOptions['onConnectionCreate'];
    },
  ): Promise<Connection> {
    const connection = mongoose.createConnection(uri, mongooseOptions);

    if (factoryOptions?.lazyConnection) {
      return connection;
    }

    factoryOptions?.onConnectionCreate?.(connection);

    return connection.asPromise();
  }

  async onApplicationShutdown() {
    const connection = this.moduleRef.get<any>(this.connectionName);
    if (connection) {
      await connection.close();
    }
  }
}



================================================
FILE: lib/mongoose.constants.ts
================================================
export const DEFAULT_DB_CONNECTION = 'DatabaseConnection';
export const MONGOOSE_MODULE_OPTIONS = 'MongooseModuleOptions';
export const MONGOOSE_CONNECTION_NAME = 'MongooseConnectionName';

export const RAW_OBJECT_DEFINITION = 'RAW_OBJECT_DEFINITION';



================================================
FILE: lib/mongoose.module.ts
================================================
import { DynamicModule, flatten, Module } from '@nestjs/common';
import { AsyncModelFactory, ModelDefinition } from './interfaces';
import {
  MongooseModuleAsyncOptions,
  MongooseModuleOptions,
} from './interfaces/mongoose-options.interface';
import { MongooseCoreModule } from './mongoose-core.module';
import {
  createMongooseAsyncProviders,
  createMongooseProviders,
} from './mongoose.providers';

@Module({})
export class MongooseModule {
  static forRoot(
    uri: string,
    options: MongooseModuleOptions = {},
  ): DynamicModule {
    return {
      module: MongooseModule,
      imports: [MongooseCoreModule.forRoot(uri, options)],
    };
  }

  static forRootAsync(options: MongooseModuleAsyncOptions): DynamicModule {
    return {
      module: MongooseModule,
      imports: [MongooseCoreModule.forRootAsync(options)],
    };
  }

  static forFeature(
    models: ModelDefinition[] = [],
    connectionName?: string,
  ): DynamicModule {
    const providers = createMongooseProviders(connectionName, models);
    return {
      module: MongooseModule,
      providers: providers,
      exports: providers,
    };
  }

  static forFeatureAsync(
    factories: AsyncModelFactory[] = [],
    connectionName?: string,
  ): DynamicModule {
    const providers = createMongooseAsyncProviders(connectionName, factories);
    const imports = factories.map((factory) => factory.imports || []);
    const uniqImports = new Set(flatten(imports));

    return {
      module: MongooseModule,
      imports: [...uniqImports],
      providers: providers,
      exports: providers,
    };
  }
}



================================================
FILE: lib/mongoose.providers.ts
================================================
import { Provider } from '@nestjs/common';
import { Connection, Document, Model } from 'mongoose';
import { getConnectionToken, getModelToken } from './common/mongoose.utils';
import { AsyncModelFactory, ModelDefinition } from './interfaces';

export function createMongooseProviders(
  connectionName?: string,
  options: ModelDefinition[] = [],
): Provider[] {
  return options.reduce(
    (providers, option) => [
      ...providers,
      ...(option.discriminators || []).map((d) => ({
        provide: getModelToken(d.name, connectionName),
        useFactory: (model: Model<Document>) =>
          model.discriminator(d.name, d.schema, d.value),
        inject: [getModelToken(option.name, connectionName)],
      })),
      {
        provide: getModelToken(option.name, connectionName),
        useFactory: (connection: Connection) => {
          const model = connection.models[option.name]
            ? connection.models[option.name]
            : connection.model(option.name, option.schema, option.collection);
          return model;
        },
        inject: [getConnectionToken(connectionName)],
      },
    ],
    [] as Provider[],
  );
}

export function createMongooseAsyncProviders(
  connectionName?: string,
  modelFactories: AsyncModelFactory[] = [],
): Provider[] {
  return modelFactories.reduce((providers, option) => {
    return [
      ...providers,
      {
        provide: getModelToken(option.name, connectionName),
        useFactory: async (connection: Connection, ...args: unknown[]) => {
          const schema = await option.useFactory(...args);
          const model = connection.model(
            option.name,
            schema,
            option.collection,
          );
          return model;
        },
        inject: [getConnectionToken(connectionName), ...(option.inject || [])],
      },
      ...(option.discriminators || []).map((d) => ({
        provide: getModelToken(d.name, connectionName),
        useFactory: (model: Model<Document>) =>
          model.discriminator(d.name, d.schema, d.value),
        inject: [getModelToken(option.name, connectionName)],
      })),
    ];
  }, [] as Provider[]);
}



================================================
FILE: lib/common/index.ts
================================================
export * from './mongoose.decorators';
export { getConnectionToken, getModelToken } from './mongoose.utils';



================================================
FILE: lib/common/mongoose.decorators.ts
================================================
import { Inject } from '@nestjs/common';
import { getConnectionToken, getModelToken } from './mongoose.utils';

export const InjectModel = (model: string, connectionName?: string) =>
  Inject(getModelToken(model, connectionName));

export const InjectConnection = (name?: string) =>
  Inject(getConnectionToken(name));



================================================
FILE: lib/common/mongoose.utils.ts
================================================
import { Logger } from '@nestjs/common';
import { Observable } from 'rxjs';
import { delay, retryWhen, scan } from 'rxjs/operators';
import { DEFAULT_DB_CONNECTION } from '../mongoose.constants';

export function getModelToken(model: string, connectionName?: string) {
  if (connectionName === undefined) {
    return `${model}Model`;
  }
  return `${getConnectionToken(connectionName)}/${model}Model`;
}

export function getConnectionToken(name?: string) {
  return name && name !== DEFAULT_DB_CONNECTION
    ? `${name}Connection`
    : DEFAULT_DB_CONNECTION;
}

export function handleRetry(
  retryAttempts = 9,
  retryDelay = 3000,
  verboseRetryLog = false,
): <T>(source: Observable<T>) => Observable<T> {
  const logger = new Logger('MongooseModule');
  return <T>(source: Observable<T>) =>
    source.pipe(
      retryWhen((e) =>
        e.pipe(
          scan((errorCount, error) => {
            const verboseMessage = verboseRetryLog
              ? ` Message: ${error.message}.`
              : '';
            const retryMessage =
              retryAttempts > 0 ? ` Retrying (${errorCount + 1})...` : '';

            logger.error(
              [
                'Unable to connect to the database.',
                verboseMessage,
                retryMessage,
              ].join(''),
              error.stack,
            );
            if (errorCount + 1 >= retryAttempts) {
              throw error;
            }
            return errorCount + 1;
          }, 0),
          delay(retryDelay),
        ),
      ),
    );
}



================================================
FILE: lib/decorators/index.ts
================================================
export * from './prop.decorator';
export * from './schema.decorator';
export * from './virtual.decorator';



================================================
FILE: lib/decorators/prop.decorator.ts
================================================
import * as mongoose from 'mongoose';
import { CannotDetermineTypeError } from '../errors';
import { RAW_OBJECT_DEFINITION } from '../mongoose.constants';
import { TypeMetadataStorage } from '../storages/type-metadata.storage';

const TYPE_METADATA_KEY = 'design:type';
/**
 * Interface defining property options that can be passed to `@Prop()` decorator.
 */
export type PropOptions<T = any> =
  | Partial<mongoose.SchemaDefinitionProperty<T>>
  | mongoose.SchemaType;

/**
 * @Prop decorator is used to mark a specific class property as a Mongoose property.
 * Only properties decorated with this decorator will be defined in the schema.
 */
export function Prop(options?: PropOptions): PropertyDecorator {
  return (target: object, propertyKey: string | symbol) => {
    options = (options || {}) as mongoose.SchemaTypeOptions<unknown>;

    const isRawDefinition = options[RAW_OBJECT_DEFINITION];
    if (!options.type && !Array.isArray(options) && !isRawDefinition) {
      const type = Reflect.getMetadata(TYPE_METADATA_KEY, target, propertyKey);

      if (type === Array) {
        options.type = [];
      } else if (type && type !== Object) {
        options.type = type;
      } else {
        throw new CannotDetermineTypeError(
          target.constructor?.name,
          propertyKey as string,
        );
      }
    }

    TypeMetadataStorage.addPropertyMetadata({
      target: target.constructor,
      propertyKey: propertyKey as string,
      options: options as PropOptions,
    });
  };
}



================================================
FILE: lib/decorators/schema.decorator.ts
================================================
import * as mongoose from 'mongoose';
import { TypeMetadataStorage } from '../storages/type-metadata.storage';

/**
 * Interface defining schema options that can be passed to `@Schema()` decorator.
 */
export type SchemaOptions = mongoose.SchemaOptions;

/**
 * @Schema decorator is used to mark a class as a Mongoose schema.
 * Only properties decorated with this decorator will be defined in the schema.
 */
export function Schema(options?: SchemaOptions): ClassDecorator {
  return (target: Function) => {
    TypeMetadataStorage.addSchemaMetadata({
      target,
      options,
    });
  };
}



================================================
FILE: lib/decorators/virtual.decorator.ts
================================================
import { VirtualTypeOptions } from 'mongoose';
import { TypeMetadataStorage } from '../storages/type-metadata.storage';

/**
 * Interface defining the options that can be passed to the `@Virtual()` decorator.
 */
export interface VirtualOptions {
  /**
   * The options to pass to the virtual type.
   */
  options?: VirtualTypeOptions;
  /**
   * The sub path to use for the virtual.
   * Defaults to the property key.
   */
  subPath?: string;
  /**
   * The getter function to use for the virtual.
   */
  get?: (...args: any[]) => any;
  /**
   * The setter function to use for the virtual.
   */
  set?: (...args: any[]) => any;
}

/**
 * The Virtual decorator marks a class property as a Mongoose virtual.
 */
export function Virtual(options?: VirtualOptions): PropertyDecorator {
  return (target: object, propertyKey: string | symbol) => {
    TypeMetadataStorage.addVirtualMetadata({
      target: target.constructor,
      options: options?.options,
      name:
        propertyKey.toString() +
        (options?.subPath ? `.${options.subPath}` : ''),
      setter: options?.set,
      getter: options?.get,
    });
  };
}



================================================
FILE: lib/errors/cannot-determine-type.error.ts
================================================
export class CannotDetermineTypeError extends Error {
  constructor(hostClass: string, propertyKey: string) {
    super(
      `Cannot determine a type for the "${hostClass}.${propertyKey}" field (union/intersection/ambiguous type was used). Make sure your property is decorated with a "@Prop({ type: TYPE_HERE })" decorator.`,
    );
  }
}



================================================
FILE: lib/errors/index.ts
================================================
export * from './cannot-determine-type.error';



================================================
FILE: lib/factories/definitions.factory.ts
================================================
import { Type } from '@nestjs/common';
import { isUndefined } from '@nestjs/common/utils/shared.utils';
import * as mongoose from 'mongoose';
import { PropOptions } from '../decorators';
import { TypeMetadataStorage } from '../storages/type-metadata.storage';

const BUILT_IN_TYPES: Function[] = [
  Boolean,
  Number,
  String,
  Map,
  Date,
  Buffer,
  BigInt,
];

export class DefinitionsFactory {
  static createForClass(target: Type<unknown>): mongoose.SchemaDefinition {
    if (!target) {
      throw new Error(
        `Target class "${target}" passed in to the "DefinitionsFactory#createForClass()" method is "undefined".`,
      );
    }
    let schemaDefinition: mongoose.SchemaDefinition = {};
    let parent: Function = target;

    while (!isUndefined(parent.prototype)) {
      if (parent === Function.prototype) {
        break;
      }
      const schemaMetadata = TypeMetadataStorage.getSchemaMetadataByTarget(
        parent as Type<unknown>,
      );
      if (!schemaMetadata) {
        parent = Object.getPrototypeOf(parent);
        continue;
      }
      schemaMetadata.properties?.forEach((item) => {
        const options = this.inspectTypeDefinition(item.options as any);
        this.inspectRef(item.options as any);

        schemaDefinition = {
          [item.propertyKey]: options as any,
          ...schemaDefinition,
        };
      });
      parent = Object.getPrototypeOf(parent);
    }

    return schemaDefinition;
  }

  private static inspectTypeDefinition(
    optionsOrType: mongoose.SchemaTypeOptions<unknown> | Function,
  ): PropOptions | [PropOptions] | Function | mongoose.Schema {
    if (typeof optionsOrType === 'function') {
      if (this.isPrimitive(optionsOrType)) {
        return optionsOrType;
      } else if (this.isMongooseSchemaType(optionsOrType)) {
        return optionsOrType;
      }
      const isClass = /^class\s/.test(
        Function.prototype.toString.call(optionsOrType),
      );
      optionsOrType = isClass ? optionsOrType : optionsOrType();

      const schemaDefinition = this.createForClass(
        optionsOrType as Type<unknown>,
      );
      const schemaMetadata = TypeMetadataStorage.getSchemaMetadataByTarget(
        optionsOrType as Type<unknown>,
      );
      if (schemaMetadata?.options) {
        /**
         * When options are provided (e.g., `@Schema({ timestamps: true })`)
         * create a new nested schema for a subdocument
         * @ref https://mongoosejs.com/docs/subdocs.html
         **/

        return new mongoose.Schema(
          schemaDefinition,
          schemaMetadata.options,
        ) as mongoose.Schema;
      }
      return schemaDefinition;
    } else if (
      typeof optionsOrType.type === 'function' ||
      (Array.isArray(optionsOrType.type) &&
        typeof optionsOrType.type[0] === 'function')
    ) {
      optionsOrType.type = this.inspectTypeDefinition(optionsOrType.type);
      return optionsOrType;
    } else if (Array.isArray(optionsOrType)) {
      return optionsOrType.length > 0
        ? [this.inspectTypeDefinition(optionsOrType[0])]
        : (optionsOrType as any);
    }
    return optionsOrType;
  }

  private static inspectRef(
    optionsOrType: mongoose.SchemaTypeOptions<unknown> | Function,
  ) {
    if (!optionsOrType || typeof optionsOrType !== 'object') {
      return;
    }
    if (typeof optionsOrType?.ref === 'function') {
      try {
        const result = (optionsOrType.ref as Function)();
        if (typeof result?.name === 'string') {
          optionsOrType.ref = result.name;
        }
        optionsOrType.ref = optionsOrType.ref;
      } catch (err) {
        if (err instanceof TypeError) {
          const refClassName = (optionsOrType.ref as Function)?.name;
          throw new Error(
            `Unsupported syntax: Class constructor "${refClassName}" cannot be invoked without 'new'. Make sure to wrap your class reference in an arrow function (for example, "ref: () => ${refClassName}").`,
          );
        }
        throw err;
      }
    } else if (Array.isArray(optionsOrType.type)) {
      if (optionsOrType.type.length > 0) {
        this.inspectRef(optionsOrType.type[0]);
      }
    }
  }

  private static isPrimitive(type: Function) {
    return BUILT_IN_TYPES.includes(type);
  }

  private static isMongooseSchemaType(type: Function) {
    if (!type || !type.prototype) {
      return false;
    }
    const prototype = Object.getPrototypeOf(type.prototype);
    return prototype && prototype.constructor === mongoose.SchemaType;
  }
}



================================================
FILE: lib/factories/index.ts
================================================
export * from './definitions.factory';
export * from './schema.factory';
export * from './virtuals.factory';



================================================
FILE: lib/factories/schema.factory.ts
================================================
import { Type } from '@nestjs/common';
import * as mongoose from 'mongoose';
import { SchemaDefinition, SchemaDefinitionType } from 'mongoose';
import { TypeMetadataStorage } from '../storages/type-metadata.storage';
import { DefinitionsFactory } from './definitions.factory';
import { VirtualsFactory } from './virtuals.factory';

export class SchemaFactory {
  static createForClass<TClass = any>(
    target: Type<TClass>,
  ): mongoose.Schema<TClass> {
    const schemaDefinition = DefinitionsFactory.createForClass(target);
    const schemaMetadata =
      TypeMetadataStorage.getSchemaMetadataByTarget(target);
    const schemaOpts = schemaMetadata?.options;

    const schema = new mongoose.Schema<TClass>(
      schemaDefinition as SchemaDefinition<SchemaDefinitionType<TClass>>,
      schemaOpts as mongoose.SchemaOptions<any>,
    );

    VirtualsFactory.inspect(target, schema);

    return schema;
  }
}



================================================
FILE: lib/factories/virtuals.factory.ts
================================================
import { Type } from '@nestjs/common';
import { isUndefined } from '@nestjs/common/utils/shared.utils';
import * as mongoose from 'mongoose';
import { TypeMetadataStorage } from '../storages/type-metadata.storage';

export class VirtualsFactory {
  static inspect<TClass = any>(
    target: Type<TClass>,
    schema: mongoose.Schema<TClass>,
  ): void {
    let parent = target;

    while (!isUndefined(parent.prototype)) {
      if (parent === Function.prototype) {
        break;
      }
      const virtuals = TypeMetadataStorage.getVirtualsMetadataByTarget(parent);

      virtuals.forEach(({ options, name, getter, setter }) => {
        const virtual = schema.virtual(name, options);

        if (getter) {
          virtual.get(getter);
        }

        if (setter) {
          virtual.set(setter);
        }
      });

      parent = Object.getPrototypeOf(parent);
    }
  }
}



================================================
FILE: lib/interfaces/async-model-factory.interface.ts
================================================
import { ModuleMetadata } from '@nestjs/common';
import { ModelDefinition } from './model-definition.interface';

export interface AsyncModelFactory
  extends Pick<ModuleMetadata, 'imports'>,
    Pick<ModelDefinition, 'name' | 'collection' | 'discriminators'> {
  useFactory: (
    ...args: any[]
  ) => ModelDefinition['schema'] | Promise<ModelDefinition['schema']>;
  inject?: any[];
}



================================================
FILE: lib/interfaces/index.ts
================================================
export * from './async-model-factory.interface';
export * from './model-definition.interface';
export * from './mongoose-options.interface';



================================================
FILE: lib/interfaces/model-definition.interface.ts
================================================
import { Schema } from 'mongoose';

export type DiscriminatorOptions = {
  name: string;
  schema: Schema;
  value?: string;
};

export type ModelDefinition = {
  name: string;
  schema: any;
  collection?: string;
  discriminators?: DiscriminatorOptions[];
};



================================================
FILE: lib/interfaces/mongoose-options.interface.ts
================================================
import { ModuleMetadata, Type } from '@nestjs/common';
import { ConnectOptions, Connection, MongooseError } from 'mongoose';

export interface MongooseModuleOptions extends ConnectOptions {
  uri?: string;
  retryAttempts?: number;
  retryDelay?: number;
  connectionName?: string;
  connectionFactory?: (connection: any, name: string) => any;
  connectionErrorFactory?: (error: MongooseError) => MongooseError;
  lazyConnection?: boolean;
  onConnectionCreate?: (connection: Connection) => void;
  /**
   * If `true`, will show verbose error messages on each connection retry.
   */
  verboseRetryLog?: boolean;
}

export interface MongooseOptionsFactory {
  createMongooseOptions():
    | Promise<MongooseModuleOptions>
    | MongooseModuleOptions;
}

export type MongooseModuleFactoryOptions = Omit<
  MongooseModuleOptions,
  'connectionName'
>;

export interface MongooseModuleAsyncOptions
  extends Pick<ModuleMetadata, 'imports'> {
  connectionName?: string;
  useExisting?: Type<MongooseOptionsFactory>;
  useClass?: Type<MongooseOptionsFactory>;
  useFactory?: (
    ...args: any[]
  ) => Promise<MongooseModuleFactoryOptions> | MongooseModuleFactoryOptions;
  inject?: any[];
}



================================================
FILE: lib/metadata/property-metadata.interface.ts
================================================
import { PropOptions } from '../decorators/prop.decorator';

export interface PropertyMetadata {
  target: Function;
  propertyKey: string;
  options: PropOptions;
}



================================================
FILE: lib/metadata/schema-metadata.interface.ts
================================================
import * as mongoose from 'mongoose';
import { PropertyMetadata } from './property-metadata.interface';

export interface SchemaMetadata {
  target: Function;
  options?: mongoose.SchemaOptions;
  properties?: PropertyMetadata[];
}



================================================
FILE: lib/metadata/virtual-metadata.interface.ts
================================================
import { VirtualTypeOptions } from 'mongoose';

export interface VirtualMetadataInterface {
  target: Function;
  name: string;
  options?: VirtualTypeOptions;
  getter?: (...args: any[]) => any;
  setter?: (...args: any[]) => any;
}



================================================
FILE: lib/pipes/index.ts
================================================
export * from './is-object-id.pipe';
export * from './parse-object-id.pipe';



================================================
FILE: lib/pipes/is-object-id.pipe.ts
================================================
import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { Types } from 'mongoose';

@Injectable()
export class IsObjectIdPipe implements PipeTransform {
  transform(value: string): string {
    const isValidObjectId = Types.ObjectId.isValid(value);

    if (!isValidObjectId) {
      throw new BadRequestException(
        `Invalid ObjectId: '${value}' is not a valid MongoDB ObjectId`,
      );
    }

    return value;
  }
}



================================================
FILE: lib/pipes/parse-object-id.pipe.ts
================================================
import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { Types } from 'mongoose';

@Injectable()
export class ParseObjectIdPipe implements PipeTransform {
  transform(value: string): Types.ObjectId {
    const isValidObjectId = Types.ObjectId.isValid(value);

    if (!isValidObjectId) {
      throw new BadRequestException(
        `Invalid ObjectId: '${value}' is not a valid MongoDB ObjectId`,
      );
    }

    return new Types.ObjectId(value);
  }
}



================================================
FILE: lib/storages/type-metadata.storage.ts
================================================
import { Type } from '@nestjs/common';
import { PropertyMetadata } from '../metadata/property-metadata.interface';
import { SchemaMetadata } from '../metadata/schema-metadata.interface';
import { VirtualMetadataInterface } from '../metadata/virtual-metadata.interface';
import { isTargetEqual } from '../utils/is-target-equal-util';

export class TypeMetadataStorageHost {
  private schemas = new Array<SchemaMetadata>();
  private properties = new Array<PropertyMetadata>();
  private virtuals = new Array<VirtualMetadataInterface>();

  addPropertyMetadata(metadata: PropertyMetadata) {
    this.properties.unshift(metadata);
  }

  addSchemaMetadata(metadata: SchemaMetadata) {
    this.compileClassMetadata(metadata);
    this.schemas.push(metadata);
  }

  addVirtualMetadata(metadata: VirtualMetadataInterface) {
    this.virtuals.push(metadata);
  }

  getSchemaMetadataByTarget(target: Type<unknown>): SchemaMetadata | undefined {
    return this.schemas.find((item) => item.target === target);
  }

  getVirtualsMetadataByTarget<TClass>(targetFilter: Type<TClass>) {
    return this.virtuals.filter(({ target }) => target === targetFilter);
  }

  private compileClassMetadata(metadata: SchemaMetadata) {
    const belongsToClass = isTargetEqual.bind(undefined, metadata);

    if (!metadata.properties) {
      metadata.properties = this.getClassFieldsByPredicate(belongsToClass);
    }
  }

  private getClassFieldsByPredicate(
    belongsToClass: (item: PropertyMetadata) => boolean,
  ) {
    return this.properties.filter(belongsToClass);
  }
}

const globalRef = global as any;
export const TypeMetadataStorage: TypeMetadataStorageHost =
  globalRef.MongoTypeMetadataStorage ||
  (globalRef.MongoTypeMetadataStorage = new TypeMetadataStorageHost());



================================================
FILE: lib/utils/index.ts
================================================
export * from './raw.util';



================================================
FILE: lib/utils/is-target-equal-util.ts
================================================
export type TargetHost = Record<'target', Function>;
export function isTargetEqual<T extends TargetHost, U extends TargetHost>(
  a: T,
  b: U,
) {
  return (
    a.target === b.target ||
    (a.target.prototype
      ? isTargetEqual({ target: (a.target as any).__proto__ }, b)
      : false)
  );
}



================================================
FILE: lib/utils/raw.util.ts
================================================
import { RAW_OBJECT_DEFINITION } from '../mongoose.constants';

export function raw(definition: Record<string, any>) {
  Object.defineProperty(definition, RAW_OBJECT_DEFINITION, {
    value: true,
    enumerable: false,
    configurable: false,
  });
  return definition;
}


