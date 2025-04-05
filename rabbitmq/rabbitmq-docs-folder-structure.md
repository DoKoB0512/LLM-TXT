# Root: docs/

## Introduction / Basics
- `index.md` — Main documentation index
- `download.md` — Download RabbitMQ
- `configure.md` — General server configuration
- `platforms.md` — Supported platforms
- `which-erlang.md` — Erlang compatibility

## Installation Guides
- `install-debian.md` — Debian-based installs
- `install-generic-unix.md` — Generic UNIX systems
- `install-homebrew.md` — macOS Homebrew
- `install-rpm.md` — RPM-based distros
- `install-solaris.md` — Solaris systems
- `install-standalone-mac.md` — Standalone macOS package
- `install-windows.md` — Windows installer
- `install-windows-manual.md` — Manual install on Windows
- `installing-plugins.md` — Installing plugins/extensions

---

## Cluster & High Availability
- `cluster-formation.md` — Cluster formation details
- `clustering.md` — Clustering concepts
- `clustering-ssl.md` — SSL-secured clustering
- `blue-green-upgrade.md` — Zero downtime upgrade strategy
- `grow-then-shrink-upgrade.md` — Rolling upgrade method
- `distributed.md` — Distributed system features
- `partitions.md` — Handling network partitions
- `quorum-queues/index.md` — Quorum queues
- `lazy-queues.md` — Lazy queues (store on disk)
- `metadata-store/` — Khepri metadata store subsystem  
  - `clustering.md`, `failure-recovery.md`, `how-to-enable-khepri.md`, `known-issues.md`, `khepri-faq.md`, etc.

---

## Access Control, Authentication & Security
- `authentication.md` — User authentication basics
- `auth-cache-backend.md` — Auth caching
- `auth-notification.md` — Auth change notifications
- `access-control.md` — Permissions/access control
- `ldap.md` — LDAP integration
- `oauth2.md` — OAuth 2 base
- `oauth2-examples.md` — OAuth2 examples summary
- `oauth2-examples-auth0.md` — OAuth2 w/Auth0
- `oauth2-examples-google.md` — OAuth2 w/Google
- `oauth2-examples-keycloak.md` — OAuth2 w/Keycloak
- `oauth2-examples-okta.md` — OAuth2 w/Okta
- `oauth2-examples-forward-proxy.md`
- `oauth2-examples-idp-initiated.md`
- `oauth2-examples-multiresource.md`
- `oauth2-examples-proxy.md`
- `oauth2-examples/` — Index
- `oauth2-examples-entra-id/` — Azure Entra ID example index
- `validated-user-id.md` — User identity proofs
- `user-limits.md` — User limits
- `passwords.md` — Password management
- `signatures.md` — Message signatures / security
- `ssl/index.md` — SSL/TLS general info
- `clustering-ssl.md` — SSL in clustering
- `windows-configuration.md` — Security on Windows

---

## Messaging Protocols & Extensions
- `amqp.md` — AMQP protocol
- `mqtt.md` — MQTT plugin
- `stomp.md` — STOMP
- `web-mqtt.md` — MQTT over WebSockets
- `web-stomp.md` — STOMP over WebSockets
- `sender-selected.md` — AMQP sender-selected routing
- `uri-spec.md` — Uniform Resource Identifier RFC
- `uri-query-parameters.md` — URI options and parameters
- `protocols.md` — Protocol support overview
      
---

## Exchanges, Queues & Messaging Concepts
- `exchanges.md` — Exchange basics
- `classic-queues.md` — Classic queues
- `queues.md` — Queues overview
- `priority.md` — Queue priorities
- `consumer-priority.md` — Consumer priorities
- `confirmations.md` (`confirms.md`) — Publisher confirms
- `dlx.md` — Dead Letter Exchanges
- `event-exchange.md` — Internal event exchange
- `direct-reply-to.md` — RPC shortcut method
- `firehose.md` — Message tracing/firehose
- `consumers.md` — Consumers overview
- `consumer-prefetch.md` — Prefetch count
- `consumer-cancel.md` — Consumer cancellation notifications
- `nack.md` — Negative acknowledgments
- `lazy-queues.md` — Lazy queues
- `ttl.md` — Message TTL
- `sender-selected.md` — Sender-select routing semantics
- `params.md` (`parameters.md`) — Parameters reference
- `signatures.md` — Verified messaging
- `stream.md`, `streams.md` — Stream queues
- `stream-core-plugin-comparison.md` — Streams plugin comparison

---

## Federation, Shovel, and Related Extensions
- `federation.md` — Federation overview
- `federation-reference.md` — Reference guide
- `shovel.md` — Shovel overview
- `shovel-dynamic.md` — Dynamic shovels
- `shovel-static.md` — Static shovels
- `federated-exchanges/index.md` — Federated exchanges setup
- `federated-queues/index.md` — Federated queues setup

---

