# hugo-simplecss

A theme for [Hugo](https://gohugo.io) that uses [Simple.css](https://simplecss.org).

A [live demo](https://hugo-simplecss.pages.dev/) based on the site generated from the `hugo new theme` command is available. It also demonstates how to customize Simple.css using the [example given in the docs](https://github.com/kevquirk/simple.css/wiki/Getting-Started-With-Simple.css#customise-simplecss).

## Features

Simple.css customization is defined in the partial `assets/css/simple-custom.css`, for example [`exampleSite/assets/css/simple-custom.css`](exampleSite/assets/css/simple-custom.css).

## Installation

```shell
hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/RyanBalfanz/hugo-simplecss.git themes/hugo-simplecss
echo "theme = 'hugo-simplecss'" >> hugo.toml
hugo server
```

## Configuration
