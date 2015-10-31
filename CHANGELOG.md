## Version 2.0.0 - October 31, 2015

* A spoooooky release for Halloween!  Thanks to @xcambar for the following patches.
* Upgrade Emblem requirement to 0.6.1 and start using its built-in compiler.  This allows us to completely remove our custom processor.
* Replace the ".js.hbs" extension with plain ".hbs", which is the ember-cli default.
* Drop support for Node 0.8.x.

## Version 1.1.3 - February 9, 2015

* Rewrite bin/emblem2hbs in JavaScript and have it register coffee-script
* Remove node_modules from repo
* Clean up test suite output

## Version 1.1.2 - February 8, 2015

* Support non-escaped mustache tags in indentation as well as processor (issue #3)

## Version 1.1.1 - February 8, 2015 (yanked)

* Support non-escaped mustache tags (issue #3)

## Version 1.1.0 - January 29, 2015

* Support subexpressions (thanks @raycohen for the pull request!)

## Version 1.0.2 - January 22, 2015

* Bugfix: support all the value types in pairs as well as params
* Fixes to the test suite to close over the looped examples

## Version 1.0.1 - January 14, 2015

* Test suite based on Emblem's example docs
* Support for more of the param types that Emblem emits
* Officially support node.js 0.8.x and 0.11.x

## Version 1.0.0 - January 14, 2015

* Initial public release.