
dule (Component) Loading

---

Component loading should be flexible, powerful and simple.  It should work with minimal setup, but should give you enough contorl to be able to fine-tune its behavior so you can squeeze out ultimate performance from your application.  It should take advantage of a "component" based architecture.  It should handle all text-based assets, including javascript, templates and stylesheets (LESS,CSS).  The Component loader should also have a cache-busting mechanism built into it based on file contents hashes.


## Page Load

We'll define *page load* as the state of the UI once it has finished loading, prior to any action on the part of the user.  For example, domready may fire, and xhr calls may kick off (hopefully not too many, include those in the initial request if possible).  Once that initial bootstrapping is done, that is considered *page loaded*.

On page load, we want **ONE** ```css``` file, and **ONE** ```js```file.  (We could concede a second JS request if pulling a common lib like jQuery from a common CDN means a higher chance of a browser cache hit)

+	CSS file should contain only the styles required for whatever is going to be displayed on page load.

+	JS file should contain only the resources needed for bootstrapping the application, and the initial state of the UI.  We would like the ability to "preload" other resources, but defer parsing them until needed.  This gives us the ability to include resources that have a high likelihood of being required after *page load*, but not parsing them until that actually happens.  We avoid additional network calls, and avoid additional parse time on *page load*.

## On Demand

By *on demand* we mean loading resources that are required for subsequent actions after *page load*.  For example, on *page load* we may not deliver the assets required for a specific dialog.  Once the user launches that dialog we need to load **ONE** js file (that includes templates and javascript), and **ONE** css file (combined/compiled LESS,CSS for component).  Optionally, we may include deferred assets as well, similar to the *page load* payload that we cache on the client, and parse/eval at a later time when they are needed.

## Component Definition

A component should be organized in it's own directory, and defined by a component.json file in it's root.  It may consist of sub-folders to help organize its contents.  That definition may look as follows:

```
{
	name : 'components/name', // unique, and typically the path on the file system
	
	assets : [ // required assets for this component
		'name.js',
		'name.less',
		'name.css',
		'name.html', // handlebars template
		'name.jade', // jade template
		'subfolder' // a sub-component relative to this one with it's own component.json definition
	],
	deferredAssets : [
		'/component/sample' // this component will be included, but "deferred" until needed at runtime
	],
	dependencies : [ // these components must be loaded prior as they are required within this component
		'components/a',
		'components/b'
	]
}
```

## Implications

A ```Component``` loader as described has implications across the application.  While ```require.js``` offers dependency injection, and will load assets on demand, we need something more intelligent and flexible to ensure performance.  It does not provide the concept of ```deferred``` loading, or handle the concept of a cross functional ```component``` very well (css, precompiling templates).

+	server side build process
	+	dynamic serving or watch capability for dev
	+	create optimized js/css files for each component
	+	version the files with content hash
+	client side loading api
	+	track state of loaded components (Deferreds ftw)
	+	cache ```deferred``` components and eval/load when required
	+	manifest of component hash versions
	+	instrumentation within application to know when to load components
		+	perhaps organized by UIs?

Components will each have their own build process, as well as have the necessary implementations to provide all of these features (through a common api or delegation).

## Asset Types

Asset types are handled individually, but javascript and templates are rolled into a single payload/file.  Each payload should also have the ability to defer it's eval/load into the client.

### Javascript

+	Combine and minify
+	Order matters
+	jshint?
+	deferred payload becomes a string

### Templates

+	handle multiple compilers (handlebars initially)
+	always precompile if possible, no need to do that in the browser
+	combine into javascript payload
	+	wrap in a register function for client side: ```loader.registerTemplate('name', compiledFunc(...))```
+	deferred payload becomes a string

### Stylesheets

+	handle LESS compilate
	+	deal with import() statements within files (just have to get pathing correct during compilation)
+	don't compile CSS
+	combine all compiled LESS and CSS into single payload
+	deferred payload
	+	can we keep it a string and set the innerHTML of a <style> tag when needed?

## Distribution

Component loader can exist as an npm module.
