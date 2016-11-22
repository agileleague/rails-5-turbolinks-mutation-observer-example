# README

This is an example of using MutationObserver with Rails 5
and Turbolinks to register JavaScript initializer functions that work
with Turbolinks navigation without subscribing to Turbolinks navigation
events.

Download and `bundle install`. Then start the server with
`./bin/rails server`.

Open the homepage: localhost:3000 . Use the "Go to detail" and "Go to index"
links to navigate between the detail and index pages using Turbolinks.

These pages generate a randomly ordered listing of divs that look like:

     <div data-color="purple">purple</div>

Check out [application.coffee](app/assets/javascripts/application.coffee) and
[selector_observer.coffee](app/assets/javascripts/selector_observer.coffee).

SelectorObserver wraps MutationObserver and exposes an interface for
registering callback functions on groups of nodes matching a given
selector as they are added or removed from the document.

application.coffee code uses the SelectorObserver to watch for nodes
matching which data-color attributes being added to the dom and setting
their color as specified in data-color. As a user's browser navigates
the site, whether using Turbolinks-powered AJAX requests or traditional
browser requests, any added data-color nodes will be appropriate
colored. To be clear, it is not an exemplary approach for coloring
text on a page. It just illustrates the basic pattern.

SelectorObserver follows MutationObserver's lead and notifies
additions and removals in groups rather than one at a time.


SelectorObserver does not use
MutationObserver events to perform its initialization of the DOM
on first page load. Instead it waits for [jQuery.ready()](https://api.jquery.com/ready/)
and then scans the document.body and notifies the additions using the
same intializers registered with SelectorObserver. All
further DOM mutations will be handled via MutationObserver. In my own
work this has proven to be a more reliable way of initializing a page
using this mechanism.

You may also see a "bounce" when navigating between pages that are already
in your history. This is because Turbolinks is pre-rendering pages from
history and the historical version does not match the server-rendered
version -- which are a randomly generated ordering of those color divs.
In normal scenarios, the server would probably not be generating the
data randomly, but it does illustrate the point that Turbolinks will
revive a version of the document that may be out of date.  For example,
form inputs could have changed on the historical version.

# More improvement

- What about attributes changes?
- Would for..of be faster than forEach where available?

# Credits

Thanks to [@javan](https://github.com/javan) for thorough guidance to improve this example:
https://github.com/turbolinks/turbolinks/issues/159#issuecomment-242982424
