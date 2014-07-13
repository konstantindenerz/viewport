$ ()->
  viewPort = new lab.ui.Viewport
    selector: '.section'
    overlap: 50 # math.min(intersection.height, intersection.width) >= overlap
  viewPort.focus (elements)->
    console.log 'new focus', elements
    console.log element for element in elements when $(element).hasClass 'a'
  viewPort.defocus (elements)->
    console.log 'defocus', elements
  viewPort.update()

  console.log viewPort.hasFocus (element)-> $(element).hasClass 'a' # expected value: true
  console.log viewPort.hasFocus (element)-> $(element).hasClass 'f' # expected value: false
  
