# devtools

Variocube developer tools

## Usage

The developer is therefore responsible for updating the submodule in order to have the current version
available in the project. Luckily, git can do this automatically when the following configuration is set:

```shell
# Tells git to automatically update submodules
git config --global submodule.recurse true
```

### Adding the submodule

```shell
git submodule add -f -b main --name devtools https://github.com/variocube/devtools .devtools
echo -e "\tignore = all" >>.gitmodules
git submodule init .devtools
git add .gitmodules .devtools
git commit -m "chore: add devtools as submodule"
```

Config files that are read from specific locations like the project root can be symlinked from the submodule.

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
