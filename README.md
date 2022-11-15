# devtools

Variocube developer tools

## Usage

This repository is intended to be added as a submodule to consuming repositories.

```shell
$ git submodule add https://github.com/variocube/devtools .devtools
$ git add .gitmodules
$ git commit -m "chore: add devtools as submodule"
```

Config files that are read from specific locations like the project root can be symlinked from the submodule.

### EditorConfig

This repository contains a base config that can be applied to projects using a git submodule and
a symbolic link:

```shell
$ ln -s .devtools/config/.editorconfig
$ git add .editorconfig
$ git commit -m "chore: add .editorconfig from devtools"
```

The provided EditorConfig does not set the `root = true` directive. This allows developers to
provide certain settings from an EditorConfig in a parent directory, most notably the `tab_width`.

### dprint

dprint is a code formatter for JavaScript, TypeScript, JSON, Dockerfile, Markdown.

#### Use the provided configuration

```shell
$ ln -s .devtools/config/dprint.json
$ git add dprint.json
$ git commit -m "chore: add dprint.json from devtools"
```

#### Extend the provided configuration

Create a `dprint.json` file that extends the provided configuration

```json
{
  "extends": "https://dprint.dev/path/to/config/file.v1.json"
}
```

#### Configure IntelliJ

Install the `dprint` plugin for IntelliJ and enable it in settings.