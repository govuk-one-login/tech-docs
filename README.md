# GOV.UK One Login technical documentation

This repo contains documentation to help technologists at government departments onboard to GOV.UK One Login. It’s published using the Technical Documentation Template.

## Making content changes
The GOV.UK One Login technical writing team owns this documentation and has responsibility for approving content changes. It’s written to be user-centred and meet GDS content standards, which means following:

* [GOV.UK guidance on planning, writing and managing content](https://www.gov.uk/guidance/content-design/writing-for-gov-uk)
* the [GOV.UK style guide](https://www.gov.uk/guidance/style-guide/a-to-z-of-gov-uk-style)
* the [GOV.UK technical style guide](https://www.gov.uk/guidance/style-guide/technical-content-a-to-z)
* other clear writing principles

If you work on GOV.UK One Login, you should contact the tech writing team for help with content changes unless it’s small and does not affect user behaviour.

Small content changes include:
* adding clarifications to improve understanding
* correcting code samples
* fixing broken links or typos

You can make these changes yourself and then request a tech writer review on the pull request. If you’re not sure whether a change is small, contact us on our [#di-technical-writing](https://gds.slack.com/archives/C02DHELL5HA) Slack channel.

## Making technical changes

The Orchestration team is responsible for the maintenance and operational health of the tech docs platform. You should consult them for approval of any changes in that space.

Examples include:
* changes to GitHub action workflows
* changes to the AWS deployment or build infrastructure
* dependency updates
* Ruby updates that do not change the content

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

## Making changes to a diagram
Diagrams are content, so once you've made a change you should request a review from the technical writing team.

You can edit the draw.io files in the `source/images/originals` folder by installing and using the draw.io desktop app.

Use one draw.io file per diagram.

### Installing the draw.io desktop app
Run the following commands to use the draw.io desktop app from the command line.

```
brew install --cask drawio
alias draw.io='/Applications/draw.io.app/Contents/MacOS/draw.io'
```

### Editing and publishing a diagram
Follow these steps:
1. Create and modify a diagram using [draw.io](https://about.draw.io/).
2. Save the draw.io file to the `source/images/originals` folder.
3. Publish the diagram as a [scalable vector graphic (SVG)](https://www.w3.org/Graphics/SVG/).
4. Save the SVG file to the `source/images` folder.

### Useful commands
Update a diagram:
```
draw.io source/images/originals/top-level-technical-diagram.drawio
```
Generate SVG versions of the diagrams and save them to the `source/images/originals` folder:
```
draw.io -x -o source/images/top-level-technical-diagram.svg source/images/originals/top-level-technical-diagram.drawio

draw.io -x -o source/images/technical-flow-diagram.svg source/images/originals/technical-flow-diagram.drawio
```

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