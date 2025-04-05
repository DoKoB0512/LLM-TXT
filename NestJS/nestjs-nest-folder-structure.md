Directory structure:
└── nestjs-nest/
    ├── Readme.md
    ├── CODE_OF_CONDUCT.md
    ├── CONTRIBUTING.md
    ├── eslint.config.mjs
    ├── gulpfile.js
    ├── lerna.json
    ├── LICENSE
    ├── package.json
    ├── readme_jp.md
    ├── readme_kr.md
    ├── readme_zh.md
    ├── renovate.json
    ├── SECURITY.md
    ├── tsconfig.json
    ├── tsconfig.spec.json
    ├── .commitlintrc.json
    ├── .npmignore
    ├── .prettierignore
    ├── .prettierrc
    ├── benchmarks/
    │   ├── all_output.txt
    │   ├── express.js
    │   ├── fastify.js
    │   ├── nest-fastify.js
    │   ├── nest.js
    │   └── nest/
    │       ├── app.controller.d.ts
    │       ├── app.controller.js
    │       ├── app.module.d.ts
    │       ├── app.module.js
    │       └── main.d.ts
    ├── hooks/
    │   └── mocha-init-hook.ts
    ├── integration/
    │   ├── docker-compose.yml
    │   ├── mosquitto.conf
    │   ├── auto-mock/
    │   │   ├── tsconfig.json
    │   │   ├── src/
    │   │   │   ├── bar.service.ts
    │   │   │   └── foo.service.ts
    │   │   └── test/
    │   │       └── bar.service.spec.ts
    │   ├── cors/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── express.spec.ts
    │   │   │   └── fastify.spec.ts
    │   │   └── src/
    │   │       ├── app.controller.ts
    │   │       └── app.module.ts
    │   ├── discovery/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   └── discover-by-meta.spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── webhooks.explorer.ts
    │   │       ├── decorators/
    │   │       │   ├── non-applied.decorator.ts
    │   │       │   └── webhook.decorators.ts
    │   │       └── my-webhook/
    │   │           ├── cleanup.webhook.ts
    │   │           ├── flush.webhook.ts
    │   │           └── my-webhook.module.ts
    │   ├── graphql-code-first/
    │   │   ├── schema.gql
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── code-first.spec.ts
    │   │   │   ├── guards-filters.spec.ts
    │   │   │   └── pipes.spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── common/
    │   │       │   ├── filters/
    │   │       │   │   └── unauthorized.filter.ts
    │   │       │   ├── guards/
    │   │       │   │   └── auth.guard.ts
    │   │       │   ├── interceptors/
    │   │       │   │   └── data.interceptor.ts
    │   │       │   └── scalars/
    │   │       │       └── date.scalar.ts
    │   │       └── recipes/
    │   │           ├── recipes.module.ts
    │   │           ├── recipes.resolver.ts
    │   │           ├── recipes.service.ts
    │   │           ├── dto/
    │   │           │   ├── new-recipe.input.ts
    │   │           │   └── recipes.args.ts
    │   │           └── models/
    │   │               └── recipe.ts
    │   ├── graphql-schema-first/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── graphql-async-class.spec.ts
    │   │   │   ├── graphql-async-existing.spec.ts
    │   │   │   ├── graphql-async.spec.ts
    │   │   │   ├── graphql-request-scoped.spec.ts
    │   │   │   └── graphql.spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── async-options-class.module.ts
    │   │       ├── async-options-existing.module.ts
    │   │       ├── async-options.module.ts
    │   │       ├── config.module.ts
    │   │       ├── config.service.ts
    │   │       ├── main.ts
    │   │       ├── cats/
    │   │       │   ├── cats-request-scoped.service.ts
    │   │       │   ├── cats.guard.ts
    │   │       │   ├── cats.module.ts
    │   │       │   ├── cats.resolvers.ts
    │   │       │   ├── cats.service.ts
    │   │       │   ├── cats.types.graphql
    │   │       │   └── interfaces/
    │   │       │       └── cat.interface.ts
    │   │       └── common/
    │   │           └── scalars/
    │   │               └── date.scalar.ts
    │   ├── hello-world/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── exceptions.spec.ts
    │   │   │   ├── exclude-middleware-fastify.spec.ts
    │   │   │   ├── exclude-middleware.spec.ts
    │   │   │   ├── express-instance.spec.ts
    │   │   │   ├── express-multiple.spec.ts
    │   │   │   ├── fastify-adapter.spec.ts
    │   │   │   ├── fastify-multiple.spec.ts
    │   │   │   ├── guards.spec.ts
    │   │   │   ├── hello-world.spec.ts
    │   │   │   ├── interceptors.spec.ts
    │   │   │   ├── local-pipes.spec.ts
    │   │   │   ├── middleware-class.spec.ts
    │   │   │   ├── middleware-execute-order.spec.ts
    │   │   │   ├── middleware-fastify.spec.ts
    │   │   │   ├── middleware-run-match-route.ts
    │   │   │   ├── middleware-with-versioning.spec.ts
    │   │   │   ├── middleware.spec.ts
    │   │   │   ├── router-module-middleware.spec.ts
    │   │   │   └── router-module.spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── errors/
    │   │       │   └── errors.controller.ts
    │   │       ├── hello/
    │   │       │   ├── hello.controller.ts
    │   │       │   ├── hello.module.ts
    │   │       │   ├── hello.service.ts
    │   │       │   ├── dto/
    │   │       │   │   └── test.dto.ts
    │   │       │   └── users/
    │   │       │       ├── user-by-id.pipe.ts
    │   │       │       └── users.service.ts
    │   │       ├── host/
    │   │       │   ├── host.controller.ts
    │   │       │   ├── host.module.ts
    │   │       │   ├── host.service.ts
    │   │       │   ├── dto/
    │   │       │   │   └── test.dto.ts
    │   │       │   └── users/
    │   │       │       ├── user-by-id.pipe.ts
    │   │       │       └── users.service.ts
    │   │       └── host-array/
    │   │           ├── host-array.controller.ts
    │   │           ├── host-array.module.ts
    │   │           ├── host-array.service.ts
    │   │           ├── dto/
    │   │           │   └── test.dto.ts
    │   │           └── users/
    │   │               ├── user-by-id.pipe.ts
    │   │               └── users.service.ts
    │   ├── hooks/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── before-app-shutdown.spec.ts
    │   │   │   ├── enable-shutdown-hook.spec.ts
    │   │   │   ├── lifecycle-hook-order.spec.ts
    │   │   │   ├── on-app-boostrap.spec.ts
    │   │   │   ├── on-app-shutdown.spec.ts
    │   │   │   ├── on-module-destroy.spec.ts
    │   │   │   └── on-module-init.spec.ts
    │   │   └── src/
    │   │       └── enable-shutdown-hooks-main.ts
    │   ├── injector/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── circular-custom-providers.spec.ts
    │   │   │   ├── circular-modules.spec.ts
    │   │   │   ├── circular-property-injection.spec.ts
    │   │   │   ├── circular-structure-dynamic-modules.spec.ts
    │   │   │   ├── circular.spec.ts
    │   │   │   ├── core-injectables.spec.ts
    │   │   │   ├── default-values.spec.ts
    │   │   │   ├── injector.spec.ts
    │   │   │   ├── introspection.spec.ts
    │   │   │   ├── multiple-providers.spec.ts
    │   │   │   ├── optional-factory-provider-dep.spec.ts
    │   │   │   ├── property-injection.spec.ts
    │   │   │   └── scoped-instances.spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── circular/
    │   │       │   ├── circular.module.ts
    │   │       │   ├── circular.service.ts
    │   │       │   └── input.service.ts
    │   │       ├── circular-modules/
    │   │       │   ├── circular.module.ts
    │   │       │   ├── circular.service.ts
    │   │       │   ├── input.module.ts
    │   │       │   └── input.service.ts
    │   │       ├── circular-properties/
    │   │       │   ├── circular-properties.module.ts
    │   │       │   ├── circular.service.ts
    │   │       │   ├── input-properties.module.ts
    │   │       │   └── input.service.ts
    │   │       ├── circular-structure-dynamic-module/
    │   │       │   ├── circular.module.ts
    │   │       │   └── input.service.ts
    │   │       ├── core-injectables/
    │   │       │   └── core-injectables.module.ts
    │   │       ├── defaults/
    │   │       │   ├── core.service.ts
    │   │       │   ├── defaults.module.ts
    │   │       │   └── defaults.service.ts
    │   │       ├── dynamic/
    │   │       │   └── dynamic.module.ts
    │   │       ├── exports/
    │   │       │   ├── exports.module.ts
    │   │       │   └── exports.service.ts
    │   │       ├── inject/
    │   │       │   ├── core.service.ts
    │   │       │   ├── inject-same-name.module.ts
    │   │       │   ├── inject.module.ts
    │   │       │   └── inject.service.ts
    │   │       ├── multiple-providers/
    │   │       │   ├── a.module.ts
    │   │       │   ├── b.module.ts
    │   │       │   ├── c.module.ts
    │   │       │   └── multiple-providers.module.ts
    │   │       ├── properties/
    │   │       │   ├── dependency.service.ts
    │   │       │   ├── properties.module.ts
    │   │       │   └── properties.service.ts
    │   │       ├── scoped/
    │   │       │   ├── scoped.controller.ts
    │   │       │   ├── scoped.module.ts
    │   │       │   ├── scoped.service.ts
    │   │       │   ├── transient.service.ts
    │   │       │   ├── transient2.service.ts
    │   │       │   └── transient3.service.ts
    │   │       └── self-injection/
    │   │           └── self-injection-provider.module.ts
    │   ├── inspector/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── graph-inspector.spec.ts
    │   │   │   └── fixtures/
    │   │   │       ├── post-init-graph.json
    │   │   │       └── pre-init-graph.json
    │   │   └── src/
    │   │       ├── app-v1.controller.ts
    │   │       ├── app-v2.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── cats/
    │   │       │   ├── cats.controller.ts
    │   │       │   ├── cats.module.ts
    │   │       │   ├── cats.service.ts
    │   │       │   ├── dto/
    │   │       │   │   └── create-cat.dto.ts
    │   │       │   └── interfaces/
    │   │       │       └── cat.interface.ts
    │   │       ├── chat/
    │   │       │   ├── chat.gateway.ts
    │   │       │   ├── chat.module.ts
    │   │       │   ├── chat.service.ts
    │   │       │   ├── dto/
    │   │       │   │   ├── create-chat.dto.ts
    │   │       │   │   └── update-chat.dto.ts
    │   │       │   └── entities/
    │   │       │       └── chat.entity.ts
    │   │       ├── circular-hello/
    │   │       │   ├── hello.controller.ts
    │   │       │   ├── hello.module.ts
    │   │       │   ├── hello.service.ts
    │   │       │   ├── dto/
    │   │       │   │   └── test.dto.ts
    │   │       │   ├── guards/
    │   │       │   │   └── request-scoped.guard.ts
    │   │       │   ├── interceptors/
    │   │       │   │   └── logging.interceptor.ts
    │   │       │   └── users/
    │   │       │       ├── user-by-id.pipe.ts
    │   │       │       └── users.service.ts
    │   │       ├── circular-modules/
    │   │       │   ├── circular.module.ts
    │   │       │   ├── circular.service.ts
    │   │       │   ├── input.module.ts
    │   │       │   └── input.service.ts
    │   │       ├── common/
    │   │       │   ├── filters/
    │   │       │   │   └── http-exception.filter.ts
    │   │       │   ├── guards/
    │   │       │   │   └── roles.guard.ts
    │   │       │   ├── interceptors/
    │   │       │   │   └── timeout.interceptor.ts
    │   │       │   ├── middleware/
    │   │       │   │   └── logger.middleware.ts
    │   │       │   └── pipes/
    │   │       │       └── parse-int.pipe.ts
    │   │       ├── core/
    │   │       │   ├── core.module.ts
    │   │       │   └── interceptors/
    │   │       │       ├── logging.interceptor.ts
    │   │       │       └── transform.interceptor.ts
    │   │       ├── database/
    │   │       │   ├── database.controller.ts
    │   │       │   ├── database.module.ts
    │   │       │   ├── database.service.ts
    │   │       │   ├── dto/
    │   │       │   │   ├── create-database.dto.ts
    │   │       │   │   └── update-database.dto.ts
    │   │       │   └── entities/
    │   │       │       └── database.entity.ts
    │   │       ├── defaults/
    │   │       │   ├── core.service.ts
    │   │       │   ├── defaults.module.ts
    │   │       │   └── defaults.service.ts
    │   │       ├── dogs/
    │   │       │   ├── dogs.controller.ts
    │   │       │   ├── dogs.module.ts
    │   │       │   ├── dogs.service.ts
    │   │       │   ├── dto/
    │   │       │   │   ├── create-dog.dto.ts
    │   │       │   │   └── update-dog.dto.ts
    │   │       │   └── entities/
    │   │       │       └── dog.entity.ts
    │   │       ├── durable/
    │   │       │   ├── durable-context-id.strategy.ts
    │   │       │   ├── durable.controller.ts
    │   │       │   ├── durable.module.ts
    │   │       │   └── durable.service.ts
    │   │       ├── external-svc/
    │   │       │   ├── external-svc.controller.ts
    │   │       │   ├── external-svc.module.ts
    │   │       │   ├── external-svc.service.ts
    │   │       │   ├── dto/
    │   │       │   │   ├── create-external-svc.dto.ts
    │   │       │   │   └── update-external-svc.dto.ts
    │   │       │   └── entities/
    │   │       │       └── external-svc.entity.ts
    │   │       ├── properties/
    │   │       │   ├── dependency.service.ts
    │   │       │   ├── properties.module.ts
    │   │       │   └── properties.service.ts
    │   │       ├── request-chain/
    │   │       │   ├── request-chain.controller.ts
    │   │       │   ├── request-chain.module.ts
    │   │       │   ├── request-chain.service.ts
    │   │       │   ├── helper/
    │   │       │   │   ├── helper.module.ts
    │   │       │   │   └── helper.service.ts
    │   │       │   └── interceptors/
    │   │       │       └── logging.interceptor.ts
    │   │       └── users/
    │   │           ├── users.controller.ts
    │   │           ├── users.module.ts
    │   │           ├── users.service.ts
    │   │           ├── dto/
    │   │           │   ├── create-user.dto.ts
    │   │           │   └── update-user.dto.ts
    │   │           └── entities/
    │   │               └── user.entity.ts
    │   ├── lazy-modules/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── lazy-import-global-modules.spec.ts
    │   │   │   ├── lazy-import-request-providers.spec.ts
    │   │   │   └── lazy-import-transient-providers.spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── eager.module.ts
    │   │       ├── global.module.ts
    │   │       ├── lazy.controller.ts
    │   │       ├── lazy.module.ts
    │   │       ├── main.ts
    │   │       ├── request.module.ts
    │   │       ├── request.service.ts
    │   │       ├── transient.module.ts
    │   │       └── transient.service.ts
    │   ├── microservices/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── broadcast-mqtt.spec.ts
    │   │   │   ├── broadcast-nats.spec.ts
    │   │   │   ├── broadcast-redis.spec.ts
    │   │   │   ├── concurrent-kafka.spec.ts
    │   │   │   ├── disconnected-client.spec.ts
    │   │   │   ├── math-grpc.spec.ts
    │   │   │   ├── mqtt-record-builder.spec.ts
    │   │   │   ├── orders-grpc.spec.ts
    │   │   │   ├── sum-kafka.spec.ts
    │   │   │   ├── sum-mqtt.spec.ts
    │   │   │   ├── sum-nats.spec.ts
    │   │   │   ├── sum-redis.spec.ts
    │   │   │   ├── sum-rmq.spec.ts
    │   │   │   ├── sum-rpc-async.spec.ts
    │   │   │   ├── sum-rpc-tls.spec.ts
    │   │   │   └── sum-rpc.spec.ts
    │   │   └── src/
    │   │       ├── app.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── disconnected.controller.ts
    │   │       ├── main.ts
    │   │       ├── grpc/
    │   │       │   ├── grpc.controller.ts
    │   │       │   ├── math.proto
    │   │       │   └── math2.proto
    │   │       ├── grpc-advanced/
    │   │       │   ├── advanced.grpc.controller.ts
    │   │       │   └── proto/
    │   │       │       ├── root.proto
    │   │       │       ├── common/
    │   │       │       │   ├── item_types.proto
    │   │       │       │   └── shipment_types.proto
    │   │       │       └── orders/
    │   │       │           ├── message.proto
    │   │       │           └── service.proto
    │   │       ├── kafka/
    │   │       │   ├── kafka.controller.ts
    │   │       │   ├── kafka.messages.controller.ts
    │   │       │   ├── dtos/
    │   │       │   │   ├── business.dto.ts
    │   │       │   │   └── user.dto.ts
    │   │       │   └── entities/
    │   │       │       ├── business.entity.ts
    │   │       │       └── user.entity.ts
    │   │       ├── kafka-concurrent/
    │   │       │   ├── kafka-concurrent.controller.ts
    │   │       │   ├── kafka-concurrent.messages.controller.ts
    │   │       │   └── dto/
    │   │       │       └── sum.dto.ts
    │   │       ├── mqtt/
    │   │       │   ├── mqtt-broadcast.controller.ts
    │   │       │   └── mqtt.controller.ts
    │   │       ├── nats/
    │   │       │   ├── nats-broadcast.controller.ts
    │   │       │   ├── nats.controller.ts
    │   │       │   └── nats.service.ts
    │   │       ├── redis/
    │   │       │   ├── redis-broadcast.controller.ts
    │   │       │   └── redis.controller.ts
    │   │       ├── rmq/
    │   │       │   ├── rmq-broadcast.controller.ts
    │   │       │   └── rmq.controller.ts
    │   │       └── tcp-tls/
    │   │           ├── app.controller.ts
    │   │           ├── app.module.ts
    │   │           ├── ca.cert.pem
    │   │           └── privkey.pem
    │   ├── module-utils/
    │   │   ├── tsconfig.json
    │   │   ├── src/
    │   │   │   ├── integration.module-definition.ts
    │   │   │   ├── integration.module.ts
    │   │   │   └── interfaces/
    │   │   │       └── integration-module-options.interface.ts
    │   │   └── test/
    │   │       └── integration-module.spec.ts
    │   ├── mongoose/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── async-class-options.spec.ts
    │   │   │   ├── async-existing-options.spec.ts
    │   │   │   ├── async-options.spec.ts
    │   │   │   └── mongoose.spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── async-class-options.module.ts
    │   │       ├── async-existing-options.module.ts
    │   │       ├── async-options.module.ts
    │   │       ├── main.ts
    │   │       └── cats/
    │   │           ├── cats.controller.ts
    │   │           ├── cats.module.ts
    │   │           ├── cats.service.ts
    │   │           ├── dto/
    │   │           │   └── create-cat.dto.ts
    │   │           ├── interfaces/
    │   │           │   └── cat.interface.ts
    │   │           └── schemas/
    │   │               └── cat.schema.ts
    │   ├── nest-application/
    │   │   ├── app-locals/
    │   │   │   ├── tsconfig.json
    │   │   │   ├── e2e/
    │   │   │   │   └── express.spec.ts
    │   │   │   └── src/
    │   │   │       ├── app.controller.ts
    │   │   │       └── app.module.ts
    │   │   ├── get-url/
    │   │   │   ├── tsconfig.json
    │   │   │   ├── e2e/
    │   │   │   │   ├── express.spec.ts
    │   │   │   │   ├── fastify.spec.ts
    │   │   │   │   └── utils.ts
    │   │   │   └── src/
    │   │   │       ├── app.controller.ts
    │   │   │       ├── app.module.ts
    │   │   │       └── app.service.ts
    │   │   ├── global-prefix/
    │   │   │   ├── tsconfig.json
    │   │   │   ├── e2e/
    │   │   │   │   └── global-prefix.spec.ts
    │   │   │   └── src/
    │   │   │       ├── app.controller.ts
    │   │   │       └── app.module.ts
    │   │   ├── listen/
    │   │   │   ├── tsconfig.json
    │   │   │   ├── e2e/
    │   │   │   │   ├── express.spec.ts
    │   │   │   │   └── fastify.spec.ts
    │   │   │   └── src/
    │   │   │       ├── app.controller.ts
    │   │   │       ├── app.module.ts
    │   │   │       └── app.service.ts
    │   │   ├── raw-body/
    │   │   │   ├── tsconfig.json
    │   │   │   ├── e2e/
    │   │   │   │   ├── express.spec.ts
    │   │   │   │   └── fastify.spec.ts
    │   │   │   └── src/
    │   │   │       ├── express.controller.ts
    │   │   │       ├── express.module.ts
    │   │   │       ├── fastify.controller.ts
    │   │   │       └── fastify.module.ts
    │   │   ├── sse/
    │   │   │   ├── tsconfig.json
    │   │   │   ├── e2e/
    │   │   │   │   ├── express.spec.ts
    │   │   │   │   └── fastify.spec.ts
    │   │   │   └── src/
    │   │   │       ├── app.controller.ts
    │   │   │       └── app.module.ts
    │   │   └── use-body-parser/
    │   │       ├── tsconfig.json
    │   │       ├── e2e/
    │   │       │   ├── express.spec.ts
    │   │       │   └── fastify.spec.ts
    │   │       └── src/
    │   │           ├── app.controller.ts
    │   │           └── app.module.ts
    │   ├── repl/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   └── repl.spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       └── users/
    │   │           ├── users.controller.ts
    │   │           ├── users.module.ts
    │   │           ├── users.repository.ts
    │   │           ├── users.service.ts
    │   │           ├── dto/
    │   │           │   ├── create-user.dto.ts
    │   │           │   └── update-user.dto.ts
    │   │           └── entities/
    │   │               └── user.entity.ts
    │   ├── scopes/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── circular-request-scope.spec.ts
    │   │   │   ├── circular-transient-scope.spec.ts
    │   │   │   ├── durable-providers.spec.ts
    │   │   │   ├── inject-inquirer.spec.ts
    │   │   │   ├── msvc-request-scope.spec.ts
    │   │   │   ├── request-modules-scope.spec.ts
    │   │   │   ├── request-scope.spec.ts
    │   │   │   ├── resolve-scoped.spec.ts
    │   │   │   └── transient-scope.spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── circular-hello/
    │   │       │   ├── hello.controller.ts
    │   │       │   ├── hello.module.ts
    │   │       │   ├── hello.service.ts
    │   │       │   ├── dto/
    │   │       │   │   └── test.dto.ts
    │   │       │   ├── guards/
    │   │       │   │   └── request-scoped.guard.ts
    │   │       │   ├── interceptors/
    │   │       │   │   └── logging.interceptor.ts
    │   │       │   └── users/
    │   │       │       ├── user-by-id.pipe.ts
    │   │       │       └── users.service.ts
    │   │       ├── circular-transient/
    │   │       │   ├── hello.controller.ts
    │   │       │   ├── hello.module.ts
    │   │       │   ├── hello.service.ts
    │   │       │   ├── test.controller.ts
    │   │       │   ├── dto/
    │   │       │   │   └── test.dto.ts
    │   │       │   ├── guards/
    │   │       │   │   └── request-scoped.guard.ts
    │   │       │   ├── interceptors/
    │   │       │   │   └── logging.interceptor.ts
    │   │       │   └── users/
    │   │       │       ├── user-by-id.pipe.ts
    │   │       │       └── users.service.ts
    │   │       ├── durable/
    │   │       │   ├── durable-context-id.strategy.ts
    │   │       │   ├── durable.controller.ts
    │   │       │   ├── durable.guard.ts
    │   │       │   ├── durable.module.ts
    │   │       │   ├── durable.service.ts
    │   │       │   └── non-durable.service.ts
    │   │       ├── hello/
    │   │       │   ├── hello.controller.ts
    │   │       │   ├── hello.module.ts
    │   │       │   ├── hello.service.ts
    │   │       │   ├── dto/
    │   │       │   │   └── test.dto.ts
    │   │       │   ├── guards/
    │   │       │   │   └── request-scoped.guard.ts
    │   │       │   ├── interceptors/
    │   │       │   │   └── logging.interceptor.ts
    │   │       │   └── users/
    │   │       │       ├── user-by-id.pipe.ts
    │   │       │       └── users.service.ts
    │   │       ├── inject-inquirer/
    │   │       │   ├── hello.controller.ts
    │   │       │   ├── hello.module.ts
    │   │       │   ├── hello-request/
    │   │       │   │   ├── hello-request.service.ts
    │   │       │   │   └── request-logger.service.ts
    │   │       │   └── hello-transient/
    │   │       │       ├── hello-transient.service.ts
    │   │       │       └── transient-logger.service.ts
    │   │       ├── msvc/
    │   │       │   ├── hello.controller.ts
    │   │       │   ├── hello.module.ts
    │   │       │   ├── hello.service.ts
    │   │       │   ├── http.controller.ts
    │   │       │   ├── dto/
    │   │       │   │   └── test.dto.ts
    │   │       │   ├── guards/
    │   │       │   │   └── request-scoped.guard.ts
    │   │       │   ├── interceptors/
    │   │       │   │   └── logging.interceptor.ts
    │   │       │   └── users/
    │   │       │       └── users.service.ts
    │   │       ├── request-chain/
    │   │       │   ├── request-chain.controller.ts
    │   │       │   ├── request-chain.module.ts
    │   │       │   ├── request-chain.service.ts
    │   │       │   ├── helper/
    │   │       │   │   ├── helper.module.ts
    │   │       │   │   └── helper.service.ts
    │   │       │   └── interceptors/
    │   │       │       └── logging.interceptor.ts
    │   │       ├── resolve-scoped/
    │   │       │   ├── logger.provider.ts
    │   │       │   ├── logger.service.ts
    │   │       │   └── request-logger.service.ts
    │   │       └── transient/
    │   │           ├── hello.controller.ts
    │   │           ├── hello.module.ts
    │   │           ├── hello.service.ts
    │   │           ├── test.controller.ts
    │   │           ├── dto/
    │   │           │   └── test.dto.ts
    │   │           ├── guards/
    │   │           │   └── request-scoped.guard.ts
    │   │           ├── interceptors/
    │   │           │   └── logging.interceptor.ts
    │   │           └── users/
    │   │               ├── user-by-id.pipe.ts
    │   │               └── users.service.ts
    │   ├── send-files/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── express.spec.ts
    │   │   │   ├── fastify.spec.ts
    │   │   │   └── utils.ts
    │   │   └── src/
    │   │       ├── app.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── app.service.ts
    │   │       └── non-file.ts
    │   ├── testing-module-override/
    │   │   ├── tsconfig.json
    │   │   ├── circular-dependency/
    │   │   │   ├── a.module.ts
    │   │   │   └── b.module.ts
    │   │   └── e2e/
    │   │       └── modules-override.spec.ts
    │   ├── typeorm/
    │   │   ├── ormconfig.json
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── typeorm-async-class.spec.ts
    │   │   │   ├── typeorm-async-existing.spec.ts
    │   │   │   ├── typeorm-async-options.spec.ts
    │   │   │   ├── typeorm-async.spec.ts
    │   │   │   └── typeorm.spec.ts
    │   │   └── src/
    │   │       ├── app-async.module.ts
    │   │       ├── app.module.ts
    │   │       ├── async-class-options.module.ts
    │   │       ├── async-existing-options.module.ts
    │   │       ├── async-options.module.ts
    │   │       ├── database.module.ts
    │   │       ├── main.ts
    │   │       └── photo/
    │   │           ├── photo.controller.ts
    │   │           ├── photo.entity.ts
    │   │           ├── photo.module.ts
    │   │           └── photo.service.ts
    │   ├── versioning/
    │   │   ├── tsconfig.json
    │   │   ├── e2e/
    │   │   │   ├── custom-versioning-fastify.spec.ts
    │   │   │   ├── custom-versioning.spec.ts
    │   │   │   ├── default-versioning.spec.ts
    │   │   │   ├── header-versioning-fastify.spec.ts
    │   │   │   ├── header-versioning.spec.ts
    │   │   │   ├── media-type-versioning-fastify.spec.ts
    │   │   │   ├── media-type-versioning.spec.ts
    │   │   │   ├── uri-versioning-fastify.spec.ts
    │   │   │   └── uri-versioning.spec.ts
    │   │   └── src/
    │   │       ├── app-v1.controller.ts
    │   │       ├── app-v2.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── middleware.controller.ts
    │   │       ├── multiple-middleware.controller.ts
    │   │       ├── multiple.controller.ts
    │   │       ├── neutral-middleware.controller.ts
    │   │       ├── neutral.controller.ts
    │   │       ├── no-versioning.controller.ts
    │   │       ├── override-partial.controller.ts
    │   │       └── override.controller.ts
    │   └── websockets/
    │       ├── tsconfig.json
    │       ├── e2e/
    │       │   ├── error-gateway.spec.ts
    │       │   ├── gateway-ack.spec.ts
    │       │   ├── gateway.spec.ts
    │       │   └── ws-gateway.spec.ts
    │       └── src/
    │           ├── ack.gateway.ts
    │           ├── app.gateway.ts
    │           ├── app.module.ts
    │           ├── core.gateway.ts
    │           ├── error.gateway.ts
    │           ├── example-path.gateway.ts
    │           ├── namespace.gateway.ts
    │           ├── request.filter.ts
    │           ├── request.interceptor.ts
    │           ├── server.gateway.ts
    │           ├── ws-path.gateway.ts
    │           └── ws-path2.gateway.ts
    ├── packages/
    │   ├── tsconfig.build.json
    │   ├── tsconfig.json
    │   ├── common/
    │   │   ├── Readme.md
    │   │   ├── constants.ts
    │   │   ├── index.ts
    │   │   ├── package.json
    │   │   ├── PACKAGE.md
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── decorators/
    │   │   │   ├── index.ts
    │   │   │   ├── core/
    │   │   │   │   ├── apply-decorators.ts
    │   │   │   │   ├── bind.decorator.ts
    │   │   │   │   ├── catch.decorator.ts
    │   │   │   │   ├── controller.decorator.ts
    │   │   │   │   ├── dependencies.decorator.ts
    │   │   │   │   ├── exception-filters.decorator.ts
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── inject.decorator.ts
    │   │   │   │   ├── injectable.decorator.ts
    │   │   │   │   ├── optional.decorator.ts
    │   │   │   │   ├── set-metadata.decorator.ts
    │   │   │   │   ├── use-guards.decorator.ts
    │   │   │   │   ├── use-interceptors.decorator.ts
    │   │   │   │   ├── use-pipes.decorator.ts
    │   │   │   │   └── version.decorator.ts
    │   │   │   ├── http/
    │   │   │   │   ├── create-route-param-metadata.decorator.ts
    │   │   │   │   ├── header.decorator.ts
    │   │   │   │   ├── http-code.decorator.ts
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── redirect.decorator.ts
    │   │   │   │   ├── render.decorator.ts
    │   │   │   │   ├── request-mapping.decorator.ts
    │   │   │   │   ├── route-params.decorator.ts
    │   │   │   │   └── sse.decorator.ts
    │   │   │   └── modules/
    │   │   │       ├── global.decorator.ts
    │   │   │       ├── index.ts
    │   │   │       └── module.decorator.ts
    │   │   ├── enums/
    │   │   │   ├── http-status.enum.ts
    │   │   │   ├── index.ts
    │   │   │   ├── request-method.enum.ts
    │   │   │   ├── route-paramtypes.enum.ts
    │   │   │   ├── shutdown-signal.enum.ts
    │   │   │   └── version-type.enum.ts
    │   │   ├── exceptions/
    │   │   │   ├── bad-gateway.exception.ts
    │   │   │   ├── bad-request.exception.ts
    │   │   │   ├── conflict.exception.ts
    │   │   │   ├── forbidden.exception.ts
    │   │   │   ├── gateway-timeout.exception.ts
    │   │   │   ├── gone.exception.ts
    │   │   │   ├── http-version-not-supported.exception.ts
    │   │   │   ├── http.exception.ts
    │   │   │   ├── im-a-teapot.exception.ts
    │   │   │   ├── index.ts
    │   │   │   ├── internal-server-error.exception.ts
    │   │   │   ├── intrinsic.exception.ts
    │   │   │   ├── method-not-allowed.exception.ts
    │   │   │   ├── misdirected.exception.ts
    │   │   │   ├── not-acceptable.exception.ts
    │   │   │   ├── not-found.exception.ts
    │   │   │   ├── not-implemented.exception.ts
    │   │   │   ├── payload-too-large.exception.ts
    │   │   │   ├── precondition-failed.exception.ts
    │   │   │   ├── request-timeout.exception.ts
    │   │   │   ├── service-unavailable.exception.ts
    │   │   │   ├── unauthorized.exception.ts
    │   │   │   ├── unprocessable-entity.exception.ts
    │   │   │   └── unsupported-media-type.exception.ts
    │   │   ├── file-stream/
    │   │   │   ├── index.ts
    │   │   │   ├── streamable-file.ts
    │   │   │   └── interfaces/
    │   │   │       ├── index.ts
    │   │   │       ├── streamable-handler-response.interface.ts
    │   │   │       └── streamable-options.interface.ts
    │   │   ├── interfaces/
    │   │   │   ├── abstract.interface.ts
    │   │   │   ├── global-prefix-options.interface.ts
    │   │   │   ├── index.ts
    │   │   │   ├── injectable.interface.ts
    │   │   │   ├── nest-application-context-options.interface.ts
    │   │   │   ├── nest-application-context.interface.ts
    │   │   │   ├── nest-application-options.interface.ts
    │   │   │   ├── nest-application.interface.ts
    │   │   │   ├── nest-microservice.interface.ts
    │   │   │   ├── scope-options.interface.ts
    │   │   │   ├── type.interface.ts
    │   │   │   ├── version-options.interface.ts
    │   │   │   ├── controllers/
    │   │   │   │   ├── controller-metadata.interface.ts
    │   │   │   │   ├── controller.interface.ts
    │   │   │   │   └── index.ts
    │   │   │   ├── exceptions/
    │   │   │   │   ├── exception-filter-metadata.interface.ts
    │   │   │   │   ├── exception-filter.interface.ts
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── rpc-exception-filter-metadata.interface.ts
    │   │   │   │   ├── rpc-exception-filter.interface.ts
    │   │   │   │   └── ws-exception-filter.interface.ts
    │   │   │   ├── external/
    │   │   │   │   ├── class-transform-options.interface.ts
    │   │   │   │   ├── cors-options.interface.ts
    │   │   │   │   ├── https-options.interface.ts
    │   │   │   │   ├── transformer-package.interface.ts
    │   │   │   │   ├── validation-error.interface.ts
    │   │   │   │   ├── validator-options.interface.ts
    │   │   │   │   └── validator-package.interface.ts
    │   │   │   ├── features/
    │   │   │   │   ├── arguments-host.interface.ts
    │   │   │   │   ├── can-activate.interface.ts
    │   │   │   │   ├── custom-route-param-factory.interface.ts
    │   │   │   │   ├── execution-context.interface.ts
    │   │   │   │   ├── nest-interceptor.interface.ts
    │   │   │   │   ├── paramtype.interface.ts
    │   │   │   │   └── pipe-transform.interface.ts
    │   │   │   ├── hooks/
    │   │   │   │   ├── before-application-shutdown.interface.ts
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── on-application-bootstrap.interface.ts
    │   │   │   │   ├── on-application-shutdown.interface.ts
    │   │   │   │   ├── on-destroy.interface.ts
    │   │   │   │   └── on-init.interface.ts
    │   │   │   ├── http/
    │   │   │   │   ├── http-exception-body.interface.ts
    │   │   │   │   ├── http-redirect-response.interface.ts
    │   │   │   │   ├── http-server.interface.ts
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── message-event.interface.ts
    │   │   │   │   └── raw-body-request.interface.ts
    │   │   │   ├── microservices/
    │   │   │   │   ├── nest-hybrid-application-options.interface.ts
    │   │   │   │   └── nest-microservice-options.interface.ts
    │   │   │   ├── middleware/
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── middleware-config-proxy.interface.ts
    │   │   │   │   ├── middleware-configuration.interface.ts
    │   │   │   │   ├── middleware-consumer.interface.ts
    │   │   │   │   └── nest-middleware.interface.ts
    │   │   │   ├── modules/
    │   │   │   │   ├── dynamic-module.interface.ts
    │   │   │   │   ├── forward-reference.interface.ts
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── injection-token.interface.ts
    │   │   │   │   ├── introspection-result.interface.ts
    │   │   │   │   ├── module-metadata.interface.ts
    │   │   │   │   ├── nest-module.interface.ts
    │   │   │   │   ├── optional-factory-dependency.interface.ts
    │   │   │   │   └── provider.interface.ts
    │   │   │   └── websockets/
    │   │   │       └── web-socket-adapter.interface.ts
    │   │   ├── module-utils/
    │   │   │   ├── configurable-module.builder.ts
    │   │   │   ├── constants.ts
    │   │   │   ├── index.ts
    │   │   │   ├── interfaces/
    │   │   │   │   ├── configurable-module-async-options.interface.ts
    │   │   │   │   ├── configurable-module-cls.interface.ts
    │   │   │   │   ├── configurable-module-host.interface.ts
    │   │   │   │   └── index.ts
    │   │   │   └── utils/
    │   │   │       ├── generate-options-injection-token.util.ts
    │   │   │       ├── get-injection-providers.util.ts
    │   │   │       └── index.ts
    │   │   ├── pipes/
    │   │   │   ├── default-value.pipe.ts
    │   │   │   ├── index.ts
    │   │   │   ├── parse-array.pipe.ts
    │   │   │   ├── parse-bool.pipe.ts
    │   │   │   ├── parse-date.pipe.ts
    │   │   │   ├── parse-enum.pipe.ts
    │   │   │   ├── parse-float.pipe.ts
    │   │   │   ├── parse-int.pipe.ts
    │   │   │   ├── parse-uuid.pipe.ts
    │   │   │   ├── validation.pipe.ts
    │   │   │   └── file/
    │   │   │       ├── file-type.validator.ts
    │   │   │       ├── file-validator.interface.ts
    │   │   │       ├── index.ts
    │   │   │       ├── max-file-size.validator.ts
    │   │   │       ├── parse-file-options.interface.ts
    │   │   │       ├── parse-file-pipe.builder.ts
    │   │   │       ├── parse-file.pipe.ts
    │   │   │       └── interfaces/
    │   │   │           ├── file.interface.ts
    │   │   │           └── index.ts
    │   │   ├── serializer/
    │   │   │   ├── class-serializer.constants.ts
    │   │   │   ├── class-serializer.interceptor.ts
    │   │   │   ├── class-serializer.interfaces.ts
    │   │   │   ├── index.ts
    │   │   │   └── decorators/
    │   │   │       ├── index.ts
    │   │   │       └── serialize-options.decorator.ts
    │   │   ├── services/
    │   │   │   ├── console-logger.service.ts
    │   │   │   ├── index.ts
    │   │   │   ├── logger.service.ts
    │   │   │   └── utils/
    │   │   │       ├── index.ts
    │   │   │       └── is-log-level-enabled.util.ts
    │   │   ├── test/
    │   │   │   ├── tsconfig.json
    │   │   │   ├── decorators/
    │   │   │   │   ├── apply-decorators.spec.ts
    │   │   │   │   ├── bind.decorator.spec.ts
    │   │   │   │   ├── catch.decorator.spec.ts
    │   │   │   │   ├── controller.decorator.spec.ts
    │   │   │   │   ├── create-param-decorator.spec.ts
    │   │   │   │   ├── dependencies.decorator.spec.ts
    │   │   │   │   ├── exception-filters.decorator.spec.ts
    │   │   │   │   ├── global.decorator.spec.ts
    │   │   │   │   ├── header.decorator.spec.ts
    │   │   │   │   ├── http-code.decorator.spec.ts
    │   │   │   │   ├── inject.decorator.spec.ts
    │   │   │   │   ├── injectable.decorator.spec.ts
    │   │   │   │   ├── module.decorator.spec.ts
    │   │   │   │   ├── redirect.decorator.spec.ts
    │   │   │   │   ├── render.decorator.spec.ts
    │   │   │   │   ├── request-mapping.decorator.spec.ts
    │   │   │   │   ├── route-params.decorator.spec.ts
    │   │   │   │   ├── set-metadata.decorator.spec.ts
    │   │   │   │   ├── sse.decorator.spec.ts
    │   │   │   │   ├── use-guards.decorator.spec.ts
    │   │   │   │   ├── use-interceptors.decorator.spec.ts
    │   │   │   │   ├── use-pipes.decorator.spec.ts
    │   │   │   │   └── version.decorator.spec.ts
    │   │   │   ├── exceptions/
    │   │   │   │   └── http.exception.spec.ts
    │   │   │   ├── file-stream/
    │   │   │   │   └── streamable-file.spec.ts
    │   │   │   ├── module-utils/
    │   │   │   │   ├── configurable-module.builder.spec.ts
    │   │   │   │   └── utils/
    │   │   │   │       └── get-injection-providers.util.spec.ts
    │   │   │   ├── pipes/
    │   │   │   │   ├── default-value.pipe.spec.ts
    │   │   │   │   ├── parse-array.pipe.spec.ts
    │   │   │   │   ├── parse-bool.pipe.spec.ts
    │   │   │   │   ├── parse-date.pipe.spec.ts
    │   │   │   │   ├── parse-enum.pipe.spec.ts
    │   │   │   │   ├── parse-float.pipe.spec.ts
    │   │   │   │   ├── parse-int.pipe.spec.ts
    │   │   │   │   ├── parse-uuid.pipe.spec.ts
    │   │   │   │   ├── validation.pipe.spec.ts
    │   │   │   │   └── file/
    │   │   │   │       ├── file-type.validator.spec.ts
    │   │   │   │       ├── max-file-size.validator.spec.ts
    │   │   │   │       ├── parse-file-pipe.builder.spec.ts
    │   │   │   │       └── parse-file.pipe.spec.ts
    │   │   │   ├── services/
    │   │   │   │   ├── logger.service.spec.ts
    │   │   │   │   └── utils/
    │   │   │   │       └── is-log-level-enabled.util.spec.ts
    │   │   │   └── utils/
    │   │   │       ├── forward-ref.util.spec.ts
    │   │   │       ├── load-package.util.spec.ts
    │   │   │       ├── merge-with-values.util.spec.ts
    │   │   │       ├── random-string-generator.util.spec.ts
    │   │   │       ├── select-exception-filter-metadata.util.spec.ts
    │   │   │       ├── shared.utils.spec.ts
    │   │   │       └── validate-each.util.spec.ts
    │   │   └── utils/
    │   │       ├── assign-custom-metadata.util.ts
    │   │       ├── cli-colors.util.ts
    │   │       ├── extend-metadata.util.ts
    │   │       ├── forward-ref.util.ts
    │   │       ├── http-error-by-code.util.ts
    │   │       ├── index.ts
    │   │       ├── load-package.util.ts
    │   │       ├── merge-with-values.util.ts
    │   │       ├── random-string-generator.util.ts
    │   │       ├── select-exception-filter-metadata.util.ts
    │   │       ├── shared.utils.ts
    │   │       ├── validate-each.util.ts
    │   │       └── validate-module-keys.util.ts
    │   ├── core/
    │   │   ├── Readme.md
    │   │   ├── application-config.ts
    │   │   ├── constants.ts
    │   │   ├── index.ts
    │   │   ├── metadata-scanner.ts
    │   │   ├── nest-application-context.ts
    │   │   ├── nest-application.ts
    │   │   ├── nest-factory.ts
    │   │   ├── package.json
    │   │   ├── PACKAGE.md
    │   │   ├── scanner.ts
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── adapters/
    │   │   │   ├── http-adapter.ts
    │   │   │   └── index.ts
    │   │   ├── discovery/
    │   │   │   ├── discoverable-meta-host-collection.ts
    │   │   │   ├── discovery-module.ts
    │   │   │   ├── discovery-service.ts
    │   │   │   └── index.ts
    │   │   ├── errors/
    │   │   │   ├── exception-handler.ts
    │   │   │   ├── exceptions-zone.ts
    │   │   │   ├── messages.ts
    │   │   │   └── exceptions/
    │   │   │       ├── circular-dependency.exception.ts
    │   │   │       ├── index.ts
    │   │   │       ├── invalid-class-module.exception.ts
    │   │   │       ├── invalid-class-scope.exception.ts
    │   │   │       ├── invalid-class.exception.ts
    │   │   │       ├── invalid-exception-filter.exception.ts
    │   │   │       ├── invalid-middleware-configuration.exception.ts
    │   │   │       ├── invalid-middleware.exception.ts
    │   │   │       ├── invalid-module.exception.ts
    │   │   │       ├── runtime.exception.ts
    │   │   │       ├── undefined-dependency.exception.ts
    │   │   │       ├── undefined-forwardref.exception.ts
    │   │   │       ├── undefined-module.exception.ts
    │   │   │       ├── unknown-dependencies.exception.ts
    │   │   │       ├── unknown-element.exception.ts
    │   │   │       ├── unknown-export.exception.ts
    │   │   │       ├── unknown-module.exception.ts
    │   │   │       └── unknown-request-mapping.exception.ts
    │   │   ├── exceptions/
    │   │   │   ├── base-exception-filter-context.ts
    │   │   │   ├── base-exception-filter.ts
    │   │   │   ├── exceptions-handler.ts
    │   │   │   ├── external-exception-filter-context.ts
    │   │   │   ├── external-exception-filter.ts
    │   │   │   ├── external-exceptions-handler.ts
    │   │   │   └── index.ts
    │   │   ├── guards/
    │   │   │   ├── constants.ts
    │   │   │   ├── guards-consumer.ts
    │   │   │   ├── guards-context-creator.ts
    │   │   │   └── index.ts
    │   │   ├── helpers/
    │   │   │   ├── context-creator.ts
    │   │   │   ├── context-id-factory.ts
    │   │   │   ├── context-utils.ts
    │   │   │   ├── execution-context-host.ts
    │   │   │   ├── external-context-creator.ts
    │   │   │   ├── external-proxy.ts
    │   │   │   ├── get-class-scope.ts
    │   │   │   ├── handler-metadata-storage.ts
    │   │   │   ├── http-adapter-host.ts
    │   │   │   ├── index.ts
    │   │   │   ├── is-durable.ts
    │   │   │   ├── load-adapter.ts
    │   │   │   ├── messages.ts
    │   │   │   ├── optional-require.ts
    │   │   │   ├── rethrow.ts
    │   │   │   ├── router-method-factory.ts
    │   │   │   └── interfaces/
    │   │   │       ├── external-handler-metadata.interface.ts
    │   │   │       ├── index.ts
    │   │   │       └── params-metadata.interface.ts
    │   │   ├── hooks/
    │   │   │   ├── before-app-shutdown.hook.ts
    │   │   │   ├── index.ts
    │   │   │   ├── on-app-bootstrap.hook.ts
    │   │   │   ├── on-app-shutdown.hook.ts
    │   │   │   ├── on-module-destroy.hook.ts
    │   │   │   └── on-module-init.hook.ts
    │   │   ├── injector/
    │   │   │   ├── abstract-instance-resolver.ts
    │   │   │   ├── compiler.ts
    │   │   │   ├── constants.ts
    │   │   │   ├── container.ts
    │   │   │   ├── index.ts
    │   │   │   ├── injector.ts
    │   │   │   ├── instance-links-host.ts
    │   │   │   ├── instance-loader.ts
    │   │   │   ├── instance-wrapper.ts
    │   │   │   ├── internal-providers-storage.ts
    │   │   │   ├── module-ref.ts
    │   │   │   ├── module.ts
    │   │   │   ├── modules-container.ts
    │   │   │   ├── settlement-signal.ts
    │   │   │   ├── helpers/
    │   │   │   │   ├── provider-classifier.ts
    │   │   │   │   ├── silent-logger.ts
    │   │   │   │   └── transient-instances.ts
    │   │   │   ├── inquirer/
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── inquirer-constants.ts
    │   │   │   │   └── inquirer-providers.ts
    │   │   │   ├── internal-core-module/
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── internal-core-module-factory.ts
    │   │   │   │   └── internal-core-module.ts
    │   │   │   ├── lazy-module-loader/
    │   │   │   │   ├── lazy-module-loader-options.interface.ts
    │   │   │   │   └── lazy-module-loader.ts
    │   │   │   ├── opaque-key-factory/
    │   │   │   │   ├── by-reference-module-opaque-key-factory.ts
    │   │   │   │   ├── deep-hashed-module-opaque-key-factory.ts
    │   │   │   │   └── interfaces/
    │   │   │   │       └── module-opaque-key-factory.interface.ts
    │   │   │   └── topology-tree/
    │   │   │       ├── topology-tree.ts
    │   │   │       └── tree-node.ts
    │   │   ├── inspector/
    │   │   │   ├── deterministic-uuid-registry.ts
    │   │   │   ├── graph-inspector.ts
    │   │   │   ├── index.ts
    │   │   │   ├── initialize-on-preview.allowlist.ts
    │   │   │   ├── noop-graph-inspector.ts
    │   │   │   ├── partial-graph.host.ts
    │   │   │   ├── serialized-graph.ts
    │   │   │   ├── uuid-factory.ts
    │   │   │   └── interfaces/
    │   │   │       ├── edge.interface.ts
    │   │   │       ├── enhancer-metadata-cache-entry.interface.ts
    │   │   │       ├── entrypoint.interface.ts
    │   │   │       ├── extras.interface.ts
    │   │   │       ├── node.interface.ts
    │   │   │       ├── serialized-graph-json.interface.ts
    │   │   │       └── serialized-graph-metadata.interface.ts
    │   │   ├── interceptors/
    │   │   │   ├── index.ts
    │   │   │   ├── interceptors-consumer.ts
    │   │   │   └── interceptors-context-creator.ts
    │   │   ├── interfaces/
    │   │   │   ├── module-definition.interface.ts
    │   │   │   └── module-override.interface.ts
    │   │   ├── middleware/
    │   │   │   ├── builder.ts
    │   │   │   ├── container.ts
    │   │   │   ├── index.ts
    │   │   │   ├── middleware-module.ts
    │   │   │   ├── resolver.ts
    │   │   │   ├── route-info-path-extractor.ts
    │   │   │   ├── routes-mapper.ts
    │   │   │   └── utils.ts
    │   │   ├── pipes/
    │   │   │   ├── index.ts
    │   │   │   ├── params-token-factory.ts
    │   │   │   ├── pipes-consumer.ts
    │   │   │   └── pipes-context-creator.ts
    │   │   ├── repl/
    │   │   │   ├── assign-to-object.util.ts
    │   │   │   ├── constants.ts
    │   │   │   ├── index.ts
    │   │   │   ├── repl-context.ts
    │   │   │   ├── repl-function.ts
    │   │   │   ├── repl-logger.ts
    │   │   │   ├── repl-native-commands.ts
    │   │   │   ├── repl.interfaces.ts
    │   │   │   ├── repl.ts
    │   │   │   └── native-functions/
    │   │   │       ├── debug-repl-fn.ts
    │   │   │       ├── get-relp-fn.ts
    │   │   │       ├── help-repl-fn.ts
    │   │   │       ├── index.ts
    │   │   │       ├── methods-repl-fn.ts
    │   │   │       ├── resolve-repl-fn.ts
    │   │   │       └── select-relp-fn.ts
    │   │   ├── router/
    │   │   │   ├── index.ts
    │   │   │   ├── legacy-route-converter.ts
    │   │   │   ├── paths-explorer.ts
    │   │   │   ├── route-params-factory.ts
    │   │   │   ├── route-path-factory.ts
    │   │   │   ├── router-exception-filters.ts
    │   │   │   ├── router-execution-context.ts
    │   │   │   ├── router-explorer.ts
    │   │   │   ├── router-module.ts
    │   │   │   ├── router-proxy.ts
    │   │   │   ├── router-response-controller.ts
    │   │   │   ├── routes-resolver.ts
    │   │   │   ├── sse-stream.ts
    │   │   │   ├── interfaces/
    │   │   │   │   ├── exceptions-filter.interface.ts
    │   │   │   │   ├── exclude-route-metadata.interface.ts
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── resolver.interface.ts
    │   │   │   │   ├── route-params-factory.interface.ts
    │   │   │   │   ├── route-path-metadata.interface.ts
    │   │   │   │   └── routes.interface.ts
    │   │   │   ├── request/
    │   │   │   │   ├── index.ts
    │   │   │   │   ├── request-constants.ts
    │   │   │   │   └── request-providers.ts
    │   │   │   └── utils/
    │   │   │       ├── exclude-route.util.ts
    │   │   │       ├── flatten-route-paths.util.ts
    │   │   │       └── index.ts
    │   │   ├── services/
    │   │   │   ├── index.ts
    │   │   │   └── reflector.service.ts
    │   │   └── test/
    │   │       ├── application-config.spec.ts
    │   │       ├── metadata-scanner.spec.ts
    │   │       ├── nest-application-context.spec.ts
    │   │       ├── nest-application.spec.ts
    │   │       ├── scanner.spec.ts
    │   │       ├── tsconfig.json
    │   │       ├── errors/
    │   │       │   └── test/
    │   │       │       ├── exception-handler.spec.ts
    │   │       │       ├── exceptions-zone.spec.ts
    │   │       │       └── messages.spec.ts
    │   │       ├── exceptions/
    │   │       │   ├── base-exception-filter.spec.ts
    │   │       │   ├── exceptions-handler.spec.ts
    │   │       │   ├── external-exception-filter-context.spec.ts
    │   │       │   └── external-exceptions-handler.spec.ts
    │   │       ├── guards/
    │   │       │   ├── guards-consumer.spec.ts
    │   │       │   └── guards-context-creator.spec.ts
    │   │       ├── helpers/
    │   │       │   ├── application-ref-host.spec.ts
    │   │       │   ├── context-id-factory.spec.ts
    │   │       │   ├── context-utils.spec.ts
    │   │       │   ├── execution-context-host.spec.ts
    │   │       │   ├── external-context-creator.spec.ts
    │   │       │   ├── external-proxy.spec.ts
    │   │       │   └── router-method-factory.spec.ts
    │   │       ├── hooks/
    │   │       │   ├── before-app-shutdown.hook.spec.ts
    │   │       │   ├── on-app-bootstrap.hook.spec.ts
    │   │       │   ├── on-app-shutdown.hook.spec.ts
    │   │       │   ├── on-module-destroy.hook.spec.ts
    │   │       │   └── on-module-init.hook.spec.ts
    │   │       ├── injector/
    │   │       │   ├── compiler.spec.ts
    │   │       │   ├── container.spec.ts
    │   │       │   ├── injector.spec.ts
    │   │       │   ├── instance-loader.spec.ts
    │   │       │   ├── instance-wrapper.spec.ts
    │   │       │   ├── module.spec.ts
    │   │       │   ├── helpers/
    │   │       │   │   └── provider-classifier.spec.ts
    │   │       │   ├── internal-core-module/
    │   │       │   │   └── internal-core-module-factory.spec.ts
    │   │       │   ├── lazy-module-loader/
    │   │       │   │   └── lazy-module-loader.spec.ts
    │   │       │   └── opaque-key-factory/
    │   │       │       ├── by-reference-module-opaque-key-factory.spec.ts
    │   │       │       └── deep-hashed-module-opaque-key-factory.spec.ts
    │   │       ├── inspector/
    │   │       │   ├── graph-inspector.spec.ts
    │   │       │   └── serialized-graph.spec.ts
    │   │       ├── interceptors/
    │   │       │   ├── interceptors-consumer.spec.ts
    │   │       │   └── interceptors-context-creator.spec.ts
    │   │       ├── middleware/
    │   │       │   ├── builder.spec.ts
    │   │       │   ├── container.spec.ts
    │   │       │   ├── middleware-module.spec.ts
    │   │       │   ├── resolver.spec.ts
    │   │       │   ├── route-info-path-extractor.spec.ts
    │   │       │   ├── routes-mapper.spec.ts
    │   │       │   └── utils.spec.ts
    │   │       ├── pipes/
    │   │       │   ├── params-token-factory.spec.ts
    │   │       │   ├── pipes-consumer.spec.ts
    │   │       │   └── pipes-context-creator.spec.ts
    │   │       ├── repl/
    │   │       │   ├── assign-to-object.util.spec.ts
    │   │       │   ├── repl-context.spec.ts
    │   │       │   └── native-functions/
    │   │       │       ├── debug-repl-fn.spec.ts
    │   │       │       ├── get-repl-fn.spec.ts
    │   │       │       ├── help-repl-fn.spec.ts
    │   │       │       ├── methods-repl-fn.spec.ts
    │   │       │       ├── resolve-repl-fn.spec.ts
    │   │       │       └── select-repl-fn.spec.ts
    │   │       ├── router/
    │   │       │   ├── paths-explorer.spec.ts
    │   │       │   ├── route-params-factory.spec.ts
    │   │       │   ├── route-path-factory.spec.ts
    │   │       │   ├── router-exception-filters.spec.ts
    │   │       │   ├── router-execution-context.spec.ts
    │   │       │   ├── router-explorer.spec.ts
    │   │       │   ├── router-module.spec.ts
    │   │       │   ├── router-proxy.spec.ts
    │   │       │   ├── router-response-controller.spec.ts
    │   │       │   ├── routes-resolver.spec.ts
    │   │       │   ├── sse-stream.spec.ts
    │   │       │   └── utils/
    │   │       │       └── flat-routes.spec.ts
    │   │       ├── services/
    │   │       │   └── reflector.service.spec.ts
    │   │       └── utils/
    │   │           ├── noop-adapter.spec.ts
    │   │           └── string.cleaner.ts
    │   ├── microservices/
    │   │   ├── Readme.md
    │   │   ├── constants.ts
    │   │   ├── container.ts
    │   │   ├── index.ts
    │   │   ├── listener-metadata-explorer.ts
    │   │   ├── listeners-controller.ts
    │   │   ├── microservices-module.ts
    │   │   ├── nest-microservice.ts
    │   │   ├── package.json
    │   │   ├── tokens.ts
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── client/
    │   │   │   ├── client-grpc.ts
    │   │   │   ├── client-kafka.ts
    │   │   │   ├── client-mqtt.ts
    │   │   │   ├── client-nats.ts
    │   │   │   ├── client-proxy-factory.ts
    │   │   │   ├── client-proxy.ts
    │   │   │   ├── client-redis.ts
    │   │   │   ├── client-rmq.ts
    │   │   │   ├── client-tcp.ts
    │   │   │   └── index.ts
    │   │   ├── context/
    │   │   │   ├── exception-filters-context.ts
    │   │   │   ├── request-context-host.ts
    │   │   │   ├── rpc-context-creator.ts
    │   │   │   ├── rpc-metadata-constants.ts
    │   │   │   └── rpc-proxy.ts
    │   │   ├── ctx-host/
    │   │   │   ├── base-rpc.context.ts
    │   │   │   ├── index.ts
    │   │   │   ├── kafka.context.ts
    │   │   │   ├── mqtt.context.ts
    │   │   │   ├── nats.context.ts
    │   │   │   ├── redis.context.ts
    │   │   │   ├── rmq.context.ts
    │   │   │   └── tcp.context.ts
    │   │   ├── decorators/
    │   │   │   ├── client.decorator.ts
    │   │   │   ├── ctx.decorator.ts
    │   │   │   ├── event-pattern.decorator.ts
    │   │   │   ├── grpc-service.decorator.ts
    │   │   │   ├── index.ts
    │   │   │   ├── message-pattern.decorator.ts
    │   │   │   └── payload.decorator.ts
    │   │   ├── deserializers/
    │   │   │   ├── identity.deserializer.ts
    │   │   │   ├── incoming-request.deserializer.ts
    │   │   │   ├── incoming-response.deserializer.ts
    │   │   │   ├── index.ts
    │   │   │   ├── kafka-request.deserializer.ts
    │   │   │   ├── kafka-response.deserializer.ts
    │   │   │   ├── nats-request-json.deserializer.ts
    │   │   │   └── nats-response-json.deserializer.ts
    │   │   ├── enums/
    │   │   │   ├── index.ts
    │   │   │   ├── kafka-headers.enum.ts
    │   │   │   ├── pattern-handler.enum.ts
    │   │   │   ├── rpc-paramtype.enum.ts
    │   │   │   └── transport.enum.ts
    │   │   ├── errors/
    │   │   │   ├── corrupted-packet-length.exception.ts
    │   │   │   ├── empty-response.exception.ts
    │   │   │   ├── invalid-grpc-message-decorator.exception.ts
    │   │   │   ├── invalid-grpc-package-definition-missing-package-definition.exception.ts
    │   │   │   ├── invalid-grpc-package-definition-mutex.exception.ts
    │   │   │   ├── invalid-grpc-package.exception.ts
    │   │   │   ├── invalid-grpc-service.exception.ts
    │   │   │   ├── invalid-json-format.exception.ts
    │   │   │   ├── invalid-kafka-client-topic.exception.ts
    │   │   │   ├── invalid-message.exception.ts
    │   │   │   ├── invalid-proto-definition.exception.ts
    │   │   │   ├── max-packet-length-exceeded.exception.ts
    │   │   │   └── net-socket-closed.exception.ts
    │   │   ├── events/
    │   │   │   ├── index.ts
    │   │   │   ├── kafka.events.ts
    │   │   │   ├── mqtt.events.ts
    │   │   │   ├── nats.events.ts
    │   │   │   ├── redis.events.ts
    │   │   │   ├── rmq.events.ts
    │   │   │   └── tcp.events.ts
    │   │   ├── exceptions/
    │   │   │   ├── base-rpc-exception-filter.ts
    │   │   │   ├── index.ts
    │   │   │   ├── kafka-retriable-exception.ts
    │   │   │   ├── rpc-exception.ts
    │   │   │   └── rpc-exceptions-handler.ts
    │   │   ├── external/
    │   │   │   ├── grpc-options.interface.ts
    │   │   │   ├── kafka.interface.ts
    │   │   │   ├── mqtt-options.interface.ts
    │   │   │   ├── nats-codec.interface.ts
    │   │   │   ├── redis.interface.ts
    │   │   │   └── rmq-url.interface.ts
    │   │   ├── factories/
    │   │   │   └── rpc-params-factory.ts
    │   │   ├── helpers/
    │   │   │   ├── grpc-helpers.ts
    │   │   │   ├── index.ts
    │   │   │   ├── json-socket.ts
    │   │   │   ├── kafka-logger.ts
    │   │   │   ├── kafka-parser.ts
    │   │   │   ├── kafka-reply-partition-assigner.ts
    │   │   │   └── tcp-socket.ts
    │   │   ├── interfaces/
    │   │   │   ├── client-grpc.interface.ts
    │   │   │   ├── client-kafka-proxy.interface.ts
    │   │   │   ├── client-metadata.interface.ts
    │   │   │   ├── custom-transport-strategy.interface.ts
    │   │   │   ├── deserializer.interface.ts
    │   │   │   ├── index.ts
    │   │   │   ├── message-handler.interface.ts
    │   │   │   ├── microservice-configuration.interface.ts
    │   │   │   ├── microservice-entrypoint-metadata.interface.ts
    │   │   │   ├── packet.interface.ts
    │   │   │   ├── pattern-metadata.interface.ts
    │   │   │   ├── pattern.interface.ts
    │   │   │   ├── request-context.interface.ts
    │   │   │   └── serializer.interface.ts
    │   │   ├── module/
    │   │   │   ├── clients.module.ts
    │   │   │   ├── index.ts
    │   │   │   └── interfaces/
    │   │   │       ├── clients-module.interface.ts
    │   │   │       └── index.ts
    │   │   ├── record-builders/
    │   │   │   ├── index.ts
    │   │   │   ├── mqtt.record-builder.ts
    │   │   │   ├── nats.record-builder.ts
    │   │   │   └── rmq.record-builder.ts
    │   │   ├── serializers/
    │   │   │   ├── identity.serializer.ts
    │   │   │   ├── index.ts
    │   │   │   ├── kafka-request.serializer.ts
    │   │   │   ├── mqtt-record.serializer.ts
    │   │   │   ├── nats-record.serializer.ts
    │   │   │   └── rmq-record.serializer.ts
    │   │   ├── server/
    │   │   │   ├── index.ts
    │   │   │   ├── server-factory.ts
    │   │   │   ├── server-grpc.ts
    │   │   │   ├── server-kafka.ts
    │   │   │   ├── server-mqtt.ts
    │   │   │   ├── server-nats.ts
    │   │   │   ├── server-redis.ts
    │   │   │   ├── server-rmq.ts
    │   │   │   ├── server-tcp.ts
    │   │   │   └── server.ts
    │   │   ├── test/
    │   │   │   ├── container.spec.ts
    │   │   │   ├── listeners-controller.spec.ts
    │   │   │   ├── listeners-metadata-explorer.spec.ts
    │   │   │   ├── tsconfig.json
    │   │   │   ├── client/
    │   │   │   │   ├── client-grpc.spec.ts
    │   │   │   │   ├── client-kafka.spec.ts
    │   │   │   │   ├── client-mqtt.spec.ts
    │   │   │   │   ├── client-nats.spec.ts
    │   │   │   │   ├── client-proxy-factory.spec.ts
    │   │   │   │   ├── client-proxy.spec.ts
    │   │   │   │   ├── client-redis.spec.ts
    │   │   │   │   ├── client-rmq.spec.ts
    │   │   │   │   ├── client-tcp.spec.ts
    │   │   │   │   ├── test.proto
    │   │   │   │   └── test2.proto
    │   │   │   ├── context/
    │   │   │   │   ├── exception-filters-context.spec.ts
    │   │   │   │   ├── request-context-host.spec.ts
    │   │   │   │   ├── rpc-context-creator.spec.ts
    │   │   │   │   └── rpc-proxy.spec.ts
    │   │   │   ├── ctx-host/
    │   │   │   │   ├── base-rpc-context.spec.ts
    │   │   │   │   ├── kafka.context.spec.ts
    │   │   │   │   ├── mqtt.context.spec.ts
    │   │   │   │   ├── nats.context.spec.ts
    │   │   │   │   ├── redis.context.spec.ts
    │   │   │   │   ├── rmq.context.spec.ts
    │   │   │   │   └── tcp.context.spec.ts
    │   │   │   ├── decorators/
    │   │   │   │   ├── client.decorator.spec.ts
    │   │   │   │   ├── ctx.decorator.spec.ts
    │   │   │   │   ├── event-pattern.decorator.spec.ts
    │   │   │   │   ├── message-pattern.decorator.spec.ts
    │   │   │   │   └── payload.decorator.spec.ts
    │   │   │   ├── deserializers/
    │   │   │   │   ├── identity.deserializer.spec.ts
    │   │   │   │   ├── incoming-request.deserializer.spec.ts
    │   │   │   │   ├── incoming-response.deserializer.spec.ts
    │   │   │   │   └── kafka-response.deserializer.spec.ts
    │   │   │   ├── exceptions/
    │   │   │   │   ├── rpc-exception.spec.ts
    │   │   │   │   └── rpc-exceptions-handler.spec.ts
    │   │   │   ├── factories/
    │   │   │   │   └── rpc-params-factory.spec.ts
    │   │   │   ├── helpers/
    │   │   │   │   ├── grpc-helpers.spec.ts
    │   │   │   │   ├── kafka-logger.spec.ts
    │   │   │   │   ├── kafka-parser.spec.ts
    │   │   │   │   └── kafka-reply-partition-assigner.spec.ts
    │   │   │   ├── json-socket/
    │   │   │   │   ├── connection.spec.ts
    │   │   │   │   ├── helpers.ts
    │   │   │   │   ├── listener-chaining.spec.ts
    │   │   │   │   ├── message-parsing.spec.ts
    │   │   │   │   └── data/
    │   │   │   │       └── long-payload-with-special-chars.ts
    │   │   │   ├── module/
    │   │   │   │   └── clients.module.spec.ts
    │   │   │   ├── serializers/
    │   │   │   │   ├── identity.serializer.spec.ts
    │   │   │   │   ├── kafka-request.serializer.spec.ts
    │   │   │   │   ├── mqtt-record.serializer.spec.ts
    │   │   │   │   ├── nats-record.serializer.spec.ts
    │   │   │   │   └── rmq-record.serializer.spec.ts
    │   │   │   ├── server/
    │   │   │   │   ├── server-factory.spec.ts
    │   │   │   │   ├── server-grpc.spec.ts
    │   │   │   │   ├── server-kafka.spec.ts
    │   │   │   │   ├── server-mqtt.spec.ts
    │   │   │   │   ├── server-nats.spec.ts
    │   │   │   │   ├── server-redis.spec.ts
    │   │   │   │   ├── server-rmq.spec.ts
    │   │   │   │   ├── server-tcp.spec.ts
    │   │   │   │   ├── server.spec.ts
    │   │   │   │   ├── test.proto
    │   │   │   │   ├── test2.proto
    │   │   │   │   └── utils/
    │   │   │   │       └── object-to-map.ts
    │   │   │   └── utils/
    │   │   │       └── transform-pattern.utils.spec.ts
    │   │   └── utils/
    │   │       ├── index.ts
    │   │       ├── param.utils.ts
    │   │       └── transform-pattern.utils.ts
    │   ├── platform-express/
    │   │   ├── Readme.md
    │   │   ├── index.ts
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── adapters/
    │   │   │   ├── express-adapter.ts
    │   │   │   ├── index.ts
    │   │   │   └── utils/
    │   │   │       └── get-body-parser-options.util.ts
    │   │   ├── interfaces/
    │   │   │   ├── index.ts
    │   │   │   ├── nest-express-application.interface.ts
    │   │   │   ├── nest-express-body-parser-options.interface.ts
    │   │   │   ├── nest-express-body-parser.interface.ts
    │   │   │   └── serve-static-options.interface.ts
    │   │   ├── multer/
    │   │   │   ├── files.constants.ts
    │   │   │   ├── index.ts
    │   │   │   ├── multer.constants.ts
    │   │   │   ├── multer.module.ts
    │   │   │   ├── interceptors/
    │   │   │   │   ├── any-files.interceptor.ts
    │   │   │   │   ├── file-fields.interceptor.ts
    │   │   │   │   ├── file.interceptor.ts
    │   │   │   │   ├── files.interceptor.ts
    │   │   │   │   ├── index.ts
    │   │   │   │   └── no-files.interceptor.ts
    │   │   │   ├── interfaces/
    │   │   │   │   ├── files-upload-module.interface.ts
    │   │   │   │   ├── index.ts
    │   │   │   │   └── multer-options.interface.ts
    │   │   │   └── multer/
    │   │   │       ├── multer.constants.ts
    │   │   │       └── multer.utils.ts
    │   │   └── test/
    │   │       ├── tsconfig.json
    │   │       ├── adapters/
    │   │       │   └── express-adapter.spec.ts
    │   │       └── multer/
    │   │           ├── interceptors/
    │   │           │   ├── any-files.interceptor.spec.ts
    │   │           │   ├── file-fields.interceptor.spec.ts
    │   │           │   ├── file.interceptor.spec.ts
    │   │           │   ├── files.interceptor.spec.ts
    │   │           │   └── no-files.inteceptor.spec.ts
    │   │           └── multer/
    │   │               ├── multer.module.spec.ts
    │   │               └── multer.utils.spec.ts
    │   ├── platform-fastify/
    │   │   ├── Readme.md
    │   │   ├── constants.ts
    │   │   ├── index.ts
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── adapters/
    │   │   │   ├── fastify-adapter.ts
    │   │   │   └── index.ts
    │   │   ├── decorators/
    │   │   │   ├── index.ts
    │   │   │   ├── route-config.decorator.ts
    │   │   │   └── route-constraints.decorator.ts
    │   │   ├── interfaces/
    │   │   │   ├── index.ts
    │   │   │   ├── nest-fastify-application.interface.ts
    │   │   │   ├── nest-fastify-body-parser-options.interface.ts
    │   │   │   └── external/
    │   │   │       ├── fastify-static-options.interface.ts
    │   │   │       ├── fastify-view-options.interface.ts
    │   │   │       └── index.ts
    │   │   └── test/
    │   │       ├── tsconfig.json
    │   │       └── decorators/
    │   │           ├── router-config.decorator.spec.ts
    │   │           └── router-constraints.decorator.spec.ts
    │   ├── platform-socket.io/
    │   │   ├── Readme.md
    │   │   ├── index.ts
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   └── adapters/
    │   │       ├── index.ts
    │   │       └── io-adapter.ts
    │   ├── platform-ws/
    │   │   ├── Readme.md
    │   │   ├── index.ts
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   └── adapters/
    │   │       ├── index.ts
    │   │       └── ws-adapter.ts
    │   ├── testing/
    │   │   ├── Readme.md
    │   │   ├── index.ts
    │   │   ├── package.json
    │   │   ├── test.ts
    │   │   ├── testing-injector.ts
    │   │   ├── testing-instance-loader.ts
    │   │   ├── testing-module.builder.ts
    │   │   ├── testing-module.ts
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── interfaces/
    │   │   │   ├── index.ts
    │   │   │   ├── mock-factory.ts
    │   │   │   ├── override-by-factory-options.interface.ts
    │   │   │   ├── override-by.interface.ts
    │   │   │   └── override-module.interface.ts
    │   │   └── services/
    │   │       └── testing-logger.service.ts
    │   └── websockets/
    │       ├── Readme.md
    │       ├── constants.ts
    │       ├── gateway-metadata-explorer.ts
    │       ├── index.ts
    │       ├── package.json
    │       ├── socket-module.ts
    │       ├── socket-server-provider.ts
    │       ├── sockets-container.ts
    │       ├── tsconfig.build.json
    │       ├── tsconfig.json
    │       ├── web-sockets-controller.ts
    │       ├── adapters/
    │       │   ├── index.ts
    │       │   └── ws-adapter.ts
    │       ├── context/
    │       │   ├── exception-filters-context.ts
    │       │   ├── ws-context-creator.ts
    │       │   ├── ws-metadata-constants.ts
    │       │   └── ws-proxy.ts
    │       ├── decorators/
    │       │   ├── connected-socket.decorator.ts
    │       │   ├── gateway-server.decorator.ts
    │       │   ├── index.ts
    │       │   ├── message-body.decorator.ts
    │       │   ├── socket-gateway.decorator.ts
    │       │   └── subscribe-message.decorator.ts
    │       ├── enums/
    │       │   └── ws-paramtype.enum.ts
    │       ├── errors/
    │       │   ├── index.ts
    │       │   ├── invalid-socket-port.exception.ts
    │       │   └── ws-exception.ts
    │       ├── exceptions/
    │       │   ├── base-ws-exception-filter.ts
    │       │   ├── index.ts
    │       │   └── ws-exceptions-handler.ts
    │       ├── factories/
    │       │   ├── server-and-event-streams-factory.ts
    │       │   └── ws-params-factory.ts
    │       ├── interfaces/
    │       │   ├── gateway-metadata.interface.ts
    │       │   ├── index.ts
    │       │   ├── nest-gateway.interface.ts
    │       │   ├── server-and-event-streams-host.interface.ts
    │       │   ├── web-socket-server.interface.ts
    │       │   ├── websockets-entrypoint-metadata.interface.ts
    │       │   ├── ws-response.interface.ts
    │       │   └── hooks/
    │       │       ├── index.ts
    │       │       ├── on-gateway-connection.interface.ts
    │       │       ├── on-gateway-disconnect.interface.ts
    │       │       └── on-gateway-init.interface.ts
    │       ├── test/
    │       │   ├── container.spec.ts
    │       │   ├── gateway-metadata-explorer.spec.ts
    │       │   ├── socket-server-provider.spec.ts
    │       │   ├── tsconfig.json
    │       │   ├── web-sockets-controller.spec.ts
    │       │   ├── context/
    │       │   │   ├── exception-filters.context.spec.ts
    │       │   │   ├── ws-context-creator.spec.ts
    │       │   │   └── ws-proxy.spec.ts
    │       │   ├── decorators/
    │       │   │   ├── connected-socket.decorator.spec.ts
    │       │   │   └── message-body.decorator.spec.ts
    │       │   ├── exceptions/
    │       │   │   ├── ws-exception.spec.ts
    │       │   │   └── ws-exceptions-handler.spec.ts
    │       │   ├── factories/
    │       │   │   ├── server-and-event-streams-factory.spec.ts
    │       │   │   └── ws-params-factory.spec.ts
    │       │   └── utils/
    │       │       ├── compare-element.util.spec.ts
    │       │       ├── gateway-server.decorator.spec.ts
    │       │       ├── socket-gateway.decorator.spec.ts
    │       │       └── subscribe-message.decorator.spec.ts
    │       └── utils/
    │           ├── compare-element.util.ts
    │           ├── index.ts
    │           └── param.utils.ts
    ├── sample/
    │   ├── 01-cats-app/
    │   │   ├── eslint.config.mjs
    │   │   ├── jest.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── e2e/
    │   │   │   ├── jest-e2e.json
    │   │   │   └── cats/
    │   │   │       └── cats.e2e-spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── cats/
    │   │       │   ├── cats.controller.spec.ts
    │   │       │   ├── cats.controller.ts
    │   │       │   ├── cats.module.ts
    │   │       │   ├── cats.service.spec.ts
    │   │       │   ├── cats.service.ts
    │   │       │   ├── dto/
    │   │       │   │   └── create-cat.dto.ts
    │   │       │   └── interfaces/
    │   │       │       └── cat.interface.ts
    │   │       ├── common/
    │   │       │   ├── decorators/
    │   │       │   │   └── roles.decorator.ts
    │   │       │   ├── filters/
    │   │       │   │   └── http-exception.filter.ts
    │   │       │   ├── guards/
    │   │       │   │   └── roles.guard.ts
    │   │       │   ├── interceptors/
    │   │       │   │   ├── exception.interceptor.ts
    │   │       │   │   └── timeout.interceptor.ts
    │   │       │   ├── middleware/
    │   │       │   │   └── logger.middleware.ts
    │   │       │   └── pipes/
    │   │       │       ├── parse-int.pipe.ts
    │   │       │       └── validation.pipe.ts
    │   │       └── core/
    │   │           ├── core.module.ts
    │   │           └── interceptors/
    │   │               ├── logging.interceptor.ts
    │   │               └── transform.interceptor.ts
    │   ├── 02-gateways/
    │   │   ├── eslint.config.mjs
    │   │   ├── jest.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── client/
    │   │   │   └── index.html
    │   │   ├── e2e/
    │   │   │   ├── jest-e2e.json
    │   │   │   └── events-gateway/
    │   │   │       └── gateway.e2e-spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── adapters/
    │   │       │   └── redis-io.adapter.ts
    │   │       └── events/
    │   │           ├── events.gateway.spec.ts
    │   │           ├── events.gateway.ts
    │   │           └── events.module.ts
    │   ├── 03-microservices/
    │   │   ├── eslint.config.mjs
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── common/
    │   │       │   ├── filters/
    │   │       │   │   └── rpc-exception.filter.ts
    │   │       │   ├── interceptors/
    │   │       │   │   └── logging.interceptor.ts
    │   │       │   └── strategies/
    │   │       │       └── nats.strategy.ts
    │   │       └── math/
    │   │           ├── math.constants.ts
    │   │           ├── math.controller.ts
    │   │           └── math.module.ts
    │   ├── 04-grpc/
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── grpc-client.options.ts
    │   │       ├── main.ts
    │   │       └── hero/
    │   │           ├── hero.controller.ts
    │   │           ├── hero.module.ts
    │   │           ├── hero.proto
    │   │           └── interfaces/
    │   │               ├── hero-by-id.interface.ts
    │   │               └── hero.interface.ts
    │   ├── 05-sql-typeorm/
    │   │   ├── README.md
    │   │   ├── docker-compose.yml
    │   │   ├── eslint.config.mjs
    │   │   ├── jest.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── src/
    │   │   │   ├── app.module.ts
    │   │   │   ├── main.ts
    │   │   │   └── users/
    │   │   │       ├── user.entity.ts
    │   │   │       ├── users.controller.spec.ts
    │   │   │       ├── users.controller.ts
    │   │   │       ├── users.module.ts
    │   │   │       ├── users.service.spec.ts
    │   │   │       ├── users.service.ts
    │   │   │       └── dto/
    │   │   │           └── create-user.dto.ts
    │   │   └── test/
    │   │       ├── jest-e2e.json
    │   │       └── users/
    │   │           └── users.e2e-spec.ts
    │   ├── 06-mongoose/
    │   │   ├── README.md
    │   │   ├── docker-compose.yml
    │   │   ├── eslint.config.mjs
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       └── cats/
    │   │           ├── cats.controller.spec.ts
    │   │           ├── cats.controller.ts
    │   │           ├── cats.module.ts
    │   │           ├── cats.service.spec.ts
    │   │           ├── cats.service.ts
    │   │           ├── dto/
    │   │           │   ├── create-cat.dto.ts
    │   │           │   └── update-cat.dto.ts
    │   │           └── schemas/
    │   │               └── cat.schema.ts
    │   ├── 07-sequelize/
    │   │   ├── README.md
    │   │   ├── docker-compose.yml
    │   │   ├── eslint.config.mjs
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       └── users/
    │   │           ├── users.controller.spec.ts
    │   │           ├── users.controller.ts
    │   │           ├── users.module.ts
    │   │           ├── users.service.spec.ts
    │   │           ├── users.service.ts
    │   │           ├── dto/
    │   │           │   └── create-user.dto.ts
    │   │           └── models/
    │   │               └── user.model.ts
    │   ├── 08-webpack/
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── webpack-hmr.config.js
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── app.service.ts
    │   │       └── main.ts
    │   ├── 09-babel-example/
    │   │   ├── index.js
    │   │   ├── jsconfig.json
    │   │   ├── nodemon.json
    │   │   ├── package.json
    │   │   ├── .babelrc
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.js
    │   │       ├── main.js
    │   │       └── cats/
    │   │           ├── cats.controller.js
    │   │           ├── cats.module.js
    │   │           └── cats.service.js
    │   ├── 10-fastify/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── cats/
    │   │       │   ├── cats.controller.ts
    │   │       │   ├── cats.module.ts
    │   │       │   ├── cats.service.ts
    │   │       │   ├── dto/
    │   │       │   │   └── create-cat.dto.ts
    │   │       │   └── interfaces/
    │   │       │       └── cat.interface.ts
    │   │       ├── common/
    │   │       │   ├── decorators/
    │   │       │   │   └── roles.decorator.ts
    │   │       │   ├── guards/
    │   │       │   │   └── roles.guard.ts
    │   │       │   ├── interceptors/
    │   │       │   │   └── exception.interceptor.ts
    │   │       │   ├── middleware/
    │   │       │   │   └── logger.middleware.ts
    │   │       │   └── pipes/
    │   │       │       ├── parse-int.pipe.ts
    │   │       │       └── validation.pipe.ts
    │   │       └── core/
    │   │           ├── core.module.ts
    │   │           └── interceptors/
    │   │               ├── logging.interceptor.ts
    │   │               └── transform.interceptor.ts
    │   ├── 11-swagger/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       └── cats/
    │   │           ├── cats.controller.ts
    │   │           ├── cats.module.ts
    │   │           ├── cats.service.ts
    │   │           ├── dto/
    │   │           │   └── create-cat.dto.ts
    │   │           └── entities/
    │   │               └── cat.entity.ts
    │   ├── 12-graphql-schema-first/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── generate-typings.ts
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── e2e/
    │   │   │   ├── jest-e2e.json
    │   │   │   └── cats/
    │   │   │       └── cats.e2e-spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── graphql.schema.ts
    │   │       ├── main.ts
    │   │       ├── cats/
    │   │       │   ├── cat-owner.resolver.spec.ts
    │   │       │   ├── cat-owner.resolver.ts
    │   │       │   ├── cats.graphql
    │   │       │   ├── cats.guard.ts
    │   │       │   ├── cats.module.ts
    │   │       │   ├── cats.resolver.spec.ts
    │   │       │   ├── cats.resolver.ts
    │   │       │   ├── cats.service.spec.ts
    │   │       │   ├── cats.service.ts
    │   │       │   └── dto/
    │   │       │       └── create-cat.dto.ts
    │   │       ├── common/
    │   │       │   ├── directives/
    │   │       │   │   └── upper-case.directive.ts
    │   │       │   ├── plugins/
    │   │       │   │   └── logging.plugin.ts
    │   │       │   └── scalars/
    │   │       │       └── date.scalar.ts
    │   │       └── owners/
    │   │           ├── owners.module.ts
    │   │           ├── owners.service.spec.ts
    │   │           └── owners.service.ts
    │   ├── 13-mongo-typeorm/
    │   │   ├── README.md
    │   │   ├── docker-compose.yml
    │   │   ├── eslint.config.mjs
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       └── photo/
    │   │           ├── photo.controller.spec.ts
    │   │           ├── photo.controller.ts
    │   │           ├── photo.entity.ts
    │   │           ├── photo.module.ts
    │   │           ├── photo.service.spec.ts
    │   │           └── photo.service.ts
    │   ├── 14-mongoose-base/
    │   │   ├── README.md
    │   │   ├── docker-compose.yml
    │   │   ├── eslint.config.mjs
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── cats/
    │   │       │   ├── cats.controller.spec.ts
    │   │       │   ├── cats.controller.ts
    │   │       │   ├── cats.module.ts
    │   │       │   ├── cats.providers.ts
    │   │       │   ├── cats.service.spec.ts
    │   │       │   ├── cats.service.ts
    │   │       │   ├── dto/
    │   │       │   │   └── create-cat.dto.ts
    │   │       │   ├── interfaces/
    │   │       │   │   └── cat.interface.ts
    │   │       │   └── schemas/
    │   │       │       └── cat.schema.ts
    │   │       └── database/
    │   │           ├── database.module.ts
    │   │           └── database.providers.ts
    │   ├── 15-mvc/
    │   │   ├── eslint.config.mjs
    │   │   ├── nodemon.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── public/
    │   │   │   └── .gitkeep
    │   │   ├── src/
    │   │   │   ├── app.controller.ts
    │   │   │   ├── app.module.ts
    │   │   │   └── main.ts
    │   │   └── views/
    │   │       └── index.hbs
    │   ├── 16-gateways-ws/
    │   │   ├── eslint.config.mjs
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── client/
    │   │   │   └── index.html
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       └── events/
    │   │           ├── events.gateway.ts
    │   │           └── events.module.ts
    │   ├── 17-mvc-fastify/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── nodemon.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── public/
    │   │   │   └── .gitkeep
    │   │   ├── src/
    │   │   │   ├── app.controller.ts
    │   │   │   ├── app.module.ts
    │   │   │   └── main.ts
    │   │   └── views/
    │   │       └── index.hbs
    │   ├── 18-context/
    │   │   ├── eslint.config.mjs
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── app.service.ts
    │   │       ├── main.ts
    │   │       └── my-dynamic.module.ts
    │   ├── 19-auth-jwt/
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── e2e/
    │   │   │   ├── jest-e2e.json
    │   │   │   └── app/
    │   │   │       └── app.e2e-spec.ts
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── auth/
    │   │       │   ├── auth.controller.ts
    │   │       │   ├── auth.guard.ts
    │   │       │   ├── auth.module.ts
    │   │       │   ├── auth.service.ts
    │   │       │   ├── constants.ts
    │   │       │   └── decorators/
    │   │       │       └── public.decorator.ts
    │   │       └── users/
    │   │           ├── users.module.ts
    │   │           ├── users.service.spec.ts
    │   │           └── users.service.ts
    │   ├── 20-cache/
    │   │   ├── eslint.config.mjs
    │   │   ├── jest.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       └── common/
    │   │           └── http-cache.interceptor.ts
    │   ├── 21-serializer/
    │   │   ├── eslint.config.mjs
    │   │   ├── jest.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       └── entities/
    │   │           ├── role.entity.ts
    │   │           └── user.entity.ts
    │   ├── 22-graphql-prisma/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── generate-typings.ts
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── prisma/
    │   │   │   └── schema.prisma
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── graphql.schema.ts
    │   │       ├── main.ts
    │   │       ├── posts/
    │   │       │   ├── posts.module.ts
    │   │       │   ├── posts.resolvers.ts
    │   │       │   ├── posts.service.ts
    │   │       │   └── schema.graphql
    │   │       └── prisma/
    │   │           ├── prisma.module.ts
    │   │           └── prisma.service.ts
    │   ├── 23-graphql-code-first/
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── schema.gql
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── common/
    │   │       │   ├── directives/
    │   │       │   │   └── upper-case.directive.ts
    │   │       │   ├── plugins/
    │   │       │   │   ├── complexity.plugin.ts
    │   │       │   │   └── logging.plugin.ts
    │   │       │   └── scalars/
    │   │       │       └── date.scalar.ts
    │   │       └── recipes/
    │   │           ├── recipes.module.ts
    │   │           ├── recipes.resolver.ts
    │   │           ├── recipes.service.ts
    │   │           ├── dto/
    │   │           │   ├── new-recipe.input.ts
    │   │           │   └── recipes.args.ts
    │   │           └── models/
    │   │               └── recipe.model.ts
    │   ├── 24-serve-static/
    │   │   ├── eslint.config.mjs
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── client/
    │   │   │   └── index.html
    │   │   └── src/
    │   │       ├── app.controller.ts
    │   │       ├── app.module.ts
    │   │       └── main.ts
    │   ├── 25-dynamic-modules/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── .prettierrc
    │   │   ├── config/
    │   │   │   └── development.env
    │   │   └── src/
    │   │       ├── app.controller.spec.ts
    │   │       ├── app.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── app.service.ts
    │   │       ├── main.ts
    │   │       └── config/
    │   │           ├── config.module.ts
    │   │           ├── config.service.spec.ts
    │   │           ├── config.service.ts
    │   │           ├── constants.ts
    │   │           └── interfaces/
    │   │               ├── config-options.interface.ts
    │   │               ├── envconfig.interface.ts
    │   │               └── index.ts
    │   ├── 26-queues/
    │   │   ├── README.md
    │   │   ├── docker-compose.yml
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── .prettierrc
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       └── audio/
    │   │           ├── audio.controller.ts
    │   │           ├── audio.module.ts
    │   │           └── audio.processor.ts
    │   ├── 27-scheduling/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── .prettierrc
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       └── tasks/
    │   │           ├── tasks.module.ts
    │   │           └── tasks.service.ts
    │   ├── 28-sse/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── jest.json
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── .prettierrc
    │   │   └── src/
    │   │       ├── app.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── index.html
    │   │       └── main.ts
    │   ├── 29-file-upload/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── jest.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── e2e/
    │   │   │   ├── jest-e2e.json
    │   │   │   └── app/
    │   │   │       └── app.e2e-spec.ts
    │   │   └── src/
    │   │       ├── app.controller.ts
    │   │       ├── app.module.ts
    │   │       ├── app.service.ts
    │   │       ├── main.ts
    │   │       └── sample.dto.ts
    │   ├── 30-event-emitter/
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── .prettierrc
    │   │   ├── src/
    │   │   │   ├── app.module.ts
    │   │   │   ├── main.ts
    │   │   │   └── orders/
    │   │   │       ├── orders.controller.ts
    │   │   │       ├── orders.module.ts
    │   │   │       ├── orders.service.ts
    │   │   │       ├── dto/
    │   │   │       │   └── create-order.dto.ts
    │   │   │       ├── entities/
    │   │   │       │   └── order.entity.ts
    │   │   │       ├── events/
    │   │   │       │   └── order-created.event.ts
    │   │   │       └── listeners/
    │   │   │           └── order-created.listener.ts
    │   │   └── test/
    │   │       ├── app.e2e-spec.ts
    │   │       └── jest-e2e.json
    │   ├── 31-graphql-federation-code-first/
    │   │   ├── README.md
    │   │   ├── gateway/
    │   │   │   ├── README.md
    │   │   │   ├── eslint.config.mjs
    │   │   │   ├── nest-cli.json
    │   │   │   ├── package.json
    │   │   │   ├── tsconfig.build.json
    │   │   │   ├── tsconfig.json
    │   │   │   ├── .gitignore
    │   │   │   ├── .prettierrc
    │   │   │   └── src/
    │   │   │       ├── app.module.ts
    │   │   │       └── main.ts
    │   │   ├── posts-application/
    │   │   │   ├── README.md
    │   │   │   ├── eslint.config.mjs
    │   │   │   ├── nest-cli.json
    │   │   │   ├── package.json
    │   │   │   ├── tsconfig.build.json
    │   │   │   ├── tsconfig.json
    │   │   │   ├── .gitignore
    │   │   │   ├── .prettierrc
    │   │   │   └── src/
    │   │   │       ├── app.module.ts
    │   │   │       ├── main.ts
    │   │   │       └── posts/
    │   │   │           ├── posts.module.ts
    │   │   │           ├── posts.resolver.spec.ts
    │   │   │           ├── posts.resolver.ts
    │   │   │           ├── posts.service.spec.ts
    │   │   │           ├── posts.service.ts
    │   │   │           ├── users.resolver.spec.ts
    │   │   │           ├── users.resolver.ts
    │   │   │           └── models/
    │   │   │               ├── post.model.ts
    │   │   │               └── user.model.ts
    │   │   └── users-application/
    │   │       ├── README.md
    │   │       ├── eslint.config.mjs
    │   │       ├── nest-cli.json
    │   │       ├── package.json
    │   │       ├── tsconfig.build.json
    │   │       ├── tsconfig.json
    │   │       ├── .gitignore
    │   │       ├── .prettierrc
    │   │       └── src/
    │   │           ├── app.module.ts
    │   │           ├── main.ts
    │   │           └── users/
    │   │               ├── users.module.ts
    │   │               ├── users.resolver.spec.ts
    │   │               ├── users.resolver.ts
    │   │               ├── users.service.spec.ts
    │   │               ├── users.service.ts
    │   │               └── models/
    │   │                   └── user.model.ts
    │   ├── 32-graphql-federation-schema-first/
    │   │   ├── README.md
    │   │   ├── gateway/
    │   │   │   ├── README.md
    │   │   │   ├── eslint.config.mjs
    │   │   │   ├── nest-cli.json
    │   │   │   ├── package.json
    │   │   │   ├── tsconfig.build.json
    │   │   │   ├── tsconfig.json
    │   │   │   ├── .gitignore
    │   │   │   ├── .prettierrc
    │   │   │   └── src/
    │   │   │       ├── app.module.ts
    │   │   │       └── main.ts
    │   │   ├── posts-application/
    │   │   │   ├── README.md
    │   │   │   ├── eslint.config.mjs
    │   │   │   ├── nest-cli.json
    │   │   │   ├── package.json
    │   │   │   ├── tsconfig.build.json
    │   │   │   ├── tsconfig.json
    │   │   │   ├── .gitignore
    │   │   │   ├── .prettierrc
    │   │   │   └── src/
    │   │   │       ├── app.module.ts
    │   │   │       ├── main.ts
    │   │   │       └── posts/
    │   │   │           ├── posts.graphql
    │   │   │           ├── posts.interfaces.ts
    │   │   │           ├── posts.module.ts
    │   │   │           ├── posts.resolver.spec.ts
    │   │   │           ├── posts.resolver.ts
    │   │   │           ├── posts.service.spec.ts
    │   │   │           ├── posts.service.ts
    │   │   │           ├── users.interfaces.ts
    │   │   │           ├── users.resolver.spec.ts
    │   │   │           ├── users.resolver.ts
    │   │   │           └── models/
    │   │   │               ├── post.model.ts
    │   │   │               └── user.model.ts
    │   │   └── users-application/
    │   │       ├── README.md
    │   │       ├── eslint.config.mjs
    │   │       ├── nest-cli.json
    │   │       ├── package.json
    │   │       ├── tsconfig.build.json
    │   │       ├── tsconfig.json
    │   │       ├── .gitignore
    │   │       ├── .prettierrc
    │   │       └── src/
    │   │           ├── app.module.ts
    │   │           ├── main.ts
    │   │           └── users/
    │   │               ├── users.graphql
    │   │               ├── users.module.ts
    │   │               ├── users.resolver.spec.ts
    │   │               ├── users.resolver.ts
    │   │               ├── users.service.spec.ts
    │   │               ├── users.service.ts
    │   │               └── models/
    │   │                   └── user.model.ts
    │   ├── 33-graphql-mercurius/
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── schema.gql
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   └── src/
    │   │       ├── app.module.ts
    │   │       ├── main.ts
    │   │       ├── common/
    │   │       │   └── scalars/
    │   │       │       └── date.scalar.ts
    │   │       └── recipes/
    │   │           ├── recipes.module.ts
    │   │           ├── recipes.resolver.ts
    │   │           ├── recipes.service.ts
    │   │           ├── dto/
    │   │           │   ├── new-recipe.input.ts
    │   │           │   └── recipes.args.ts
    │   │           └── models/
    │   │               └── recipe.model.ts
    │   ├── 34-using-esm-packages/
    │   │   ├── README.md
    │   │   ├── eslint.config.mjs
    │   │   ├── nest-cli.json
    │   │   ├── package.json
    │   │   ├── tsconfig.build.json
    │   │   ├── tsconfig.json
    │   │   ├── .gitignore
    │   │   ├── .prettierrc
    │   │   ├── src/
    │   │   │   ├── app.controller.spec.ts
    │   │   │   ├── app.controller.ts
    │   │   │   ├── app.module.ts
    │   │   │   ├── app.service.ts
    │   │   │   ├── import-esm-package.ts
    │   │   │   ├── main.ts
    │   │   │   └── superjson.provider.ts
    │   │   └── test/
    │   │       ├── app.e2e-spec.ts
    │   │       └── jest-e2e.json
    │   └── 35-use-esm-package-after-node22/
    │       ├── README.md
    │       ├── eslint.config.mjs
    │       ├── nest-cli.json
    │       ├── package.json
    │       ├── tsconfig.build.json
    │       ├── tsconfig.json
    │       ├── .gitignore
    │       ├── .prettierrc
    │       └── src/
    │           ├── app.controller.ts
    │           ├── app.module.ts
    │           ├── app.service.ts
    │           └── main.ts
    ├── scripts/
    │   ├── prepare.sh
    │   ├── run-integration.sh
    │   ├── test.sh
    │   └── update-samples.sh
    ├── tools/
    │   ├── benchmarks/
    │   │   ├── check-benchmarks.ts
    │   │   ├── get-benchmarks.ts
    │   │   └── report-contents.md
    │   └── gulp/
    │       ├── config.ts
    │       ├── gulpfile.ts
    │       ├── tsconfig.json
    │       ├── tasks/
    │       │   ├── clean.ts
    │       │   ├── copy-misc.ts
    │       │   ├── move.ts
    │       │   └── samples.ts
    │       └── util/
    │           └── task-helpers.ts
    ├── .circleci/
    │   ├── config.yml
    │   └── install-wrk.sh
    ├── .github/
    │   ├── dependabot.yml
    │   ├── FUNDING.yml
    │   ├── lock.yml
    │   ├── PULL_REQUEST_TEMPLATE.md
    │   ├── ISSUE_TEMPLATE/
    │   │   ├── Bug_report.yml
    │   │   ├── config.yml
    │   │   ├── Feature_request.yml
    │   │   ├── Regression.yml
    │   │   └── Suggestion_improve_performance.yml
    │   └── workflows/
    │       └── codeql-analysis.yml
    └── .husky/
        ├── commit-msg
        └── pre-commit
