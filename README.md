# GOV.UK One Login technical documentation

This documentation is for government services that want to integrate with GOV.UK One Login to:

* authenticate their users
* verify their users' identity  

## Getting Started

To see the version of Ruby used by the application, see [the ruby-version file](.ruby-version).

## Install Ruby

Start by installing [rbenv](https://github.com/rbenv/rbenv) and [ruby-build](https://github.com/rbenv/ruby-build):

```bash
brew upgrade rbenv ruby-build
```

This will allow you to compile Ruby, and makes it easier to manage multiple Ruby environments (macOS comes with Ruby installed, so this simplifies things).

Download the current version of Ruby that the [application uses](.ruby-version):

```bash
rbenv install
```

Install the application's dependencies:

```bash
bundle install
```

### Fix `ffi` bug on MacOS

There's an incompatibility issue with the latest MacOS and the `ffi` library which stops Middleman from starting on MacOS.

To fix the issue you must stop the `ffi` gem using the native `libffi` library by sending this command:

```shell script
bundle config build.ffi --disable-system-libffi
bundle install # reinstall
```

## Making changes

To make changes, edit the markdown files in the source folder.

Although a single page of HTML is generated, the markdown is spread across multiple files to make it easier to manage. They can be found in `source/`.

A new markdown file is not automatically included in the generated output. If you add a new markdown file at the location `source/agile/scrum.md`, the following snippet in `source/index.html.md.erb` will include it in the generated output.

`<%= partial 'documentation/scrum' %>`

Including files manually like this enables you to specify the position they appear on the page.

The sections in the documentation are controlled by the use of markdown headers, not the file structure.

Images to be included in the docs are kept in `source/images`

In order to configure some aspects of layout, like the header, edit `config/tech-docs.yml`.

### Workflow

The repository uses Github actions.

Before committing any changes, the contributor should run this command in the application directory:

```bash
bundle exec middleman build
```

This command mimics the command run by the Github Actions Build Agent.

### Preview

Whilst writing documentation, you can run a middleman server to preview how the published version will look in the browser.

The preview is only available on your own computer. Others will not be able to access it if you give them the link.

Type one of the following to start the server:

* `bundle exec middleman server` - if you have ruby installed locally
* `./preview-with-docker.sh` - if you have Docker installed

If all goes well, something like the following output will be displayed:

```bash
== The Middleman is loading
== LiveReload accepting connections from ws://192.168.0.8:35729
== View your site at "http://Laptop.local:4567", "http://192.168.0.8:4567"
== Inspect your site configuration at "http://Laptop.local:4567/__middleman", "http://192.168.0.8:4567/__middleman"
You should now be able to view a live preview at http://localhost:4567.
```

Changes to the tech-docs.yml file require stopping and restarting the server to show up in the preview. You can stop it with Ctrl-C.

## Linting the GOV.UK One Login Technical Documentation

This repository uses [Vale](https://vale.sh/) and the [GDS Tech Docs Linter ruleset](https://github.com/alphagov/tech-docs-linter).

### Installing the linter on your local machine

You need to:

* install [Homebrew](https://brew.sh/)
* install [Vale](https://vale.sh/docs/vale-cli/installation/)

### Linting with your code editor

Many code editors provide extensions or plugins for Vale which can raise errors as you update documentation. You will still need Vale installed on your local machine.

### Linting with Vale Command Line Interface (CLI)

By default, Vale must be run from the same directory as this config file, unless the `--config` flag is provide with a path.
To run the linter using Vale CLI:

1. In a terminal window, navigate to your repo.
1. Run `vale sync` to download the latest tech-docs-linter package and unzip this to your `StylesPath` listed in your config file.
1. Run the command `vale .` to lint the entire repo or provide a path to a directory to lint only that directory for example: `vale ./source/go-live`

### Updating to the latest tech docs linter ruleset

If a new rule is added to the tech docs linter ruleset, you can upversion the package used by this repo when you're ready.
A later version of the ruleset can be tested and added by:

1. Create a branch.
1. Update the package version number in the [Vale config file](.vale.ini).
1. Run `vale sync` to download and unzip the latest package.
1. Run `vale ./source` to test the linter.
1. Fix any changes new ruleset throws up (preferably one commit for each rule violation).
1. Raise a PR with the latest version number in the vale config file.


## Code of conduct

Please refer to the `alphagov` [code of conduct](https://github.com/alphagov/code-of-conduct).

## Licence

Unless stated otherwise, the codebase is released under [the MIT License][mit].
This covers both the codebase and any sample code in the documentation.

The documentation is [© Crown copyright][copyright] and available under the terms of the [Open Government 3.0][ogl] licence.

[mit]: LICENCE.md
[copyright]: http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/
[ogl]: http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
