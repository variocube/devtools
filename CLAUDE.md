# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the Variocube developer tools repository. It provides shared configurations (EditorConfig, dprint) and coding guidelines that are installed into Variocube projects via `devtools.sh init`. The `.devtools` directory and symlinks are checked into target projects.

## Key Commands

- `./devtools.sh init` - Initialize devtools in a project (creates `.devtools`, `.vc` config, and symlinks)
- `./devtools.sh update` - Update devtools to latest version from repository
- `./devtools.sh setup` - Run initial build (npm install, gradlew build)
- `./devtools.sh assertSetup` - Verify prerequisites (Java, Node, npm, AWS CLI)
- `./devtools.sh databaseCreate` - Create local MySQL database from `.vc` config
- `./devtools.sh databaseImport [-d dump.sql]` - Import database dump (downloads from S3 if no file specified)
- `./devtools.sh tailLogs [-s stage]` - Tail CloudWatch logs (default stage: app)

## Repository Structure

```
devtools.sh          # Main installation/management script
dprint.json          # Code formatter config (TypeScript, JSON, Markdown)
.editorconfig        # Basic editor settings (tabs, line endings)
guidelines/          # Coding guidelines for different technologies
  java.md            # Lombok conventions, null handling, collections
  typescript.md      # Strict mode, types vs interfaces, Zod validation
  spring-boot.md     # Architecture (domain/entities/adapters), testing, config
  react.md           # Components, hooks, state management, API integration
idea/                # IntelliJ IDEA config files (linked into projects)
```

## Guidelines Summary

The `guidelines/` directory contains detailed coding standards. Key architectural concepts:

**Spring Boot Architecture** (4 layers):
1. **Domain Objects** - Immutable POJOs with Lombok `@Value`, `@Builder`, in `domain` package
2. **JPA Entities** - Mutable, named with `Entity` suffix, in `out.store` package
3. **Outbound Adapters** - External services/libraries, in `out` package (e.g., `out.store`, `out.pdf`)
4. **Application** - Commands in separate classes, in root package
5. **Inbound Adapters** - REST controllers, scheduled jobs, in `in` package (e.g., `in.web`, `in.timer`)

**React Structure**:
```
src/main/typescript/
├── api/       # API client and hooks
├── controls/  # Reusable UI components
├── hooks/     # Custom hooks
├── tenant/    # Feature modules (users/, groups/, bookings/)
└── utils/     # Utility functions
```

## Code Formatting

- **dprint** for TypeScript/JSON/Markdown formatting
- Tabs for indentation (4 spaces width for TypeScript, 2 for JSON/YAML)
- Line width: 120 characters
- No spaces inside braces for objects/imports in TypeScript

## Configuration File

Projects using devtools have a `.vc` file with environment-specific settings:
- `JAVA_VERSION`, `NODE_VERSION`, `NPM_VERSION`
- `VC_AWS_REGION`, `VC_AWS_PROFILE`
- `DATABASE_NAME` (for local MySQL operations)
- `CLOUD_WATCH_LOG_GROUP_<stage>` (for log tailing)
