# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the Variocube developer tools repository. It provides shared **formatter/editor configuration** (EditorConfig, dprint, Eclipse formatter) and the management script (`devtools.sh`) that are installed into Variocube projects. The `.devtools` directory and symlinks are checked into target projects.

**Coding guidelines and Claude context have moved** to the workspace repo (`variocube/.claude/`, auto-loaded for every repo). devtools no longer ships `guidelines/` or `PROJECT_CLAUDE.md`. devtools now owns only the things that must be physical files in each repo: formatter configs + this script.

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
devtools.sh              # Main installation/management script
eclipse-formatter.xml    # Java formatter config (Eclipse JDT format)
dprint.json              # Code formatter config (TypeScript, JSON, Markdown)
.editorconfig            # Basic editor settings (tabs, line endings)
idea/                    # IntelliJ IDEA config files (linked into projects)
test/                    # Formatter test setup (excluded from installation)
  FormatterTest.java     # Test file with all Java language constructs
  build.gradle.kts       # Gradle + Spotless for running formatter
  gradlew                # Gradle wrapper
```

## Coding Guidelines

Coding guidelines now live in the **workspace** repo at `variocube/.claude/guidelines/`
(`general`, `java`, `typescript`, `spring-boot`, `react`, `ui-ux`) and are referenced from the
workspace `CLAUDE.md`, which auto-loads for every repo. Edit them there — not here.

## Code Formatting

### TypeScript/JSON/Markdown (dprint)

- Tabs for indentation (4 spaces width for TypeScript, 2 for JSON/YAML)
- Line width: 120 characters
- No spaces inside braces for objects/imports in TypeScript

### Java (Eclipse Formatter)

Configuration in `eclipse-formatter.xml`, used via IntelliJ's Eclipse Code Formatter plugin.

**Key alignment values** (bit flags):
- `48` = M_ONE_PER_LINE_SPLIT (wrap one per line when needed)
- `49` = 48 + M_FORCE (always wrap one per line)
- `80` = M_NEXT_PER_LINE_SPLIT (first element stays, rest wrap when needed)
- `81` = 80 + M_FORCE (always wrap, first stays on same line)

**Current settings**:
| Setting | Value | Effect |
|---------|-------|--------|
| `alignment_for_selector_in_method_invocation` | 81 | Method chaining always wraps at dots |
| `alignment_for_parameters_in_method_declaration` | 48 | Params wrap one-per-line when line > 120 |
| `alignment_for_parameters_in_constructor_declaration` | 48 | Same for constructors |
| `alignment_for_enum_constants` | 49 | Enum values always on separate lines |
| `alignment_for_assignment` | 0 | Never wrap after `=` (chain wraps at dots instead) |
| `insert_space_before_colon_in_case` | do not insert | No space before `:` in switch cases |

**Known limitation**: Eclipse formatter cannot put closing `)` on its own line when params wrap. The closing paren stays on the same line as the last parameter.

### Testing Formatter Changes

```bash
cd test
./gradlew spotlessApply    # Apply formatter to FormatterTest.java
./gradlew spotlessCheck    # Check if formatting is correct (CI mode)
```

The `test/` directory is excluded from installation in consuming projects.

## Configuration: registry first, `.vc` fallback

AWS profile/region and CloudWatch log groups are resolved from the **workspace registry**
`projects.json` (found by walking up the directory tree), keyed by the repo directory name:

- profile/region ← `(.projects[$repo].aws // .defaults.aws)`
- log group ← `.projects[$repo].stages[<stage>].logGroup`

If the registry, `jq`, or a specific key is unavailable, devtools falls back to the per-repo `.vc`
file (and finally an interactive prompt). The `.vc` file is being phased out in favor of the
registry; `DATABASE_NAME` for local MySQL still lives in `.vc` for now.
