$ ->
  # TODO This can probably be achieved much more cleanly with Knockout or similar.
  $("input[type='filepicker']").each () ->
    picker = $(this)
    thumbs = picker.next("ul.thumbs")
    picker.data 'val', $(this).val() # Store old values so "pick" performs an insert rather than a replace.
    tmpl = $("<li><img /></li>").addClass('new')

    setImages = (ary) ->
      str = ary.join(',')
      console.log "setImages", str
      picker.data 'val', str
      picker.val str

    getImages = () ->
      picker.data('val').split ','

    addImage = (image) ->
      images = getImages()
      images.push image
      setImages images

    removeImage = (image) ->
      images = getImages()
      images.remove images.indexOf(image)
      setImages images

    thumbs.sortable
      placeholder: "drop"
      stop: (evt) ->
        imgs = thumbs.find("li img").map () -> $(this).data('src')
        setImages $.makeArray(imgs)

    thumbs.find(".delete").click (evt) ->
      button = $(this)
      evt.preventDefault()
      src = $(this).prev("img").data("src")
      $(this).closest("li").remove()
      removeImage src

      # Ignoring API call for now - it appears to work fine, but no reason to delete.
      # Semantics are also weird.
      # filepicker.remove url: src, () ->

    picker.change (evt) ->
      evt = evt.originalEvent
      addImage picker.val()

      for file in evt.fpfiles
        tag = tmpl.clone()
        tag.find("img").attr("src", file.url + "/convert?h=125&w=125").data("src", file.url)
        thumbs.append tag

