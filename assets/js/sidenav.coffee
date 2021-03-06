---
---

$ ->
  title = document.title
  $(".navlink").each ->
    $(this).attr("href", "##{$(this).attr("ajax")}")
  if window.location.hash.length > 1
    loc = window.location.hash.substring(1)
    $("#content").load("content/#{loc}.html", complete = ->
      $(document).initContent()
    )
    $(".active-nav").removeClass("active-nav")
    $(".navlink[ajax=#{loc}]").addClass("active-nav")
    document.title = "#{$(".active-nav:first").text()} | #{title}"
    document.title = title if $(".active-nav").attr("ajax") == "about"
  $(".navlink").click ->
    $('#sidenav-overlay').trigger('click')
    return if $(this).hasClass("active-nav")
    clicked = $(this)
    $(".active-nav").removeClass("active-nav")
    clicked.addClass("active-nav")
    document.title = "#{clicked.text()} | #{title}"
    document.title = title if clicked.attr("ajax") == "about"
    loadAjax = $.ajax("content/#{ clicked.attr("ajax") || "about" }.html")
    cardCount = $("#content>.card,#content>.cf>.card").length
    $("#content>.card,#content>.cf>.card").each (index)->
      card = $(this)
      card.css("z-index", 50+cardCount-index)
      setTimeout( ->
        card.animate({left: window.innerWidth}, 500, complete= ->
          setTimeout( ->
            card.remove()
            cardCount--
            if cardCount==0
              loadAjax.done (data)->
                $("#content").html(data)
                cardCount = $("#content>.card,#content>.cf>.card").length
                $("#content>.card,#content>.cf>.card").each (index_new)->
                  $(this).hide()
                  card_new = $(this)
                  setTimeout( ->
                    card_new.show("slide", direction: "left", 500)
                    cardCount--
                    if cardCount==0
                      $(document).initContent()
                  , 250*index_new)
          , 50)
        )
      , 250*index)
  $(".button-collapse").sideNav(menuWidth: 300)
