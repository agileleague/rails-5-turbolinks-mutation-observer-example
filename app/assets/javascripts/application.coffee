#= require jquery
#= require jquery_ujs
#= require selector_observer
#= require turbolinks

observer = new SelectorObserver()

observer.add '[data-color]', (nodes) ->
  for node in nodes
    node.style.color = node.dataset.color

#observer.remove '[data-color]', (nodes) ->
  #for node in nodes
    # ...
