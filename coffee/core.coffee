$ ()->
  window.lab = window.lab or {}
  window.lab.ui = window.lab.ui or {}
  focusFlagAttribute = 'data-viewport-focus'
  # Creates a delegate to a method with a context. The delegate can be invoked by invoke method.
  delegate = (context, method)->
    invoke: ()-> method.apply context, arguments

  # returns true if the first rectangle intersects the second rectangle, else false
  intersects = (r1, r2)->
    r1 = $.extend {}, r1
    r2 = $.extend {}, r2
    if r1.width <= 0 or r1.height <= 0 or r2.width <= 0 or r2.height <= 0
      return false
    for rectangle in [r1, r2]
      rectangle.right = rectangle.left + rectangle.width
      rectangle.bottom = rectangle.top + rectangle.height
    return r1.right > r2.left and
      r1.bottom > r2.top and
      r2.right > r1.left and
      r2.bottom > r1.top

  # returns true if the given element intersects the viewport
  isInViewport = ($element)->
    windowRectangle =
      left: document.documentElement.clientLeft
      top: document.documentElement.clientTop
      width: document.documentElement.clientWidth
      height: document.documentElement.clientHeight
    offset = $element.offset()

    if $element instanceof jQuery
        element = $element[0]
    elementRectangle = element.getBoundingClientRect()

    return intersects windowRectangle, elementRectangle
  hasFocusFlag = ($element)->
    $element.is("[#{focusFlagAttribute}]")
  getFocussedTargets = ($targets)->
    result = []
    $targets.each (i, element)->
      $element = $ element
      if isInViewport($element)
        result.push $element[0]
    result

  focusCallbacks = []
  defocusCallbacks = []
  class Viewport
    # required properties: selector, offset
    constructor: (@config)->
      $window = $ window
      updateDelegate = delegate this, this.update
      $window.resize ()-> updateDelegate.invoke()
      $window.scroll ()-> updateDelegate.invoke()
    update: ()->
      $targets = $ @config.selector
      $focussed = getFocussedTargets $targets
      newFocussed = (element for element in $focussed when not hasFocusFlag($ element))
      newDefocussed = []
      $targets.each (i, element)->
        $element = $ element
        if $focussed.indexOf(element) is -1
          if hasFocusFlag $element
            newDefocussed.push $element[0]
          $element.attr focusFlagAttribute, null
        else
          $element.attr focusFlagAttribute, true
      # invoke callbacks
      if newFocussed.length
        callback newFocussed for callback in focusCallbacks
      if newDefocussed.length
        callback newDefocussed for callback in defocusCallbacks


    # Register a callback that should be invoked if a new section is focussed.
    focus: (onFocus)->
      focusCallbacks.push onFocus
    # Register a callback that should be invoked if a section loses the focus.
    defocus: (onDefocus)->
      defocusCallbacks.push onDefocus

  window.lab.ui.Viewport = Viewport
