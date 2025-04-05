# Root: lib/

### Core Entry & Modules
- **`index.ts`**  
  Package exports and root index.
  
- **`mongoose.module.ts`**  
  Main NestJS integration module for Mongoose.
  
- **`mongoose-core.module.ts`**  
  Underlying core module for providers/config.
  
- **`mongoose.providers.ts`**  
  NestJS providers (connections, models).
  
- **`mongoose.constants.ts`**  
  Predefined constants, tokens.

---

## Submodules

### Common Helpers
Located in: `common/`
- `index.ts` — Exports
- `mongoose.decorators.ts` — Decorators used internally/shared
- `mongoose.utils.ts` — Common utility functions

### Decorators
Located in: `decorators/`
- `index.ts` — Exports
- `prop.decorator.ts` — `@Prop()` property field decorator
- `schema.decorator.ts` — `@Schema()` class decorator for schemas
- `virtual.decorator.ts` — `@Virtual()` for Mongoose virtuals

### Errors
Located in: `errors/`
- `cannot-determine-type.error.ts` — Error when property type can't be inferred
- `index.ts` — Export all errors

### Factories
Located in: `factories/`
- `definitions.factory.ts` — Factory building model definitions
- `schema.factory.ts` — Factory creating Mongoose schemas dynamically
- `virtuals.factory.ts` — Factory for Mongoose virtuals
- `index.ts` — Exports

### Interfaces
Located in: `interfaces/`
- `async-model-factory.interface.ts` — For dynamic/async model creation
- `model-definition.interface.ts` — Schema/model definitions
- `mongoose-options.interface.ts` — Options/settings interfaces
- `index.ts` — Exports

### Metadata Definitions
Located in: `metadata/`
- `property-metadata.interface.ts` — Metadata for schema properties
- `schema-metadata.interface.ts` — Metadata for class/entity schemas
- `virtual-metadata.interface.ts` — Metadata for virtual fields

### Validation Pipes
Located in: `pipes/`
- `is-object-id.pipe.ts` — Checks if a string is a valid MongoDB ObjectId
- `parse-object-id.pipe.ts` — Parses/validates incoming params as ObjectId
- `index.ts` — Exports

### Metadata Storages
Located in: `storages/`
- `type-metadata.storage.ts` — Stores collected metadata for schemas/properties

### Utilities
Located in: `utils/`
- `is-target-equal-util.ts` — Object/class comparison helpers
- `raw.util.ts` — Raw schema helper utilities
- `index.ts` — Exports

---

# Summary View:

| Category                 | Description                                                                       |
|--------------------------|-----------------------------------------------------------------------------------|
| Core Modules             | NestJS modules, providers, constants                                             |
| Common                   | Shared decorators/utilities                                                      |
| Decorators               | High-level Mongoose decorators (`@Schema()`, `@Prop()`, `@Virtual()`)            |
| Factories                | Factories to dynamically generate schemas, definitions, virtuals                  |
| Interfaces               | TypeScript interfaces for models, options, async factories                       |
| Metadata                 | Metadata interfaces for schemas, properties, and virtuals                        |
| Errors                   | Error classes                                                                    |
| Pipes                    | Pipes for validating/parsing MongoDB ObjectIds                                  |
| Storages                 | Metadata storage singleton(s)                                                    |
| Utilities                | Low-level utility helpers                                                        |