## Management & Operations
- `management/index.md` — Management plugin overview
- `management-cli.md` — CLI for management
- `cli.md` — CLI usage general
- `build-server.md` — Building RabbitMQ server
- `manage-rabbitmq.md` — Managing server & clusters
- `backup.md` — Backups
- `definitions.md` — Definitions import/export
- `plugins.md` — Plugins management
- `extensions.md` — Plugin/extension support
- `production-checklist.md` — Before production tips
- `rolling-upgrade.md`, `upgrade.md` — Upgrade guides
- `relocate.md` — Moving from server to server
- `runtime.md` — Runtime internals
- `runtime.md` — Runtime environment
- `parameters.md` — System parametrization
- `persistence-conf.md` — Persistence
- `logging.md` — Logging config

---

## Monitoring & Metrics
- `monitoring/index.md` — Monitoring options
- `prometheus/index.md` — Prometheus integration
- `alarms.md` — Resource alarms in RabbitMQ
- `disk-alarms.md` — Disk alarm system
- `memory.md` — Memory management
- `memory-use/index.md` — Memory usage specifics
- `flow-control.md` — Flow control mechanisms

---

## Networking
- `networking.md` — Network connectivity
- `connection-blocked.md` — Connection blocking conditions
- `troubleshooting-networking.md` — Network troubleshooting
- `netticks.md` — Tick intervals/network heartbeat
- `heartbeats.md` — Heartbeat settings

---

## Troubleshooting
- `troubleshooting/index.md` — Troubleshooting index
- `troubleshooting-networking.md` — Network issues
- `troubleshooting-oauth2.md` — OAuth2 config issues
- `troubleshooting-ssl.md` — SSL-related issues

---

## OAuth2 Related (Detail)
- See Access Control group for individual OAuth2 examples
- `oauth2.md`, `oauth2-examples.md`, `oauth2-examples-entra-id/`, `oauth2-examples/`
- `troubleshooting-oauth2.md` inside troubleshooting

---

## Specifications, Semantics & Compatibility
- `specification.md` — AMQP specification
- `spec-differences.md` — AMQP spec differences
- `semantics.md` — Protocol semantics
- `compatibility.md` (not explicitly listed, implicit in above)

---

## Other Features & Config
- `ae.md` — Alternate Exchanges
- `conversions.md` — Data conversion
- `definitions.md` — Definitions import/export
- `local-random-exchange.md` — Local random exchange
- `ec2.md` — Using RabbitMQ on EC2
- `parameters.md` — Runtime parameters
- `passwords.md` — Password management
- `validated-user-id.md` — Validated user ID authz
- `sender-selected.md` — Client routing hint

---

## Documentation Sets / Man pages
- `manpages.md` — All manpage references
- `man/`
  - `README.md`
  - `rabbitmqctl.8.md` — CLI tool manpage
  - `rabbitmq-server.8.md` etc. — Server utility manpages
  - `rabbitmq-diagnostics.8.md`
  - `rabbitmq-streams.8.md`
  - `rabbitmq-upgrade.8.md`
  - `rabbitmq-queues.8.md`
  - `rabbitmq-service.8.md`
  - `rabbitmq-echopid.8.md`
  - `rabbitmq-plugins.8.md`
  - `update-manpages.sh` — Shell script to update manpages index

---

## Additional Subdirectories
Each mainly contains `index.md`:
- Channels: `channels/index.md`
- Connections: `connections/index.md`
- Deprecated Features: `deprecated-features/index.md`
- Feature Flags: `feature-flags/index.md`
- Federated Exchanges: `federated-exchanges/index.md`
- Federated Queues: `federated-queues/index.md`
- Management: `management/index.md`
- Max Length Policies: `maxlength/index.md`
- Memory Use: `memory-use/index.md`
- Monitoring: `monitoring/index.md`
- OAuth2 Examples: `oauth2-examples/index.md`
- OAuth2 Examples Entra ID: `oauth2-examples-entra-id/index.md`
- Metadata Store (Khepri): See above
- Prometheus: `prometheus/index.md`
- Publishers: `publishers/index.md`
- Quorum Queues: `quorum-queues/index.md`
- SSL: `ssl/index.md`
- Troubleshooting: `troubleshooting/index.md`

---

# Summary
This documentation set covers:

- **Installation** across OSes and platforms
- **Clustering** (formation, SSL, HA upgrades, Khepri metadata store)
- **Security** (ACLs, LDAP, OAuth2, SSL/TLS, user limits)
- **Protocols** (AMQP, MQTT, STOMP, WebSockets)
- **Messaging** (queues, priorities, TTLs, confirms, streams, dead-lettering)
- **Extensions** (Federation, Shovel, Plugins)
- **Management & CLI** (Web UI, CLI, tools)
- **Monitoring** (resource alarms, Prometheus, metrics)
- **Networking**
- **Troubleshooting**
- **Specs & semantics**, scripting, man pages
