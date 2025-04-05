Directory structure:
└── docs/
    ├── benchmarks.md
    ├── bun-flavored-toml.md
    ├── index.md
    ├── installation.md
    ├── nav.ts
    ├── quickstart.md
    ├── typescript.md
    ├── api/
    │   ├── binary-data.md
    │   ├── cc.md
    │   ├── color.md
    │   ├── console.md
    │   ├── cookie.md
    │   ├── dns.md
    │   ├── fetch.md
    │   ├── ffi.md
    │   ├── file-io.md
    │   ├── file-system-router.md
    │   ├── file.md
    │   ├── glob.md
    │   ├── globals.md
    │   ├── hashing.md
    │   ├── html-rewriter.md
    │   ├── http.md
    │   ├── import-meta.md
    │   ├── node-api.md
    │   ├── s3.md
    │   ├── semver.md
    │   ├── spawn.md
    │   ├── sql.md
    │   ├── sqlite.md
    │   ├── streams.md
    │   ├── tcp.md
    │   ├── test.md
    │   ├── transpiler.md
    │   ├── udp.md
    │   ├── utils.md
    │   ├── websockets.md
    │   └── workers.md
    ├── bundler/
    │   ├── css.md
    │   ├── css_modules.md
    │   ├── executables.md
    │   ├── fullstack.md
    │   ├── hmr.md
    │   ├── html.md
    │   ├── index.md
    │   ├── intro.md
    │   ├── loaders.md
    │   ├── macros.md
    │   ├── plugins.md
    │   └── vs-esbuild.md
    ├── cli/
    │   ├── add.md
    │   ├── bun-completions.md
    │   ├── bun-create.md
    │   ├── bun-install.md
    │   ├── bun-upgrade.md
    │   ├── bunx.md
    │   ├── filter.md
    │   ├── init.md
    │   ├── install.md
    │   ├── link.md
    │   ├── outdated.md
    │   ├── patch-commit.md
    │   ├── pm.md
    │   ├── publish.md
    │   ├── remove.md
    │   ├── run.md
    │   ├── test.md
    │   ├── unlink.md
    │   └── update.md
    ├── contributing/
    │   └── upgrading-webkit.md
    ├── ecosystem/
    │   ├── elysia.md
    │   ├── express.md
    │   ├── hono.md
    │   ├── react.md
    │   └── stric.md
    ├── guides/
    │   ├── binary/
    │   │   ├── arraybuffer-to-array.md
    │   │   ├── arraybuffer-to-blob.md
    │   │   ├── arraybuffer-to-buffer.md
    │   │   ├── arraybuffer-to-string.md
    │   │   ├── arraybuffer-to-typedarray.md
    │   │   ├── blob-to-arraybuffer.md
    │   │   ├── blob-to-dataview.md
    │   │   ├── blob-to-stream.md
    │   │   ├── blob-to-string.md
    │   │   ├── blob-to-typedarray.md
    │   │   ├── buffer-to-arraybuffer.md
    │   │   ├── buffer-to-blob.md
    │   │   ├── buffer-to-readablestream.md
    │   │   ├── buffer-to-string.md
    │   │   ├── buffer-to-typedarray.md
    │   │   ├── dataview-to-string.md
    │   │   ├── index.json
    │   │   ├── typedarray-to-arraybuffer.md
    │   │   ├── typedarray-to-blob.md
    │   │   ├── typedarray-to-buffer.md
    │   │   ├── typedarray-to-dataview.md
    │   │   ├── typedarray-to-readablestream.md
    │   │   └── typedarray-to-string.md
    │   ├── ecosystem/
    │   │   ├── astro.md
    │   │   ├── discordjs.md
    │   │   ├── docker.md
    │   │   ├── drizzle.md
    │   │   ├── edgedb.md
    │   │   ├── elysia.md
    │   │   ├── express.md
    │   │   ├── hono.md
    │   │   ├── index.json
    │   │   ├── mongoose.md
    │   │   ├── neon-drizzle.md
    │   │   ├── neon-serverless-postgres.md
    │   │   ├── nextjs.md
    │   │   ├── nuxt.md
    │   │   ├── pm2.md
    │   │   ├── prisma.md
    │   │   ├── qwik.md
    │   │   ├── react.md
    │   │   ├── remix.md
    │   │   ├── render.md
    │   │   ├── sentry.md
    │   │   ├── solidstart.md
    │   │   ├── ssr-react.md
    │   │   ├── stric.md
    │   │   ├── sveltekit.md
    │   │   ├── systemd.md
    │   │   └── vite.md
    │   ├── html-rewriter/
    │   │   ├── extract-links.md
    │   │   ├── extract-social-meta.md
    │   │   └── index.json
    │   ├── http/
    │   │   ├── cluster.md
    │   │   ├── fetch-unix.md
    │   │   ├── fetch.md
    │   │   ├── file-uploads.md
    │   │   ├── hot.md
    │   │   ├── index.json
    │   │   ├── proxy.md
    │   │   ├── server.md
    │   │   ├── simple.md
    │   │   ├── stream-file.md
    │   │   ├── stream-iterator.md
    │   │   ├── stream-node-streams-in-bun.md
    │   │   └── tls.md
    │   ├── install/
    │   │   ├── add-dev.md
    │   │   ├── add-git.md
    │   │   ├── add-optional.md
    │   │   ├── add-peer.md
    │   │   ├── add-tarball.md
    │   │   ├── add.md
    │   │   ├── azure-artifacts.md
    │   │   ├── cicd.md
    │   │   ├── custom-registry.md
    │   │   ├── from-npm-install-to-bun-install.md
    │   │   ├── git-diff-bun-lockfile.md
    │   │   ├── index.json
    │   │   ├── jfrog-artifactory.md
    │   │   ├── npm-alias.md
    │   │   ├── registry-scope.md
    │   │   ├── trusted.md
    │   │   ├── workspaces.md
    │   │   └── yarnlock.md
    │   ├── process/
    │   │   ├── argv.md
    │   │   ├── ctrl-c.md
    │   │   ├── index.json
    │   │   ├── ipc.md
    │   │   ├── nanoseconds.md
    │   │   ├── os-signals.md
    │   │   ├── spawn-stderr.md
    │   │   ├── spawn-stdout.md
    │   │   ├── spawn.md
    │   │   └── stdin.md
    │   ├── read-file/
    │   │   ├── arraybuffer.md
    │   │   ├── buffer.md
    │   │   ├── exists.md
    │   │   ├── index.json
    │   │   ├── json.md
    │   │   ├── mime.md
    │   │   ├── stream.md
    │   │   ├── string.md
    │   │   ├── uint8array.md
    │   │   └── watch.md
    │   ├── runtime/
    │   │   ├── cicd.md
    │   │   ├── codesign-macos-executable.md
    │   │   ├── define-constant.md
    │   │   ├── delete-directory.md
    │   │   ├── delete-file.md
    │   │   ├── heap-snapshot.md
    │   │   ├── import-html.md
    │   │   ├── import-json.md
    │   │   ├── import-toml.md
    │   │   ├── index.json
    │   │   ├── read-env.md
    │   │   ├── set-env.md
    │   │   ├── shell.md
    │   │   ├── timezone.md
    │   │   ├── tsconfig-paths.md
    │   │   ├── typescript.md
    │   │   ├── vscode-debugger.md
    │   │   └── web-debugger.md
    │   ├── streams/
    │   │   ├── index.json
    │   │   ├── node-readable-to-arraybuffer.md
    │   │   ├── node-readable-to-blob.md
    │   │   ├── node-readable-to-json.md
    │   │   ├── node-readable-to-string.md
    │   │   ├── node-readable-to-uint8array.md
    │   │   ├── to-array.md
    │   │   ├── to-arraybuffer.md
    │   │   ├── to-blob.md
    │   │   ├── to-buffer.md
    │   │   ├── to-json.md
    │   │   ├── to-string.md
    │   │   └── to-typedarray.md
    │   ├── test/
    │   │   ├── bail.md
    │   │   ├── coverage-threshold.md
    │   │   ├── coverage.md
    │   │   ├── happy-dom.md
    │   │   ├── index.json
    │   │   ├── migrate-from-jest.md
    │   │   ├── mock-clock.md
    │   │   ├── mock-functions.md
    │   │   ├── rerun-each.md
    │   │   ├── run-tests.md
    │   │   ├── skip-tests.md
    │   │   ├── snapshot.md
    │   │   ├── spy-on.md
    │   │   ├── svelte-test.md
    │   │   ├── testing-library.md
    │   │   ├── timeout.md
    │   │   ├── todo-tests.md
    │   │   ├── update-snapshots.md
    │   │   └── watch-mode.md
    │   ├── util/
    │   │   ├── base64.md
    │   │   ├── deep-equals.md
    │   │   ├── deflate.md
    │   │   ├── detect-bun.md
    │   │   ├── entrypoint.md
    │   │   ├── escape-html.md
    │   │   ├── file-url-to-path.md
    │   │   ├── gzip.md
    │   │   ├── hash-a-password.md
    │   │   ├── import-meta-dir.md
    │   │   ├── import-meta-file.md
    │   │   ├── import-meta-path.md
    │   │   ├── index.json
    │   │   ├── main.md
    │   │   ├── path-to-file-url.md
    │   │   ├── sleep.md
    │   │   ├── version.md
    │   │   └── which-path-to-executable-bin.md
    │   ├── websocket/
    │   │   ├── compression.md
    │   │   ├── context.md
    │   │   ├── index.json
    │   │   ├── pubsub.md
    │   │   └── simple.md
    │   └── write-file/
    │       ├── append.md
    │       ├── basic.md
    │       ├── blob.md
    │       ├── cat.md
    │       ├── file-cp.md
    │       ├── filesink.md
    │       ├── index.json
    │       ├── response.md
    │       ├── stdout.md
    │       ├── stream.md
    │       └── unlink.md
    ├── install/
    │   ├── cache.md
    │   ├── index.md
    │   ├── lifecycle.md
    │   ├── lockfile.md
    │   ├── npmrc.md
    │   ├── overrides.md
    │   ├── patch.md
    │   ├── registries.md
    │   └── workspaces.md
    ├── project/
    │   ├── benchmarking.md
    │   ├── bindgen.md
    │   ├── building-windows.md
    │   ├── roadmap.md
    │   ├── contributing.md -> CONTRIBUTING.md
    │   ├── internals/
    │   │   └── build-process-for-ci.md
    │   └── licensing.md -> LICENSE.md
    ├── runtime/
    │   ├── autoimport.md
    │   ├── bun-apis.md
    │   ├── bunfig.md
    │   ├── debugger.md
    │   ├── env.md
    │   ├── hot.md
    │   ├── index.md
    │   ├── jsx.md
    │   ├── loaders.md
    │   ├── modules.md
    │   ├── nodejs-apis.md
    │   ├── plugins.md
    │   ├── shell.md
    │   ├── typescript.md
    │   └── web-apis.md
    └── test/
        ├── configuration.md
        ├── coverage.md
        ├── discovery.md
        ├── dom.md
        ├── hot.md
        ├── lifecycle.md
        ├── mocks.md
        ├── reporters.md
        ├── runtime-behavior.md
        ├── snapshots.md
        ├── time.md
        └── writing.md
