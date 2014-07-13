$ ()->
  viewPort = new lab.ui.Viewport
    selector: '.section'
    offset: 50
  viewPort.focus (elements)->
    console.log 'new focus', elements
  viewPort.defocus (elements)->
    console.log 'defocus', elements
  viewPort.update()
