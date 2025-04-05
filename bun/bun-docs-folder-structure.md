# Root: docs/

## Intro & Setup
- `index.md` — Homepage / Overview
- `installation.md` — Installing Bun
- `quickstart.md` — Quickstart guide
- `benchmarks.md` — Performance benchmarks
- `bun-flavored-toml.md` — `bunfig.toml` format details
- `typescript.md` — TypeScript support
- `nav.ts` — Navigation script/config (not Markdown)

---

## Core APIs
Located in: `docs/api/`
- `binary-data.md` — Handling binary data
- `cc.md` — Calling C functions / built-ins
- `color.md` — Color utilities
- `console.md` — Console features
- `cookie.md` — HTTP cookies
- `dns.md` — DNS operations
- `fetch.md` — `fetch()` API details
- `ffi.md` — Foreign Function Interface
- `file-io.md` — File input/output APIs
- `file-system-router.md` — Filesystem-based routing
- `file.md` — File abstraction details
- `glob.md` — Globbing and pattern matching
- `globals.md` — Global variables
- `hashing.md` — Cryptographic hashing
- `html-rewriter.md` — Streaming HTML rewriting
- `http.md` — HTTP server/client APIs
- `import-meta.md` — `import.meta` capabilities
- `node-api.md` — Node.js APIs compatibility
- `s3.md` — S3 file storage utility
- `semver.md` — Semantic version parsing
- `spawn.md` — Running child processes
- `sql.md` — SQL interface
- `sqlite.md` — SQLite database integration
- `streams.md` — Streams APIs
- `tcp.md` — TCP sockets
- `test.md` — Test API basics
- `transpiler.md` — JS/TS transpilation
- `udp.md` — UDP sockets
- `utils.md` — Utility functions
- `websockets.md` — WebSockets
- `workers.md` — Worker threads

---

## Bundler
Located in: `docs/bundler/`
- `intro.md` — Bundler overview
- `index.md` — Entry point
- `css.md` — Handling CSS files
- `css_modules.md` — CSS Modules support
- `executables.md` — Creating executables
- `fullstack.md` — Fullstack app bundling
- `hmr.md` — Hot Module Reloading
- `html.md` — Embedding HTML
- `loaders.md` — Configuration of loaders
- `macros.md` — Bundler macros
- `plugins.md` — Bundler plugin system
- `vs-esbuild.md` — Comparison with esbuild

---

## CLI Commands
Located in: `docs/cli/`
- `add.md` — Add dependencies
- `bun-create.md` — App/project scaffolding
- `bun-install.md` — Install dependencies
- `bun-upgrade.md` — Upgrade Bun versions
- `bunx.md` — Run one-off executables
- `bun-completions.md` — Shell completion setup
- `filter.md` — Package filtering
- `init.md` — Initialize project
- `install.md` — CLI install specifics
- `link.md` — Link packages
- `outdated.md` — List outdated packages
- `patch-commit.md` — Commit patch changes
- `pm.md` — Package manager commands
- `publish.md` — Publish packages
- `remove.md` — Remove packages
- `run.md` — Run scripts
- `test.md` — Running tests
- `unlink.md` — Unlink packages
- `update.md` — Update dependencies

---

## Contributing
Located in: `docs/contributing/`
- `upgrading-webkit.md` — How to upgrade bundled WebKit

---

## Ecosystem Integrations
Located in: `docs/ecosystem/`
- `elysia.md` — Elysia framework
- `express.md` — Using Express on Bun
- `hono.md` — Hono integration
- `react.md` — React integration
- `stric.md` — Stric framework

---

## Guides (extensive recipes and how-to)
Located in: `docs/guides/`

### Binary Data Conversion: `guides/binary/`
Covers conversion among:
- ArrayBuffer, Blob, Buffer, DataView, TypedArray, ReadableStreams, and Strings with dedicated guides.

### Ecosystem frameworks/tutorials: `guides/ecosystem/`
Guides for integration with:
- Astro, Discord.js, Docker, Drizzle, EdgeDB, Elysia, Express, Hono, Mongoose, Neon (drizzle/serverless postgres), Next.js, Nuxt, PM2, Prisma, Qwik, React, Remix, Render, Sentry, SolidStart, SSR with React, Stric, SvelteKit, Systemd, Vite

### HTML Rewriter guides: `guides/html-rewriter/`
- Extracting links
- Extracting social meta tags

### HTTP server/client usage: `guides/http/`
- Clustering
- Fetch on Unix
- File uploads
- Hot reload
- Proxies
- Simple server
- Streaming files and interoperability
- TLS

