# Authentication technical documentation

TBA

# Getting Started

To see the version of Ruby used by the application, see [the ruby-version file](.ruby-version).

## Install Ruby

Start by installing [rbenv](https://github.com/rbenv/rbenv) and [ruby-build](https://github.com/rbenv/ruby-build):
```
brew upgrade rbenv ruby-build
```
This will allow you to compile Ruby, and makes it easier to manage multiple Ruby environments (macOS comes with Ruby installed, so this simplifies things).

Download the current version of Ruby that the [application uses](.ruby-version):
```
rbenv install $(cat .ruby-version)
```

Set your local Ruby version to match what `rbenv` installed in the previous step:
```
rbenv local $(cat .ruby-version)
```

Install the application's dependencies:

```
bundle install
```

### Fix `ffi` bug on MacOS

There's an incompatibility issue with the latest MacOS and the `ffi` library which stops Middleman from starting on MacOS.

To fix the issue you must stop the `ffi` gem using the native `libffi` library by sending this command:

```shell script
gem install ffi -- --disable-system-libffi
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

```
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

```
== The Middleman is loading
== LiveReload accepting connections from ws://192.168.0.8:35729
== View your site at "http://Laptop.local:4567", "http://192.168.0.8:4567"
== Inspect your site configuration at "http://Laptop.local:4567/__middleman", "http://192.168.0.8:4567/__middleman"
You should now be able to view a live preview at http://localhost:4567.
```
Changes to the tech-docs.yml file require stopping and restarting the server to show up in the preview. You can stop it with Ctrl-C.

## Code of conduct

Please refer to the `alphagov` [code of conduct](https://github.com/alphagov/code-of-conduct).

## Licence

Unless stated otherwise, the codebase is released under [the MIT License][mit].
This covers both the codebase and any sample code in the documentation.

The documentation is [© Crown copyright][copyright] and available under the terms of the [Open Government 3.0][ogl] licence.

[mit]: LICENCE.md
[copyright]: http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/
[ogl]: http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
