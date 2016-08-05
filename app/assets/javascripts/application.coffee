#= require jquery
#= require jquery_ujs
#= require turbolinks

inspector =
  selectors: []
  process: (node) ->
    return unless node.querySelectorAll
    for [selector, callback] in @selectors
      for foundNode in node.querySelectorAll(selector)
        callback(foundNode)
  watch: (selector, callback) ->
    @selectors.push([selector, callback])


formatColor = (node) ->
  node.style.color = node.dataset.color

inspector.watch('[data-color]', formatColor)

observer = new MutationObserver (mutations) ->
  for mutation in mutations
    for node in mutation.addedNodes
      inspector.process(node)

observer.observe document, childList: true, subtree: true