### Package Install techniques: `guides/install/`
- Adding dev/peer/optional/git/tarball deps
- Azure/JFrog registries
- CI/CD integrations
- Registry scoping
- NPM alias
- Yarn lockfile handling
- Bun lockfile
- Trusted signers
- Workspaces

### Process Control: `guides/process/`
- Process arguments
- Handling CTRL+C, signals
- IPC, process spawning
- Timings (nanoseconds)
- Stdin/stdout/stderr

### Reading Files: `guides/read-file/`
- Read as ArrayBuffer, Buffer, JSON, MIME, streams, strings, Uint8Array
- File existence
- Watch files

### Runtime Configuration: `guides/runtime/`
- CI/CD detection
- Codesigning macOS apps
- Importing HTML, JSON, TOML
- Constants
- Deleting files/dirs
- Heap snapshots
- Reading/setting env vars
- Shell integration
- Timezone
- Tsconfig paths / TypeScript
- Debuggers (VSCode, web)

### Streams - conversions: `guides/streams/`
- Node streams to/from ArrayBuffer, Blob, JSON, String, Uint8Array, TypedArray, Buffer

### Testing: `guides/test/`
- Bail, Coverage, Happy DOM, Migrating from Jest
- Mocking, spying
- Test control: skip, todo, rerun, watch
- Snapshot testing
- Svelte Testing Library
- Timeouts
- Updating snapshots
- Run tests

### Utilities: `guides/util/`
- Base64, gzip, deflate
- Detecting Bun
- Entrypoints
- File URL conversion
- Escape HTML
- Hash passwords
- Import.meta info
- Path conversions
- Sleep
- Version info
- Find executable bin path

### WebSocket Examples: `guides/websocket/`
- Compression
- Contexts
- Pubsub
- Simple chat

### Writing Files: `guides/write-file/`
- Append or overwrite
- Using Blob
- Cat files
- File copy
- Streams and FileSink
- Write responses
- Writing to stdout
- File removal (unlink)

---

## Install Internals
Located in: `docs/install/`
- `index.md` — Package installation overview
- `cache.md` — Caching strategy
- `lifecycle.md` — Lifecycle of install
- `lockfile.md` — Lockfile format
- `npmrc.md` — npmrc config
- `overrides.md` — Override packages
- `patch.md` — Applying patches
- `registries.md` — Registries usage
- `workspaces.md` — Workspaces support

---

## Project Info
Located in: `docs/project/`
- `benchmarking.md` — Benchmarking Bun
- `bindgen.md` — Bindgen tool
- `building-windows.md` — Compiling for Windows
- `roadmap.md` — Future plans
- `contributing.md` (symlink to CONTRIBUTING.md) — Contributor guide
- `licensing.md` (symlink to LICENSE.md) — License info

### Internals
- `internals/build-process-for-ci.md` — CI build process details

---

## Runtime
Located in: `docs/runtime/`
- `index.md` — Runtime overview
- `autoimport.md` — Automatic imports
- `bun-apis.md` — APIs available in Bun runtime
- `bunfig.md` — Configuration file guide
- `debugger.md` — Debugger usage
- `env.md` — Environment variables
- `hot.md` — Hot reload details
- `jsx.md` — JSX support
- `loaders.md` — Module loaders
- `modules.md` — Module resolution
- `nodejs-apis.md` — Node.js API support
- `plugins.md` — Runtime plugins
- `shell.md` — Shell execution
- `typescript.md` — Using TypeScript in runtime
- `web-apis.md` — Web standard APIs supported

---

## Testing
Located in: `docs/test/`
- `configuration.md` — Test runner config
- `coverage.md` — Test coverage
- `discovery.md` — Test discovery
- `dom.md` — DOM in testing
- `hot.md` — Hot reload for tests
- `lifecycle.md` — Test lifecycle
- `mocks.md` — Mocks in tests
- `reporters.md` — Test reporters
- `runtime-behavior.md` — Runtime behavior in tests
- `snapshots.md` — Snapshot testing
- `time.md` — Time handling in tests
- `writing.md` — Writing tests

---

# Summary
This outline captures the Bun documentation as major groups:

- **General Intro & Setup:** Getting started, install, config.
- **APIs:** Native JS/TS APIs, HTTP, Node.js APIs, FFI, system interfaces.
- **Bundler:** Features of integrated bundler.
- **CLI:** Package manager & utility commands.
- **Guides:** Extensive, categorized recipes for conversions, ecosystems, runtime control, I/O, process, testing, streaming etc.
- **Ecosystem:** Integration with popular frameworks.
- **Install & Package Internals:** Package management behavior.
- **Project:** Bun development, build, license, roadmap info.
- **Runtime:** Runtime configuration and supported APIs.
- **Testing:** Testing methodology and tools.
- **Contributing:** How to engage in Bun dev.
