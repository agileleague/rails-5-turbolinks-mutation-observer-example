class SelectorProcessor
  constructor: ->
    @selectors = {}
  add: (selector, callback) ->
    @selectors[selector] ?= []
    @selectors[selector].push(callback)
  processElements: (elements) =>
    executions = new Map()
    elements.forEach (e) =>
      @processElement(e, executions)
    executions.forEach (elements, callback) ->
      callback(elements)

  processElement: (element, executions) =>
    for selector, callbacks of @selectors
      for matchingElement in @findMatchingElements(element, selector)
        for callback in callbacks
          selectorArr = executions.get(callback)
          if selectorArr && selectorArr.length
            selectorArr.push(matchingElement)
          else
            executions.set(callback, [matchingElement])

  findMatchingElements: (element, selector) ->
    elements = []
    elements.push(element) if matches(element, selector)
    elements.concat(element.querySelectorAll(selector)...)

  matches = do ->
    element = document.documentElement
    method = element.matches ?
      element.matchesSelector ?
      element.webkitMatchesSelector ?
      element.mozMatchesSelector ?
      element.msMatchesSelector

    (element, selector) ->
      method.call(element, selector)

class @SelectorObserver
  constructor: ->
    @addProcessor = new SelectorProcessor()
    @removeProcessor = new SelectorProcessor()
    @observer = new MutationObserver @processMutations
    $ =>
      setTimeout (=>
        @observer.observe document, childList: true, subtree: true
        @processBody()
      ), 1

  add: (selector, callback) ->
    @addProcessor.add(selector, callback)

  remove: (selector, callback) ->
    @removeProcessor.add(selector, callback)

  processBody: () ->
    @addProcessor.processElements([document.body])

  processMutations: (mutations) =>
    addedElements = new Set
    removedElements = new Set

    for mutation in mutations
      switch mutation.type
        when "childList"
          for node in mutation.addedNodes when node.nodeType is Node.ELEMENT_NODE
            addedElements.add(node)
          for node in mutation.removedNodes when node.nodeType is Node.ELEMENT_NODE
            removedElements.add(node)

    @removeProcessor.processElements(removedElements)
    @addProcessor.processElements(addedElements)
