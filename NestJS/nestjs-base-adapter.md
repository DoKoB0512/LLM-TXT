# AbstractHttpAdapter.md

## Overview

The `AbstractHttpAdapter` class is an abstract base class in NestJS that defines an interface for HTTP server platforms. It implements common methods used to handle HTTP requests (GET, POST, PUT, DELETE, etc.) by delegating calls to an underlying HTTP framework adapter (like Express or Fastify). This base class allows NestJS to be HTTP-server-neutral and provides abstractions to simplify extending support for other HTTP frameworks.

---

## Imports

```typescript
import { HttpServer, RequestMethod, VersioningOptions } from "@nestjs/common";

import { RequestHandler, VersionValue } from "@nestjs/common/interfaces";

import { NestApplicationOptions } from "@nestjs/common/interfaces/nest-application-options.interface";
```

---

## Class Definition

```typescript
abstract class AbstractHttpAdapter<TServer = any, TRequest = any, TResponse = any>
  implements HttpServer<TRequest, TResponse> {
```

- **Generics:**

  - `TServer`: The internal HTTP server instance (e.g., Express App or Fastify server).
  - `TRequest`: Type of incoming request objects.
  - `TResponse`: Type of outgoing response objects.

- **Implements:**
  - `HttpServer<TRequest, TResponse>` interface.

---

## Properties

| Name                   | Type      | Description                                                       |
| ---------------------- | --------- | ----------------------------------------------------------------- |
| `protected httpServer` | `TServer` | The actual HTTP server instance.                                  |
| `protected instance`   | `any`     | The HTTP framework instance (Express/Fastify app instance, etc.). |

---

## Lifecycle Methods

| Method                   | Description                                                   |
| ------------------------ | ------------------------------------------------------------- |
| `constructor(instance?)` | Creates adapter with an optional HTTP framework instance.     |
| `async init()`           | Method stub for async initialization (used by some adapters). |

---

## Core HTTP Routing Methods

All HTTP routing methods delegate to the underlying HTTP library instance:

- Use middleware:

```typescript
public use(...args: any[]): any
```

- Define HTTP handlers (each method overloads handler with or without path):

```typescript
public get(), post(), put(), delete(), patch(), head(), options(), all(), search()

// WebDAV methods
propfind(), proppatch(), mkcol(), copy(), move(), lock(), unlock()
```

---

## Server Control Methods

```typescript
public listen(port: string | number, callback?: Function)
public listen(port: string | number, hostname: string, callback?: Function)
```

Start listening on a network port.

---

## Instance Management Methods

```typescript
public getHttpServer(): TServer
public setHttpServer(httpServer: TServer)

public setInstance<T = any>(instance: T)
public getInstance<T = any>(): T
```

---

## Path-related

```typescript
public normalizePath(path: string): string
```

Can be overridden to normalize URL paths according to adapter conventions.

---

## Abstract Methods

Derived adapters **MUST** implement:

| Method Signature                                               | Description                       |
| -------------------------------------------------------------- | --------------------------------- |
| `close()`                                                      | Close HTTP server.                |
| `initHttpServer(options: NestApplicationOptions)`              | Setup underlying HTTP server.     |
| `useStaticAssets(...args: any[])`                              | Serve static assets.              |
| `setViewEngine(engine: string)`                                | Set view templating engine.       |
| `getRequestHostname(request: any)`                             | Extract hostname from request.    |
| `getRequestMethod(request: any)`                               | Extract HTTP method from request. |
| `getRequestUrl(request: any)`                                  | Extract URL from request.         |
| `status(response: any, statusCode: number)`                    | Set response status code.         |
| `reply(response: any, body: any, statusCode?)`                 | Finalize response with body.      |
| `end(response: any, message?: string)`                         | End HTTP response stream.         |
| `render(response: any, view: string, options: any)`            | Render templated views.           |
| `redirect(response: any, statusCode: number, url)`             | Redirect response to URL.         |
| `setErrorHandler(handler: Function, prefix?: string)`          | Set global error handler.         |
| `setNotFoundHandler(handler: Function, prefix?: string)`       | Set 404 not found handler.        |
| `isHeadersSent(response: any)`                                 | Check if response headers sent.   |
| `setHeader(response: any, name: string, value: string)`        | Set response header.              |
| `registerParserMiddleware(prefix?: string, rawBody?: boolean)` | Register body parsers.            |
| `enableCors(options?: any, prefix?: string)`                   | Enable CORS.                      |
| `createMiddlewareFactory(requestMethod: RequestMethod)`        | Middleware factory.               |
| `getType()`                                                    | Returns the type of adapter.      |
| `applyVersionFilter(handler, version, versioningOptions)`      | Version-based dispatch.           |

---

## Usage Notes

- **Subclasses** of AbstractHttpAdapter implement the framework-specific logic by overriding the abstract methods.
- Methods like `get`, `post`, `use`, etc., transparently proxy to the underlying HTTP server instance.
- Supports **WebDAV** extensions (e.g., `propfind`, `proppatch`, `mkcol`, etc.).
- Provides version-aware routing capabilities via `applyVersionFilter`.
- Promotes portability and pluggability of HTTP servers in NestJS core.

---

## Summary

- Designed as a **platform-agnostic HTTP server interface** supporting Express, Fastify, or any other compatible server.
- Provides an extensible foundation to implement concrete adapters for various Node.js web frameworks.
- Facilitates core routing, middleware integration, and response handling in a standardized way for NestJS.

---

## References

- [NestJS Platform Adapter documentation](https://docs.nestjs.com/faq/platform-adapters)
- [NestJS HttpServer interface](https://github.com/nestjs/nest/blob/master/packages/common/interfaces/http/http-server.interface.ts)

---

This documentation provides a structured overview to help LLMs and developers understand the purpose, design, and expected extension points of the `AbstractHttpAdapter` source code.
