# README

This is Rails 5 example of using MutationObserver with Rails 5
and Turbolinks to register JavaScript initializer functions that work
with Turbolinks navigation without subscribing to Turbolinks navigation
events.

Download and `bundle install`. Then start the server with `bundle exec
rails server`.

Open the homepage: localhost:3000 . Use the "Go to detail" and "Go to index"
links to navigate between the detail and index pages using Turbolinks.

These pages generate a randomly ordered listing of divs that look like:

     <div data-color="purple">purple</div>

Check out [application.coffee](app/assets/javascripts/application.coffee).  This is a use of the MutationObserver
that will scan all nodes added to the page.  It is not a good example of
how to color text on a page, but it does illustrate a pattern for
initializing JavaScript that can will be run on the first page load and
any time that an applicable node gets added to the document -- whether
through the body-replacement of Turbolinks navigation or any other
means.

You will see a "bounce" when navigating between pages that are already
in your history. This is because Turbolinks is pre-rendering pages from
history and the historical version does not match the server-rendered
version -- which are a randomly generated ordering of those color divs.
In normal scenarios, the server would probably not be generating the
data randomly, but it does illustrate the point that Turbolinks will
revive a version of the document that may be out of date.  For exmaple,
form inputs could have changed on the historical version.


# Questions

- Is this the best way to search for new nodes in a MutationObserver?
- Are the childList and subtree options the best for this behavior?
- Should we be loading the JavaScript in the head of the document?
- Should the MutationObserver be targetting the document?
