# memory-bank/projectbrief.md

# Project Brief: High-Performance JavaScript HTTP Server (Bun)

## Overview

Develop a blazing fast, lightweight, production-ready HTTP web server using Bun (https://bun.sh). The server will be optimized for minimal latency, ultra-low overhead, and maximum request throughput.

## Core Requirements

- Handle high concurrency, targeting 100k+ RPS benchmarks
- Ultra-low response latency (<1ms on simple endpoints)
- Built entirely using Bun’s JavaScript/TypeScript APIs
- Provide a simple API for routing and middleware, inspired by minimal frameworks like Fastify/Nano
- Enable easy extensibility without sacrificing performance
- Support HTTP/1.1 and HTTP/2
- Include configurable logging and error handling
- Zero external dependencies outside Bun runtime
- Production-focused with graceful shutdowns, health checks, and async hooks

## Goals

- Outperform existing Node.js/Express or Deno servers significantly
- Offer an ergonomic but minimal API for developers targeting high scalability
- Serve as a foundation for real-time APIs, microservices, or edge deployments

---

# memory-bank/productContext.md

# Product Context: High-Performance Bun HTTP Server

## Why This Project Exists

Modern JavaScript servers often struggle with performance bottlenecks. Even lightweight frameworks on Node introduce overhead. Bun’s new JavaScript runtime promises native speeds competitive with Go or Rust — this server leverages Bun to push JavaScript server speed limits.

## Problems Solved

- Eliminates JS runtime overhead with Bun’s fast engine
- Reduces complexity by avoiding heavy frameworks
- Bridges gap between developer-friendly APIs and raw speed
- Simplifies deploying ultra-performant HTTP servers in pure JavaScript

## User Experience Goals

- Near zero-config startup
- Clean, intuitive API inspired by familiar patterns (e.g., Express)
- Fast startup times, instant reloads during development
- Extensive logging + tracing when desired, silent otherwise
- APIs optimized for async, streaming, and concurrent request handling

## How It Should Work

- Bootstraps via simple import & start pattern
- Users define routes + middleware
- Handles HTTP events with minimal per-request overhead
- Provides hooks for shutdown, error handling, and advanced configuration
- Can run standalone or be embedded in larger Bun apps/services

---

# memory-bank/systemPatterns.md

# System Patterns: Bun HTTP Server Architecture

## Architecture Overview

- Foundation: Bun’s native HTTP server API (`Bun.serve`)
- Core loop: event-driven async request handling
- Routing: in-memory, precompiled route tree or trie
- Middleware: fast, composed functions pipeline
- Response: streamed or buffered, minimal copies
- Error handling: centralized, non-blocking
- Logging: pluggable, lazy-evaluated

## Key Technical Decisions

- Use top-level Bun.serve() with high-concurrency handler
- Prefer pre-compiled routing structures over dynamic lookups
- Middleware are pure async functions; composed at startup
- Avoid closures inside hot codepaths
- Utilize typed arrays & buffer pooling where applicable
- Unroll tight loops in routing where possible

## Design Patterns

- Composition pattern for middleware chaining
- Factory function for server instantiation
- Trie or Radix tree for route matching
- Observer/subscriber hook system for lifecycle events

## Critical Implementation Paths

- Request ingest → route match → middleware pipeline → response write
- Setup: define routes & middleware → generate compiled handler pipeline
- Shutdown: graceful close → drain inflight requests → cleanup

---

# memory-bank/techContext.md

# Tech Context: Bun HTTP Server

## Technologies

- Bun runtime, latest stable (≥1.0)
- JavaScript (prefer TypeScript types internally)
- Bun’s native HTTP APIs (`Bun.serve`)
- Optional: Bun-specific APIs for file I/O, env, diagnostics

## Development Setup

- Run & reload via `bun run`
- Testing via Bun’s built-in test runner
- Profiling via Bun’s trace tools and external tools such as wrk, autocannon
- Version control: git

## Technical Constraints

- Must run natively in Bun (no Node.js compatibility shims)
- No external NPM packages — zero dependencies
- Avoid blocking patterns; fully async
- Resource efficient under heavy load
- Keep API minimal; extensible internally

## Dependencies

- None outside Bun itself

## Tool Usage Patterns

- Use Bun.serve as primary HTTP socket entry point
- Use async iterators and streams for efficient IO
- Use Bun Hash or built-in Map for fast header management if needed
- Employ Bun’s low-overhead timers/hooks if necessary

---

# memory-bank/activeContext.md

# Active Context: Current Server Development

## Current Focus

- Implement core route registration & matching
- Develop minimal but high-speed middleware pipeline
- Create simple example endpoints to benchmark performance
- Set up graceful shutdown hooks

## Recent Changes

- Prototyped a trie-based router, outperforming linear array
- Refined middleware composition to avoid promise nesting overhead
- Added low-latency request timestamping to aid profiling

## Next Steps

- Integrate health check endpoint
- Add structured logging capabilities
- Implement HTTP/2 (early support via Bun’s APIs)
- Document minimal developer-facing API
- Begin public benchmarking with wrk/autocannon

## Active Decisions

- Stay dependency-free
- Start with a minimal feature set; optimize hot paths first
- Prefer sync routing checks and async IO handlers
- Expose explicit lifecycle hooks for customization

## Preferences

- Keep core <500 LOC if possible
- Use idiomatic modern JS, minimal transpilation
- Favor explicit async/await over hidden promises

## Learnings & Insights

- Bun’s serve loop handles concurrency efficiently when avoiding heavy closures
- Precompiling route patterns yields significant improvements
- Lazy evaluation (e.g., for logging) reduces tail latency

---

# memory-bank/progress.md

# Project Progress: Bun Fast HTTP Server

## What Works

- Bun-based HTTP server bootstraps fast (~ms startup)
- Trie-based router with static/dynamic route matching
- Ultra-fast middleware chain with minimal overhead
- Handles concurrent requests >100k RPS in simple hello-world test
- Basic error handling + graceful shutdowns implemented

## Remaining Work

- Structured logging (JSON, levels)
- Robust health checks
- API documentation & examples
- HTTP/2 streaming support
- More complex routing features (params, wildcard)
- Compression (gzip/brotli opt-in)
- TLS support (via Bun APIs)

## Status

- **Core server MVP functional**
- High-performance goals met in internal benchmarks
- Preparing for feature hardening and developer ergonomics

## Known Issues

- Lack of HTTPS in initial versions
- Limited middleware hooks
- No built-in request validation
- No WebSockets yet (planned)
- Limited error observability (to improve with logging)

## Evolution of Project Decisions

- Initially considered external routing libraries → rejected for zero deps
- Switched from linear route array to trie → significant perf gains
- Middleware initially promise-based; now optimized with explicit chaining
- Will add opt-in features cautiously to preserve speed
