@app.directive('circularSlider',->
  return {
    restrict: "C",
    link: (scope, element) ->

        k = {} # kontrol
        max = Math.max
        min = Math.min
        index = 0
        chipcount = 200
        counter = 200
        colorArray = ["#016fde", "#2bc2de", "#fcd006", "#f68909", "#de2b30", "#9529f2", "#ed2a7b", "#7ad64d"]
        oldValue = null
        currentValue = null
        k.c = {}
        k.c.d = $(document)
        k.c.t = (e) ->
          e.originalEvent.touches.length - 1


        ###
        Kontrol Object

        Definition of an abstract UI control

        Each concrete component must call this one.
        <code>
        k.o.call(this);
        </code>
        ###
        k.o = ->
          s = this
          @o = null # array of options
          @$ = null # jQuery wrapped element
          @i = null # mixed HTMLInputElement or array of HTMLInputElement
          @g = null # 2D graphics context for 'pre-rendering'
          @v = null # value ; mixed array or integer
          @cv = null # change value ; not commited value
          @x = 0 # canvas x position
          @y = 0 # canvas y position
          @$c = null # jQuery canvas element
          @c = null # rendered canvas context
          @t = 0 # touches index
          @isInit = false
          @fgColor = null # main color
          @pColor = null # previous color
          @dH = null # draw hook
          @cH = null # change hook
          @eH = null # cancel hook
          @rH = null # release hook
          @firstTime = true
          @run = ->
            cf = (e, conf) ->
              k = undefined
              for k of conf
                s.o[k] = conf[k]
              s.init()
              s._configure()._draw()

            return  if @$.data("kontroled")
            @$.data "kontroled", true
            @extend()
            @o = $.extend(

              # Config
              min: @$.data("min") or 0
              max: @$.data("max") or 200
              stopper: true
              readOnly: @$.data("readonly")

              # UI
              cursor: (@$.data("cursor") is true and 30) or @$.data("cursor") or 0
              thickness: @$.data("thickness") or 0.20
              lineCap: @$.data("linecap") or "butt"
              width: @$.data("width") or 200
              height: @$.data("height") or 200
              displayInput: not @$.data("displayinput")? or @$.data("displayinput")
              displayPrevious: @$.data("displayprevious")
              fgColor: colorArray[0]
              inputColor: @$.data("inputcolor") or colorArray[0]
              inline: false
              step: @$.data("step") or 1

              # Hooks
              draw: null # function () {}
              change: null # function (value) {}
              cancel: null # function () {}
              release: null # function (value) {}
            , @o)

            # routing value
            if @$.is("fieldset")

              # fieldset = array of integer
              @v = {}
              @i = @$.find("input")
              @i.each (k) ->
                $this = $(this)
                s.i[k] = $this
                s.v[k] = $this.val()
                $this.bind "change", ->
                  val = {}
                  val[k] = $this.val()
                  s.val val


              @$.find("legend").remove()
            else

              # input = integer
              @i = @$
              @v = @$.val()
              (@v is "") and (@v = @o.min)
              @$.bind "change", ->
                s.val s._validate(s.$.val())

            (not @o.displayInput) and @$.hide()
            @$c = $("<canvas width=\"" + @o.width + "px\" height=\"" + @o.height + "px\"></canvas>")
            @c = @$c[0].getContext("2d")
            @$.wrap($("<div style=\"" + ((if @o.inline then "display:inline;" else "")) + "width:" + @o.width + "px;height:" + @o.height + "px;\"></div>")).before @$c
            if @v instanceof Object
              @cv = {}
              @copy @v, @cv
            else
              @cv = @v
            @$.bind("configure", cf).parent().bind "configure", cf
            @_listen()._configure()._xy().init()
            @isInit = true
            @_draw()
            this

          @_getValues = (curreValue) ->
            currentValue = curreValue
            oldValue = (if not oldValue? then currentValue else oldValue)

          @_changeValue = ->
            chip = 0
            unless oldValue? and oldValue <= currentValue
              chip = currentValue
              oldValue = currentValue
            console.log "oldValue,curreValue,chip", oldValue, currentValue, chip
            unless currentValue is @o.max
              chipcount = parseInt(chipcount) + parseInt(chip)
              index = (if chipcount < @o.max then parseInt((@o.max - chipcount) / @o.max) else parseInt((chipcount - @o.max) / @o.max))
              console.log "index,chipcount,currentValue,oldValue,this.o.max,(chipcount - this.o.max)/this.o.max)", index, chipcount, currentValue, oldValue, @o.max, (chipcount - @o.max) / @o.max
              oldValue = currentValue
            else
              index = 0

          @_draw = ->

            # canvas pre-rendering
            d = true
            c = document.createElement("canvas")
            c.width = s.o.width
            c.height = s.o.height
            s.g = c.getContext("2d")
            s.clear()
            s.dH and (d = s.dH())
            (d isnt false) and s.draw()
            s.c.drawImage c, 0, 0
            c = null

          @_touch = (e) ->
            touchMove = (e) ->
              v = s.xy2val(e.originalEvent.touches[s.t].pageX, e.originalEvent.touches[s.t].pageY)
              return  if v is s.cv
              return  if s.cH and (s.cH(v) is false)
              s.change s._validate(v)
              s._draw()


            # get touches index
            @t = k.c.t(e)

            # First touch
            touchMove e

            # Touch events listeners
            k.c.d.bind("touchmove.k", touchMove).bind "touchend.k", ->
              k.c.d.unbind "touchmove.k touchend.k"
              return  if s.rH and (s.rH(s.cv) is false)
              s.val s.cv

            this

          @_mouse = (e) ->
            mouseMove = (e) ->
              v = s.xy2val(e.pageX, e.pageY)
              return  if v is s.cv
              return  if s.cH and (s.cH(v) is false)
              s.change s._validate(v)
              s._draw()


            # First click
            mouseMove e

            # Mouse events listeners

            # Escape key cancel current change
            k.c.d.bind("mousemove.k", mouseMove).bind("keyup.k", (e) ->
              if e.keyCode is 27
                k.c.d.unbind "mouseup.k mousemove.k keyup.k"
                return  if s.eH and (s.eH() is false)
                s.cancel()
            ).bind "mouseup.k", (e) ->
              k.c.d.unbind "mousemove.k mouseup.k keyup.k"
              return  if s.rH and (s.rH(s.cv) is false)
              s.val s.cv

            this

          @_xy = ->
            o = @$c.offset()
            @x = o.left
            @y = o.top
            this

          @_listen = ->
            unless @o.readOnly
              @$c.bind("mousedown", (e) ->
                e.preventDefault()
                s._xy()._mouse e
              ).bind "touchstart", (e) ->
                e.preventDefault()
                s._xy()._touch e

              @listen()
            else
              @$.attr "readonly", "readonly"
            this

          @_configure = ->

            # Hooks
            @dH = @o.draw  if @o.draw
            @cH = @o.change  if @o.change
            @eH = @o.cancel  if @o.cancel
            @rH = @o.release  if @o.release
            if @o.displayPrevious
              console.log "try"
              @pColor = @h2rgba(@o.fgColor, "0.4")
              @fgColor = @h2rgba(@o.fgColor, "0.6")
            else
              @fgColor = @o.fgColor
            this

          @_clear = ->
            @$c[0].width = @$c[0].width

          @_validate = (v) ->
            (~~(((if (v < 0) then -0.5 else 0.5)) + (v / @o.step))) * @o.step


          # Abstract methods
          @listen = -> # on start, one time

          @extend = -> # each time configure triggered

          @init = -> # each time configure triggered

          @change = (v) -> # on change

          @val = (v) -> # on release

          @xy2val = (x, y) -> #

          @draw = -> # on change / on release

          @clear = ->
            @_clear()


          # Utils
          @h2rgba = (h, a) ->
            rgb = undefined
            h = h.substring(1, 7)
            rgb = [parseInt(h.substring(0, 2), 16), parseInt(h.substring(2, 4), 16), parseInt(h.substring(4, 6), 16)]
            "rgba(" + rgb[0] + "," + rgb[1] + "," + rgb[2] + "," + a + ")"

          @copy = (f, t) ->
            for i of f
              t[i] = f[i]


        ###
        k.Dial
        ###
        k.Dial = ->
          k.o.call this
          @startAngle = null
          @xy = null
          @radius = null
          @lineWidth = null
          @cursorExt = null
          @w2 = null
          @PI2 = 2 * Math.PI
          @extend = ->
            @o = $.extend(
              bgColor: colorArray[0]
              angleOffset: @$.data("angleoffset") or 0
              angleArc: @$.data("anglearc") or 360
              inline: true
            , @o)

          @val = (v) ->
            unless null is v
              @cv = (if @o.stopper then max(min(v, @o.max), @o.min) else v)
              @v = @cv
              @$.val @v
              @_getValues @v
              @_changeValue()
              @_draw()
            else
              @v

          @xy2val = (x, y) ->
            a = undefined
            ret = undefined
            a = Math.atan2(x - (@x + @w2), -(y - @y - @w2)) - @angleOffset
            if @angleArc isnt @PI2 and (a < 0) and (a > -0.5)

              # if isset angleArc option, set to min if .5 under min
              a = 0
            else a += @PI2  if a < 0
            ret = ~~(0.5 + (a * (@o.max - @o.min) / @angleArc)) + @o.min
            @o.stopper and (ret = max(min(ret, @o.max), @o.min))
            ret

          @listen = ->

            # bind MouseWheel
            s = this
            mw = (e) ->
              e.preventDefault()
              ori = e.originalEvent
              deltaX = ori.detail or ori.wheelDeltaX
              deltaY = ori.detail or ori.wheelDeltaY
              v = parseInt(s.$.val()) + ((if deltaX > 0 or deltaY > 0 then s.o.step else (if deltaX < 0 or deltaY < 0 then -s.o.step else 0)))
              return  if s.cH and (s.cH(v) is false)
              s.val v

            kval = undefined
            to = undefined
            m = 1
            kv =
              37: -s.o.step
              38: s.o.step
              39: s.o.step
              40: -s.o.step


            # numpad support
            # enter
            # bs
            # tab
            # -

            # arrows

            # long time keydown speed-up
            @$.bind("keydown", (e) ->
              kc = e.keyCode
              kc = e.keyCode = kc - 48  if kc >= 96 and kc <= 105
              kval = parseInt(String.fromCharCode(kc))
              if isNaN(kval)
                (kc isnt 13) and (kc isnt 8) and (kc isnt 9) and (kc isnt 189) and e.preventDefault()
                if $.inArray(kc, [37, 38, 39, 40]) > -1
                  e.preventDefault()
                  v = parseInt(s.$.val()) + kv[kc] * m
                  s.o.stopper and (v = max(min(v, s.o.max), s.o.min))
                  s.change v
                  s._draw()
                  to = window.setTimeout(->
                    m *= 2
                  , 30)
            ).bind "keyup", (e) ->
              if isNaN(kval)
                if to
                  window.clearTimeout to
                  to = null
                  m = 1
                  s.val s.$.val()
              else

                # kval postcond
                (s.$.val() > s.o.max and s.$.val(s.o.max)) or (s.$.val() < s.o.min and s.$.val(s.o.min))

            @$c.bind "mousewheel DOMMouseScroll", mw
            @$.bind "mousewheel DOMMouseScroll", mw

          @init = ->
            @v = @o.min  if @v < @o.min or @v > @o.max
            @$.val @v
            @_getValues @v
            @_changeValue()
            @w2 = @o.width / 2
            @cursorExt = @o.cursor / 100
            @xy = @w2
            @lineWidth = @xy * @o.thickness
            @lineCap = @o.lineCap
            @radius = @xy - @lineWidth / 2
            @o.angleOffset and (@o.angleOffset = (if isNaN(@o.angleOffset) then 0 else @o.angleOffset))
            @o.angleArc and (@o.angleArc = (if isNaN(@o.angleArc) then @PI2 else @o.angleArc))

            # deg to rad
            @angleOffset = @o.angleOffset * Math.PI / 180
            @angleArc = @o.angleArc * Math.PI / 180

            # compute start and end angles
            @startAngle = 1.5 * Math.PI + @angleOffset
            @endAngle = 1.5 * Math.PI + @angleOffset + @angleArc
            s = max(String(Math.abs(@o.max)).length, String(Math.abs(@o.min)).length, 2) + 2
            @o.displayInput and @i.css(
              width: ((@o.width / 2 + 4) >> 0) + "px"
              height: ((@o.width / 3) >> 0) + "px"
              position: "absolute"
              "vertical-align": "middle"
              "margin-top": ((@o.width / 3) >> 0) + "px"
              "margin-left": "-" + ((@o.width * 3 / 4 + 2) >> 0) + "px"
              border: 0
              background: "none"
              font: "bold " + ((@o.width / s) >> 0) + "px Arial"
              "text-align": "center"
              color: @o.inputColor or @o.fgColor
              padding: "0px"
              "-webkit-appearance": "none"
            ) or @i.css(
              width: "0px"
              visibility: "hidden"
            )

          @change = (v) ->
            @cv = v
            @$.val v

          @angle = (v) ->
            (v - @o.min) * @angleArc / (@o.max - @o.min)

          @draw = ->
            c = @g # context
            a = @angle(@cv) # Angle
            sat = @startAngle # Start angle
            eat = sat + a # End angle
            sa = undefined
            ea = undefined
            # Previous angles
            r = 1
            c.lineWidth = @lineWidth
            c.lineCap = @lineCap
            @o.cursor and (sat = eat - @cursorExt) and (eat = eat + @cursorExt)
            console.log "v,this.endAngle", @v, @endAngle
            c.beginPath()
            c.strokeStyle = colorArray[index]
            c.arc @xy, @xy, @radius, @endAngle, 0, true
            c.stroke()
            if @o.displayPrevious
              ea = @startAngle + @angle(@v)
              sa = @startAngle
              @o.cursor and (sa = ea - @cursorExt) and (ea = ea + @cursorExt)
              c.beginPath()
              c.strokeStyle = @pColor
              c.arc @xy, @xy, @radius, sa, ea, false
              c.stroke()
              r = (@cv is @v)
            c.beginPath()
            c.strokeStyle = colorArray[index + 1]
            c.arc @xy, @xy, @radius, sat, eat, false
            c.stroke()

          @cancel = ->
            @val @v

        $.fn.dial = $.fn.knob = (o) ->
          @each(->
            d = new k.Dial()
            d.o = o
            d.$ = $(this)
            d.run()
          ).parent()
  }
)
