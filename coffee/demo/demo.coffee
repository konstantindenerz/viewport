$ ()->
  viewPort = new lab.ui.Viewport
    selector: '.section'
    offset: 50
  viewPort.focus (element)->
    console.log element
  viewPort.defocus (element)->
    console.log element
