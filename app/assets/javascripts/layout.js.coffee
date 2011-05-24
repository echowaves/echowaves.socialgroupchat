$ ->

  $('.box').layout()
  $('.sidebar').layout()
  $('.convo').layout {resize: false}

  container = $('.layout')

  relayout = ->
    container.layout {resize: false}

  relayout()
  $(window).resize relayout
  scrollBottom()