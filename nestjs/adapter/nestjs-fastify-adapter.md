# FastifyAdapter.md

## Overview

`FastifyAdapter` is a full-featured NestJS HTTP adapter for the [Fastify](https://fastify.io/) web server framework. It extends `AbstractHttpAdapter` and integrates advanced features of Fastify into NestJS, such as performance, HTTP/2 support, lifecycle hooks, API versioning, plugin loading, constraint-based routing, middleware bridging, and request parsing.

---

## Key TypeScript Types

- **FastifyAdapterBaseOptions, FastifyHttp2Options, FastifyHttp2SecureOptions, FastifyHttpsOptions, FastifyHttpOptions:**  
  Typed subsets of Fastify server configuration supporting HTTP, HTTPS, HTTP/2 modes.

- **VersionedRoute:**  
  A typed version-aware function used internally for routing and version filtering.

- **FastifyRawRequest:**  
  Subclass of `RawRequestDefaultExpression` with an optional `originalUrl` property (added if middie plugin is enabled).

---

## Class Definition

```ts
export class FastifyAdapter<...> extends AbstractHttpAdapter<TServer, TRequest, TReply>
```

Fully generic, parametrized on:

| Parameter      | Purpose                                        |
| -------------- | ---------------------------------------------- |
| `TServer`      | Raw Fastify server (http, https, http2)        |
| `TRawRequest`  | Underlying raw request type with `originalUrl` |
| `TRawResponse` | Underlying raw response                        |
| `TRequest`     | Parsed FastifyRequest                          |
| `TReply`       | FastifyReply                                   |
| `TInstance`    | FastifyInstance                                |

---

## Key Properties

| Name                  | Purpose                                                                      |
| --------------------- | ---------------------------------------------------------------------------- |
| `instance`            | Underlying Fastify instance                                                  |
| `logger`              | NestJS logger instance                                                       |
| `_isParserRegistered` | Indicates if body parsers were registered                                    |
| `isMiddieRegistered`  | If the Fastify `middie` plugin for middleware is registered                  |
| `_pathPrefix`         | The global prefix for routes (e.g., `/api`)                                  |
| `versioningOptions`   | Holds versioning strategy options                                            |
| `versionConstraint`   | Fastify 'constraint strategy' for versioning (header, media type, or custom) |

---

## Construction

- Accepts:
  - A pre-existing Fastify instance
  - Or Fastify options (plain object)
  - Auto-creates an instance if not supplied
- Registers the above `versionConstraint` as a Fastify route constraint
- Optionally skips middie if `skipMiddie` is set.

---

## Core Methods

### Server setup & control

| Method             | Description                                |
| ------------------ | ------------------------------------------ |
| `init()`           | Registers `middie` plugin (if not skipped) |
| `listen(...)`      | Starts HTTP server                         |
| `close()`          | Gracefully closes Fastify server           |
| `initHttpServer()` | Assigns internal `httpServer` property     |

---

### Middleware

| Method                      | Description                                                                           |
| --------------------------- | ------------------------------------------------------------------------------------- |
| `createMiddlewareFactory()` | Generates a factory that bridges Express-style middleware into Fastify using `middie` |
| `applyVersionFilter()`      | Attaches version metadata to a handler (used internally by Nest for versioned routes) |

---

### Routing & HTTP methods

Fastify method call helper:

```ts
injectRouteOptions(method: HTTPMethods, ...args)
```

Public HTTP method helpers (proxy to `instance.route()`):

```ts
get, post, head, delete, put, patch, options, search, propfind, proppatch, mkcol, copy, move, lock, unlock
```

---

### Responses / Requests

| Method                                | Description                                              |
| ------------------------------------- | -------------------------------------------------------- |
| `reply(response, body, statusCode?)`  | Sends a response, streams `StreamableFile`, sets headers |
| `status(response, code)`              | Sets status code on reply                                |
| `end(response, message?)`             | Ends the raw response                                    |
| `render(response, view, options)`     | Renders a template via Fastify view plugin               |
| `redirect(response, statusCode, url)` | Sends redirect response                                  |
| `setErrorHandler(handler)`            | Registers Fastify error handler                          |
| `setNotFoundHandler(handler)`         | Registers a 404 handler                                  |
| `isHeadersSent(response)`             | Checks if response was sent                              |
| `getHeader(response, name)`           | Gets header value                                        |
| `setHeader(response, name, value)`    | Sets header value                                        |
| `appendHeader(response, name, value)` | Appends to header                                        |
| `getRequestUrl(request)`              | Extracts URL                                             |
| `getRequestHostname(request)`         | Extracts hostname                                        |
| `getRequestMethod(request)`           | Extracts HTTP method                                     |

---

### CORS & Static Assets & Views

| Method                     | Description                                                                   |
| -------------------------- | ----------------------------------------------------------------------------- |
| `enableCors(options?)`     | Registers [@fastify/cors](https://github.com/fastify/fastify-cors) plugin     |
| `useStaticAssets(options)` | Registers [@fastify/static](https://github.com/fastify/fastify-static) plugin |
| `setViewEngine(options)`   | Registers [@fastify/view](https://github.com/fastify/point-of-view) plugin    |

---

### Body Parsing

- **Express-like parser registration:**

```ts
registerParserMiddleware(prefix?, rawBody?)
```

- Registers JSON and URL-encoded content type parsers with buffer support
- Avoids multiple registrations

- **Custom parser registration:**

```ts
useBodyParser(contentType, rawBody, options?, parserFn?)
```

- Supports any content type
- Exposes raw buffers if desired

---

### Extra

| Method                               | Description                             |
| ------------------------------------ | --------------------------------------- |
| `register()`                         | Register Fastify plugin manually        |
| `inject()`                           | Directly call routes (used for testing) |
| `getHttpServer()`                    | Returns underlying server instance      |
| `getInstance()`                      | Returns Fastify app instance            |
| `getType()`                          | Returns "fastify" string                |
| `registerWithPrefix(factory,prefix)` | Register plugin with optional prefix    |

---

## Versioning Support

Implements API versioning based on:

- Route constraints (first-class Fastify feature)
- Extractor callback, header-based, or media-type via Accept header
- Supports multi-version concurrency with Efficient dispatch

---

## Key Implementation Points

- Uses Fastify [Route Constraints](https://www.fastify.io/docs/latest/Reference/Routes/#constraints) system to handle API versions efficiently.
- If not explicitly disabled, internally loads `middie` plugin to support `use(middleware)` style Express middleware.
- Allows `rawBody` access for request validation/signature use-cases.
- Provides utility `inject()` interface supporting both async and chainable modes.
- Supports HTTP/2, HTTPS, plain HTTP with same API.
- Handles both raw Node.js streams and Fastify reply explicitly.
- Loads static + view plugin dynamically on demand, erroring with helpful message if missing.
- Compatible with NestJS global middleware, filters, pipes, interceptors out of the box.

---

## Usage Example (summary)

```ts
const fastifyAdapter = new FastifyAdapter();
await fastifyAdapter.init();
fastifyAdapter.listen(3000);
fastifyAdapter.get("/hello", (req, res) => res.send("world"));
```

---

## References

- [Fastify Official](https://fastify.io/)
- [NestJS with Fastify docs](https://docs.nestjs.com/techniques/performance)
- [Fastify plugin system](https://www.fastify.io/docs/latest/Reference/Plugins/)
- [Fastify Route Constraints](https://fastify.io/docs/latest/Reference/Routes/#constraints)

---

This document provides a conceptual and structural summary designed for LLMs or developers to quickly appreciate the capabilities of the NestJS `FastifyAdapter`, highlighting its flexible integration with Fastify and its approximation of Express-like semantics within a high performance event-driven HTTP server environment.
