Create a new Hugo site and theme.

```shell
hugo new site exampleSite
cd exampleSite
hugo new theme simplecss
```

From the site directory, start the server.

```shell
hugo server --buildDrafts
```

The web server should be available at locally, by default at http://localhost:1313/. However, there is currently no content. As expected Hugo responds accordingly with a `404` and `<h1>Page Not Found</h1>` content.

```shell
❯ curl --head http://localhost:1313/
HTTP/1.1 404 Not Found
Date: Tue, 16 Jan 2024 06:06:03 GMT
Content-Length: 24
Content-Type: text/html; charset=utf-8
❯ curl http://localhost:1313/
<h1>Page Not Found</h1>
```

However, the generated theme does contain content. Working from the theme directory, starting the server and visiting the site does display the starter content.

```shell
cd themes/simplecss
hugo server --buildDrafts
```

Now we can start to build out our theme using Simple.css. Later, we will go back to the original site directory at the root of our repository.

Our theme, which is also a working Hugo site, already has some styles defined in `assets/css/main.css`. And the template works by adding that file to our HTML document as defined in `layouts/partials/head/css.html`. To keep things simple let's just add Simple.css to our theme site using the CDN hosted version. Append the new link tag to the end of the `css.html` file. This is will work, but cause some undesired effects because of the existing `main.css` styles. Refresh the page in your browser to see the changes.

```diff
--- a/exampleSite/themes/simplecss/layouts/partials/head/css.html
+++ b/exampleSite/themes/simplecss/layouts/partials/head/css.html
@@ -7,3 +7,4 @@
     {{- end }}
   {{- end }}
 {{- end }}
+<link rel="stylesheet" href="https://cdn.simplecss.org/simple.css">
```

To fix the the broken site appearance will want to remove the default inclusion of `main.css` in the partial file, or replace it with a similar template that uses a self-hosted Simple.css file. The former is simple, just remove all the default text above the `link` tag we just added. Going forward, let's self-host Simple.css for this example.

Download the Simple.css source as described at [Option 4 - self-host Simple.css](https://github.com/kevquirk/simple.css/wiki/Getting-Started-With-Simple.css#option-4---self-host-simplecss) and place the un-minified `simple.css` in the same directory as the existing `main.css`.

```shell
❯ ls -l assets/css                                     
total 40
-rw-r--r--  1 ryan  staff    284 Jan 15 21:58 main.css
-rw-r--r--@ 1 ryan  staff  12622 Jan 15 22:42 simple.css
```

Now, undo the addition of the `link` tag we previously added to the partial `css.html`. Then, change the reference to `css/main.css` to `css/simple.css`. As compared to the originally generated file, our new change looks like this:

```diff
--- a/exampleSite/themes/simplecss/layouts/partials/head/css.html
+++ b/exampleSite/themes/simplecss/layouts/partials/head/css.html
@@ -1,4 +1,4 @@
-{{- with resources.Get "css/main.css" }}
+{{- with resources.Get "css/simple.css" }}
   {{- if eq hugo.Environment "development" }}
     <link rel="stylesheet" href="{{ .RelPermalink }}">
   {{- else }}
```

Now our site should appear in a browser as expected.

But, there is one more things can do to make our template even more Simple.css-ified. Let's update the header navigation to show if one of the list items is the current page. Simple.css will supports this by adding to the `current` class to an element.

By default, the generated template already renders the current menu item differently. But it doesn't include a `current` class. Let's add that now, in addition to the already included `active` class.

```diff
--- a/exampleSite/themes/simplecss/layouts/partials/menu.html
+++ b/exampleSite/themes/simplecss/layouts/partials/menu.html
@@ -23,7 +23,7 @@ Renders a menu for the given menu ID.
   {{- range .menuEntries }}
     {{- $attrs := dict "href" .URL }}
     {{- if $page.IsMenuCurrent .Menu . }}
-      {{- $attrs = merge $attrs (dict "class" "active" "aria-current" "page") }}
+      {{- $attrs = merge $attrs (dict "class" "active current" "aria-current" "page") }}
     {{- else if $page.HasMenuCurrent .Menu .}}
       {{- $attrs = merge $attrs (dict "class" "ancestor" "aria-current" "true") }}
     {{- end }}
```

Now, our menu will render with the current item displayed using the Simple.css accent color. As described at [Customise Simple.css](https://github.com/kevquirk/simple.css/wiki/Getting-Started-With-Simple.css#customise-simplecss), this accent color is easily changed. Let's build this functionality into our template.

Add a new file containing the example customization CSS at `assets/css/simple-custom.css`.

```shell
❯ ls assets/css
main.css                simple-custom.css       simple.css
❯ cat assets/css/simple-custom.css                     
:root {
    --accent: red;
}
```

And finally, copy the entire contents of the partial `css.html` and paste it in the same file. Update the new block to get the new file we just created and populated. Refresh your browser to see the new accent color in action!

With a working theme we can move back to top-level site we started from. From the theme directory at `themes/simplecss` change up two levels to the repository root. After starting the Hugo server from here and visiting the site in a browser will again yield `Page Not Found` error.

In the usual way, tell Hugo to use our new theme we just built by adding `theme = 'simplecss'` to the site's configuration (e.g. `hugo.toml`). Now, with the server running, refresh your browser to see things working again… sort of. You should see the same content as we did when working from the theme directory itself. This may not be expected, and is almost certainly not what wanted. Many themes ship with a directory _inside_ the theme directory called `exampleSite`. Let's build our example site at the repository root consider moving it into the theme directory.

An easy first thing to do is remove our Simple.css customizations (changing the accent color). From the repository root create a new customization file. Creating a new empty file with the same name as that of our template is sufficient to revert back to the Simple.css defaults.

```shell
mkdir assets/css   
touch assets/css/simple-custom.css
```

Similarly, creating a replacement home page will override the theme's placeholder text.

```shell
❯ hugo new _index.md
Content "/Users/ryan/Desktop/Hugo-Theme-Simple/exampleSite/content/_index.md" created
❯ cat content/_index.md           
+++
title = ''
date = 2024-01-15T23:34:14-08:00
draft = true
+++
This is the example site home page.

```

Refreshing your browser (with the Hugo server running, of course) should now show the original accent color and the new content on the Home page.

To further drive this point home, let's edit the template site's name to differentiate it from our main site.
