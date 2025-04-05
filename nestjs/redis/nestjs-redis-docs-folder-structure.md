# Redis Library Documentation Structure (LLM-friendly Overview)

Clearly-organized versioned documentation tree for a Redis client or library, with grouping and description to help understanding.

---

# Root: docs/

## Latest (Main branch / Most recent documentation)
Located in: `docs/latest/`

- `cluster.md` — Using Redis Cluster features
- `examples.md` — Common code examples
- `redis.md` — Client usage, API, and features

---

### Typical file roles per version

- **`cluster.md`**  
  How to configure and use Redis Cluster in this version.
  
- **`examples.md`**  
  Usage examples tailored for this version.
  
- **`health-checks.md`**  
  How to configure or use integrated health checks (where present; missing in v2 & v9).
  
- **`redis.md`**  
  Main API reference or usage guide.

- **`README.md`** (v2-only)  
  High-level intro and notes.

---

## Summary

- **Documentation is versioned:** separate folder for major versions `v2, v3, ..., v9` plus a `latest` directory
- **Most versions have:**  
  Cluster usage guide, Examples, Core Redis usage, Health checks (v3-v8)  

---
