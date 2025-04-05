# Root: docs/

- **`index.md`**  
  General Fastify documentation homepage or table of contents.

---

## Guides  
Located in: `docs/Guides/`  
Practical tutorials, best practices, migrations, and plugin development guides.

- **General Usage**
  - `Getting-Started.md` — Initial setup and basic usage.
  - `Recommendations.md` — Fastify usage recommendations.
  - `Serverless.md` — Using Fastify in serverless environments.
  - `Ecosystem.md` — Overview of surrounding tools and plugins.
  - `Style-Guide.md` — Coding style guide.
  - `Testing.md` — Writing tests for Fastify applications.
  - `Benchmarking.md` — How to benchmark Fastify performance.
  - `Delay-Accepting-Requests.md` — Controlling request acceptance timing.
  - `Detecting-When-Clients-Abort.md` — Handling client disconnects.
  - `Prototype-Poisoning.md` — Protecting against prototype pollution attacks.
  - `Contributing.md` — Guidelines for contributing to Fastify.
  
- **Migration Guides**
  - `Migration-Guide-V3.md` — Migration path to Fastify v3.
  - `Migration-Guide-V4.md` — Migration path to Fastify v4.
  - `Migration-Guide-V5.md` — Migration path to Fastify v5.
  
- **Plugins & Extensions**
  - `Plugins-Guide.md` — Using and creating plugins.
  - `Write-Plugin.md` — Step-by-step custom plugin creation.
  - `Write-Type-Provider.md` — Creating custom type providers.
  - `Fluent-Schema.md` — Fluent schema creation with Fastify.

- **Database Integration**
  - `Database.md` — Working with databases in Fastify.

- **Index**
  - `Index.md` — Index page for Guides (likely ToC for Guides folder).

---

## API Reference  
Located in: `docs/Reference/`  
In-depth documentation of Fastify core modules, classes, hooks, and concepts.

- `Index.md` — API reference index page.

- **Core Components**
  - `Server.md` — Fastify server instance.
  - `Routes.md` — Defining routes/endpoints.
  - `Request.md` — Request object.
  - `Reply.md` — Reply/response object.
  - `Lifecycle.md` — Request lifecycle in Fastify.
  - `Hooks.md` — Hooking into lifecycle events.
  - `Middleware.md` — Middleware usage.
  - `Encapsulation.md` — Context encapsulation/exposure hiding.
  - `Type-Providers.md` — Using/generating type providers.
  - `TypeScript.md` — TypeScript support and examples.
  - `Decorators.md` — Extending Fastify via decorators.
  
- **Utilities & Features**
  - `Validation-and-Serialization.md` — Schema validation and serialization.
  - `ContentTypeParser.md` — Content-Type parsers.
  - `Logging.md` — Logging capabilities.
  - `HTTP2.md` — HTTP/2 support.
  - `Warnings.md` — Common warnings and solutions.
  - `Errors.md` — Built-in error handling.
  - `LTS.md` — Long-term support policy.
  - `Principles.md` — Framework design principles.
  - `Plugins.md` — Plugin API reference (distinct from plugin guide).

---

## Resources  
Located in: `docs/resources/`

- `encapsulation_context.drawio` — Visual diagram/illustration of context encapsulation (likely an architecture diagram).

---

# Summary View

| Section     | Description                                                         |
|-------------|---------------------------------------------------------------------|
| Guides      | How-to guides, migrations, ecosystem info, plugin & schema creation |
| Reference   | API docs for Fastify classes, features, lifecycle, and advanced use |
| Resources   | Visual diagrams/assets                                              |
| index.md    | Overall root documentation entry point                              |
