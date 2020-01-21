# Dox-Style

Dox-style centralizes our `.rubocop.yml` so that it may be shared between ruby projects.

## Installation

Add this to your application's Gemfile:

```ruby
source "https://doximity.jfrog.io/doximity/api/gems/gems-local" do
  group :development do
    gem "dox-style"
  end
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dox-style

## Quick Setup

Run the generator to create or append the inheritence of this gem's .rubocop.yml

    $ rails g dox_style

## Usage

The Quick Setup will either create, replace, or update your `.rubocop.yml` at the root directory with the following.

```yml
inherit_gem:
  dox-style:
    - .rubocop.yml
```

# Development

## Making Changes
Because the dox-style rubocop is used by every team and every repo it is important that consensus is reached when making changes.  In order to ship changes to the dox-style repo you must get code review approval from a majority of tech leads (see https://github.com/doximity/dox-style/tree/master/.github/CODEOWNERS ) as well as approval Jey, Bruno or Rodrigo.

## Gem documentation

You can find the documentation by going to CircleCI, looking for the `build` job, going to Artifacts and clicking on `index.html`. A visual guide on this can be found in our wiki at [Gems Development: Where to find documentation for our gems](https://wiki.doximity.com/articles/gem-development-where-to-find-documentation-for-our-gems).

## Gem development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bundle console` for an interactive prompt that will allow you to experiment.

This repository uses a gem publishing mechanism on the CI configuration, meaning most work related with cutting a new
version is done automatically.

To release a new version, follow the [wiki instructions](https://wiki.doximity.com/articles/gems-development-releasing-new-versions).
