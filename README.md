# devtools

Variocube developer tools

## Usage

This repository is intended to be consumed as a git submodule.

The developer is therefore responsible for initializing and updating the submodule in order to have the current version
linked in the project.

After cloning a repository that uses submodules, you have to initialize them:

```shell
git submodule update --init
```

`git` can be configured to automatically pull the currently linked version of submodules during `git pull`:

```shell
git config --global submodule.recurse true
```


### Adding devtools

```shell
git submodule add -f -b main --name devtools https://github.com/variocube/devtools .devtools
git config -f .gitmodules submodule.devtools.branch main
git config -f .gitmodules submodule.devtools.ignore all
git submodule init .devtools
git add .gitmodules .devtools
git commit -m "chore: add devtools as submodule"
```

Config files that are read from specific locations like the project root can be symlinked from the submodule.

### Upgrading devtools

Once the submodule has been initialized, there is helper script available to update to the current remote version:

```shell
.devtools/update.sh
```

Alternatively, you might want to issue these commands yourself:

```shell
git submodule update --init --remote
git add .devtools
git commit -m "chore: upgrade devtools"
```

## Configuration

### EditorConfig

EditorConfig provides basic editor settings that are supported out of the box by most editors.

Create a symbolic link to the editor config in your repository:

```shell
ln -s .devtools/.editorconfig
git add .editorconfig
git commit -m "chore: add .editorconfig from devtools"
```

The provided EditorConfig does not set the `root = true` directive. This allows developers to
provide certain settings from an EditorConfig in a parent directory, most notably the `tab_width`.

### dprint

dprint is a code formatter for JavaScript, TypeScript, JSON, Dockerfile, Markdown.

Add the `dprint` package to your project:

```shell
npm install --save-dev dprint
```

You can use the provided configuration or if needed, create a project-specific configuration that
extends the provided configuration.

#### Use the provided configuration

```shell
ln -s .devtools/dprint.json
git add dprint.json
git commit -m "chore: add dprint.json from devtools"
```

#### Extend the provided configuration

Create a `dprint.json` file that extends the provided configuration

```json
{
  "extends": ".devtools/config/dprint.json"
}
```

Add it to git and commit:

```shell
git add dprint.json
git commit -m "chore: add dprint.json that extends devtools"
```

#### Configure IntelliJ

Install the `dprint` plugin for IntelliJ and enable it in settings.

Add and commit the config files created for the `dprint` plugin in the `.idea` directory. 
