# ExpressAdapter.md

## Overview

`ExpressAdapter` is the official NestJS HTTP platform adapter built on top of the `express` framework. It extends `AbstractHttpAdapter` and acts as a bridge between NestJS core APIs and the Express API, overriding abstract methods with Express-specific implementations. This adapter enables NestJS to run on Express seamlessly supporting features like routing, middleware, static assets, CORS, versioning, etc.

---

## Key Imports

```typescript
import * as express from "express";
import * as http from "http";
import * as https from "https";
import { pathToRegexp } from "path-to-regexp";
import * as cors from "cors";
import {
  Logger,
  StreamableFile,
  RequestMethod,
  VersioningOptions,
  VersioningType,
  VERSION_NEUTRAL,
  InternalServerErrorException,
  HttpStatus,
} from "@nestjs/common";
import { AbstractHttpAdapter } from "@nestjs/core/adapters/http-adapter";
import { RouterMethodFactory } from "@nestjs/core/helpers/router-method-factory";
import { LegacyRouteConverter } from "@nestjs/core/router/legacy-route-converter";
import { getBodyParserOptions } from "./utils/get-body-parser-options.util";
import {
  CorsOptions,
  CorsOptionsDelegate,
} from "@nestjs/common/interfaces/external/cors-options.interface";
import type { Server } from "http";
import { Duplex, pipeline } from "stream";
```

---

## Construction

```typescript
export class ExpressAdapter extends AbstractHttpAdapter<
  http.Server | https.Server
> {
  private readonly routerMethodFactory = new RouterMethodFactory();
  private readonly logger = new Logger(ExpressAdapter.name);
  private readonly openConnections = new Set<Duplex>();

  constructor(instance?: any) {
    super(instance || express());
  }
}
```

- **Extends:** `AbstractHttpAdapter`
- **Underlying instance:** Express application
- **Holds:**
  - Router invocation helper (`RouterMethodFactory`)
  - Logger instance
  - Open connection tracking set (`forceCloseConnections` support)

---

## Core Response Methods

| Method                                | Description                                                                                                                                           |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| `reply(response, body, statusCode?)`  | Handles HTTP responses, including `StreamableFile` streaming, JSON, plain text, with appropriate headers. Warns if content-type mismatch is detected. |
| `status(response, code)`              | Set status code.                                                                                                                                      |
| `end(response, message?)`             | Finalize response with optional text.                                                                                                                 |
| `render(response, view, options)`     | Render a template view.                                                                                                                               |
| `redirect(response, code, url)`       | Redirect response.                                                                                                                                    |
| `setErrorHandler(handler)`            | Register error handler middleware.                                                                                                                    |
| `setNotFoundHandler(handler)`         | Register 404 handler middleware.                                                                                                                      |
| `isHeadersSent(response)`             | Check if headers already sent.                                                                                                                        |
| `getHeader(response, name)`           | Read a response header.                                                                                                                               |
| `setHeader(response, name, value)`    | Set a response header.                                                                                                                                |
| `appendHeader(response, name, value)` | Append a response header value.                                                                                                                       |

---

## Routing & Application Config Methods

| Method                                                          | Description                                                        |
| --------------------------------------------------------------- | ------------------------------------------------------------------ | --------------------------------- |
| `normalizePath(path)`                                           | Converts dynamic route syntax to Express style. Throws if invalid. |
| `listen(port, hostname?, callback?)`                            | Starts HTTP/S server.                                              |
| `close()`                                                       | Gracefully closes server and open connections.                     |
| `set(...args)` / `enable(...)` / `disable(...)` / `engine(...)` | Proxy Express native configuration methods.                        |
| `useStaticAssets(path, options)`                                | Serves static files with optional URL prefix.                      |
| `setBaseViewsDir(path                                           | string[])`                                                         | Where template views are located. |
| `setViewEngine(engine)`                                         | Set templating engine (EJS, PUG, etc.).                            |
| `getRequestHostname(request)`                                   | Extract hostname.                                                  |
| `getRequestMethod(request)`                                     | Extract HTTP method.                                               |
| `getRequestUrl(request)`                                        | Extract original request URL.                                      |

---

## CORS Support

```typescript
enableCors(options: CorsOptions | CorsOptionsDelegate<any>)
```

- Adds CORS middleware (`cors` package) with provided options.

---

## Middleware & Parsers

| Method                                        | Description                                                                                   |
| --------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `createMiddlewareFactory(requestMethod)`      | Returns a method factory to bind route handlers for a HTTP verb.                              |
| `registerParserMiddleware(prefix?, rawBody?)` | Adds Express middlewares for JSON and URL-encoded parsing. Avoids redundant registration.     |
| `useBodyParser(type, rawBody, options?)`      | Allows explicit custom express body parser registration (JSON, URL-encoded, raw, text, etc.). |
| `setLocal(key, value)`                        | Sets a local variable on the app (`res.locals`).                                              |

---

## HTTP Server Initialization

```typescript
initHttpServer(options: NestApplicationOptions)
```

- If HTTPS options present, creates HTTPS server with Express instance.
- Else default HTTP server.
- Supports `forceCloseConnections` to actively track and close open sockets on shutdown (useful for hot reload/restart).

---

## API Versioning Support

```typescript
applyVersionFilter(handler, version, versioningOptions);
```

Implements custom Express-compatible API versioning logic:

- **Version-neutral** & URI-style → Always route
- **Custom extractor**:
  - Extracts version via user-defined extractor on request object.
  - Checks if it matches requested version string or array.
- **Media-type (Accept header)**:
  - Matches `Accept` header's parameter (e.g., `application/json;v=1`).
- **Header-based** versioning:
  - Matches version from custom header.
- **Else**, no match → calls next middleware, so another versioned handler can be tried.

Throws if versioning strategy not supported.

---

## Utility Methods

- `trackOpenConnections()`: Listen to new TCP sockets, add/remove to a Set, so they can be forcibly killed during shutdown for `forceCloseConnections`.
- `closeOpenConnections()`: Destroy all tracked connections.
- `isMiddlewareApplied(name)`: Detects whether a middleware is already registered (to avoid double-adding parsers, etc.).

---

## Summary

- **Primary** NestJS HTTP adapter for **Express** platform.
- Handles:
  - Request routing & middleware
  - Streaming files response support (`StreamableFile`)
  - Static assets and template engines
  - Forced connection termination on shutdown
  - CORS integration
  - Express API versioning strategies
  - Flexible middleware/parser registration
  - Compatibility with core NestJS abstractions

---

## References

- [NestJS Official Express Adapter](https://docs.nestjs.com/faq/platform-express)
- [ExpressJS docs](http://expressjs.com/en/4x/api.html)
- [NestAPI Versioning](https://docs.nestjs.com/techniques/versioning)

---

This documentation gives a clear overview of the Express platform adapter so LLMs and developers can understand how NestJS integrates with Express internally.
