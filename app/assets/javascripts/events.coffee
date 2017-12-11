!do ->
  today = moment()
  isDetailShowing = false
  preOpenDay = null

  Calendar = (selector, events, isLogin) ->
    @el = document.querySelector(selector)
    @events = events
    @current = moment().date(1)
    @draw()
    current = document.querySelector('.today')
    if current
      self = this
    return

  createElement = (tagName, className, innerText) ->
    ele = document.createElement(tagName)
    if className
      ele.className = className
    if innerText
      ele.innderText = ele.textContent = innerText
    ele

  Calendar::draw = ->
    #Create Header
    @drawHeader()
    #Draw Month
    @drawMonth()
    @drawLegend()
    return

  Calendar::drawHeader = ->
    self = this
    if !@header
      #Create the header elements
      @header = createElement('div', 'header')
      @header.className = 'header'
      @title = createElement('h1')
      right = createElement('div', 'right')
      right.addEventListener 'click', ->
        self.nextMonth()
        return
      left = createElement('div', 'left')
      left.addEventListener 'click', ->
        self.prevMonth()
        return
      #Append the Elements
      @header.appendChild @title
      @header.appendChild right
      @header.appendChild left
      @el.appendChild @header
    @title.innerHTML = @current.format('YYYY MMMM')
    return

  Calendar::drawMonth = ->
    self = this
    @events.forEach (ev) ->
      ev.date = moment(ev.date)
      return
    if @month
      @oldMonth = @month
      @oldMonth.className = 'month out ' + (if self.next then 'next' else 'prev')
      @oldMonth.addEventListener 'webkitAnimationEnd', ->
        self.oldMonth.parentNode.removeChild self.oldMonth
        self.month = createElement('div', 'month')
        self.backFill()
        self.currentMonth()
        self.fowardFill()
        self.el.appendChild self.month
        window.setTimeout (->
          self.month.className = 'month in ' + (if self.next then 'next' else 'prev')
          return
        ), 16
        return
    else
      @month = createElement('div', 'month')
      @el.appendChild @month
      @backFill()
      @currentMonth()
      @fowardFill()
      @month.className = 'month new'
    return

  Calendar::backFill = ->
    clone = @current.clone()
    dayOfWeek = clone.day()
    if !dayOfWeek
      return
    clone.subtract 'days', dayOfWeek + 1
    i = dayOfWeek
    while i > 0
      @drawDay clone.add('days', 1)
      i--
    return

  Calendar::fowardFill = ->
    clone = @current.clone().add('months', 1).subtract('days', 1)
    dayOfWeek = clone.day()
    if dayOfWeek == 6
      return
    i = dayOfWeek
    while i < 6
      @drawDay clone.add('days', 1)
      i++
    return

  Calendar::currentMonth = ->
    clone = @current.clone()
    while clone.month() == @current.month()
      @drawDay clone
      clone.add 'days', 1
    return

  Calendar::getWeek = (day) ->
    if !@week or day.day() == 0
      @week = createElement('div', 'week')
      @month.appendChild @week
    return

  Calendar::drawDay = (day) ->
    self = this
    @getWeek day
    #Outer Day
    outer = createElement('div', @getDayClass(day))

    outer.addEventListener 'click', ->
      day = outer.getElementsByClassName("day-number")[0].innerText
      if !isLogin or !isDetailShowing or day != preOpenDay
        self.openDay(this)
        isDetailShowing = true
        preOpenDay = day
      else
        url = './events/new'
        isDetailShowing = false
        preOpenDay = null

        header = document.querySelector('.header')
        text = header.getElementsByTagName('h1')[0].innerText.split(" ")
        year = text[0]
        month = text[1].replace('月', '')
        window.location.href = './events/new?day=' + year + "/" + month + "/" + day
        return

    #Day Name
    name = createElement('div', 'day-name', day.format('ddd'))
    #Day Number
    number = createElement('div', 'day-number', day.format('DD'))
    #Events
    events = createElement('div', 'day-events')
    @drawEvents day, events
    outer.appendChild name
    outer.appendChild number
    outer.appendChild events

    @week.appendChild outer
    return

  Calendar::drawEvents = (day, element) ->
    if day.month() == @current.month()
      todaysEvents = @events.reduce(((memo, ev) ->
        if ev.date.isSame(day, 'day')
          memo.push ev
        memo
      ), [])
      todaysEvents.forEach (ev) ->
        evSpan = createElement('span', ev.color)
        element.appendChild evSpan
        return
    return

  Calendar::getDayClass = (day) ->
    classes = [ 'day' ]
    if day.month() != @current.month()
      classes.push 'other'
    else if today.isSame(day, 'day')
      classes.push 'today'
    classes.join ' '

  Calendar::openDay = (el) ->
    `var arrow`
    details = undefined
    arrow = undefined
    dayNumber = +el.querySelectorAll('.day-number')[0].innerText or +el.querySelectorAll('.day-number')[0].textContent
    day = @current.clone().date(dayNumber)
    currentOpened = document.querySelector('.details')
    #Check to see if there is an open detais box on the current row
    if currentOpened and currentOpened.parentNode == el.parentNode
      details = currentOpened
      arrow = document.querySelector('.arrow')
    else
      #Close the open events on differnt week row
      #currentOpened && currentOpened.parentNode.removeChild(currentOpened);
      if currentOpened
        currentOpened.addEventListener 'webkitAnimationEnd', ->
          currentOpened.parentNode.removeChild currentOpened
          return
        currentOpened.addEventListener 'oanimationend', ->
          currentOpened.parentNode.removeChild currentOpened
          return
        currentOpened.addEventListener 'msAnimationEnd', ->
          currentOpened.parentNode.removeChild currentOpened
          return
        currentOpened.addEventListener 'animationend', ->
          currentOpened.parentNode.removeChild currentOpened
          return
        currentOpened.className = 'details out'
      #Create the Details Container
      details = createElement('div', 'details in')
      #Create the arrow
      arrow = createElement('div', 'arrow')
      #Create the event wrapper
      details.appendChild arrow
      el.parentNode.appendChild details
    todaysEvents = @events.reduce(((memo, ev) ->
      if moment(ev.date).isSame(day, 'day')
        memo.push ev
      memo
    ), [])
    @renderEvents todaysEvents, details
    arrow.style.left = el.offsetLeft - (el.parentNode.offsetLeft) + 27 + 'px'
    return

  Calendar::renderEvents = (events, ele) ->
    #Remove any events in the current details element
    currentWrapper = ele.querySelector('.events')
    wrapper = createElement('div', 'events in' + (if currentWrapper then ' new' else ''))
    events.forEach (ev) ->
      div = createElement('div', 'event')
      square = createElement('div', 'event-category ' + ev.color)
      time = createElement('span', '', ev.eventTime)
      br = createElement('br')
      member = createElement('span', '', 'メンバー: ' + ev.eventMember)
      div.appendChild square
      div.appendChild time
      div.appendChild br
      div.appendChild member
      wrapper.appendChild div
      return
    if !events.length
      div = createElement('div', 'event empty')
      span = createElement('span', '', 'No Events')
      div.appendChild span
      wrapper.appendChild div
    if currentWrapper
      currentWrapper.className = 'events out'
      currentWrapper.addEventListener 'webkitAnimationEnd', ->
        currentWrapper.parentNode.removeChild currentWrapper
        ele.appendChild wrapper
        return
      currentWrapper.addEventListener 'oanimationend', ->
        currentWrapper.parentNode.removeChild currentWrapper
        ele.appendChild wrapper
        return
      currentWrapper.addEventListener 'msAnimationEnd', ->
        currentWrapper.parentNode.removeChild currentWrapper
        ele.appendChild wrapper
        return
      currentWrapper.addEventListener 'animationend', ->
        currentWrapper.parentNode.removeChild currentWrapper
        ele.appendChild wrapper
        return
    else
      ele.appendChild wrapper
    return

  Calendar::drawLegend = ->
    legend = createElement('div', 'legend')
    calendars = @events.map((e) ->
      e.calendar + '|' + e.color
    ).reduce(((memo, e) ->
      if memo.indexOf(e) == -1
        memo.push e
      memo
    ), []).forEach((e) ->
      parts = e.split('|')
      entry = createElement('span', 'entry ' + parts[1], parts[0])
      legend.appendChild entry
      return
    )
    @el.appendChild legend
    return

  Calendar::nextMonth = ->
    @current.add 'months', 1
    @next = true
    @draw()
    return

  Calendar::prevMonth = ->
    @current.subtract 'months', 1
    @next = false
    @draw()
    return

  window.Calendar = Calendar
  return

# ---
# generated by js2coffee 2.2.0
