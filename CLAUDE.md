# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the Variocube developer tools repository. It provides shared configurations (EditorConfig, dprint) and coding guidelines that are installed into Variocube projects. The `.devtools` directory and symlinks are checked into target projects.

## Key Commands

- `./devtools.sh` - Install or update devtools (default action)
- `./devtools.sh update` - Alias for install/update
- `./devtools.sh db:create` - Create local MySQL database (prompts for name if not configured)
- `./devtools.sh db:drop` - Drop local MySQL database
- `./devtools.sh db:import` - Import database from S3 backup
- `./devtools.sh db:import -d dump.sql` - Import specific dump file (no AWS needed)
- `./devtools.sh db:clean` - Delete downloaded database dumps
- `./devtools.sh logs [-s stage]` - Tail CloudWatch logs (default stage: app)
- `./devtools.sh help` - Show help message

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

Projects using devtools may have an optional `.vc` file with environment-specific settings. This file is created interactively when commands require configuration:

- `DATABASE_NAME` (for local MySQL operations)
- `VC_AWS_REGION`, `VC_AWS_PROFILE` (for AWS operations)
- `CLOUD_WATCH_LOG_GROUP_<stage>` (for log tailing)
