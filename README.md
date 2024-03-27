# GOV.UK One Login technical documentation

This documentation is for government services that want to integrate with GOV.UK One Login to:

* authenticate their users
* verify their users' identity  

## Preview your documentation changes

To preview any changes and additions you have made to the documentation in a browser, clone this repo and use the [Dockerfile in this repo](Dockerfile) to run a Middleman server on your machine without having to set up Ruby locally.

This setup has live reload enabled, which means your changes will be applied as you edit files in the source directory. The only exception to this is if you make changes to `config/tech-docs.yml`, you must stop and restart the server to see your changes in the preview. You can stop the server with `Ctrl-C`.

Run the [helper script](preview-with-docker.sh):

```bash
./preview-with-docker.sh
```

It may take a few minutes to build the docker container, particularly if it is your first time running the script. When the server has finished loading you should then see the following output in the terminal:

```bash
== View your site at "http://localhost:4567", "http://127.0.0.1:4567"
== Inspect your site configuration at "http://localhost:4567/__middleman", "http://127.0.0.1:4567/__middleman"/usr/local/bundle/gems/tilt-2.0.11/lib/tilt/redcarpet.
```

## Making changes to content

To add or change content, edit the markdown in the `.html.md.erb` files in the `source` folder.

Although a single page of HTML is generated, the markdown is spread across multiple files to make it easier to manage. 

A new markdown file is not automatically included in the generated output. If you add a new markdown file at the location `source/agile/scrum.md`, the following snippet in `source/index.html.md.erb` will include it in the generated output.

`<%= partial 'documentation/scrum' %>`

Including files manually like this enables you to specify the position they appear on the page.

The sections in the documentation are controlled by the use of markdown headers, not the file structure.

Images to be included in the docs are kept in `source/images`

In order to configure some aspects of layout, like the header, edit `config/tech-docs.yml`.

If you move pages around and URLs change, make sure you set up redirects from the old URLs to the new URLs.

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