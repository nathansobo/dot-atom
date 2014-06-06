ReactPerf = require '/Users/nathansobo/github/atom/node_modules/react-atom-fork/lib/ReactDefaultPerf'

timelineStarted = false
atom.workspaceView.command 'user:toggle-timeline', ->
  if timelineStarted
    console.timelineEnd()
    timelineStarted = false
  else
    console.timeline()
    timelineStarted = true

profileStarted = false
atom.workspaceView.command 'user:toggle-profile', ->
  if profileStarted
    console.timelineEnd()
    console.profileEnd()
    profileStarted = false
  else
    console.profile()
    console.timeline()
    profileStarted = true

perfStarted = false
atom.workspaceView.command 'user:react-perf', ->
  if perfStarted
    console.log "stopping perf"
    ReactPerf.stop()
    console.log "Inclusive"
    ReactPerf.printInclusive()
    console.log "Exclusive"
    ReactPerf.printExclusive()
    console.log "Wasted"
    ReactPerf.printWasted()
    perfStarted = false
  else
    console.log "starting perf"
    ReactPerf.start()
    perfStarted = true

atom.workspaceView.command 'user:test-input', ->
  inputNode = document.activeElement

  console.log document.activeElement

  i = 0
  console.profile('input')
  while i++ < 30
    inputNode.value = 'x'
    inputNode.dispatchEvent(new Event('input'))
  console.profileEnd('input')

atom.workspaceView.command 'user:test-scrolling', -> testScrolling(-2000)
atom.workspaceView.command 'user:test-slow-scrolling', -> testScrolling(-200)
atom.workspaceView.command 'user:test-scroll-sequence', ->
  console.timeline('scroll down')
  # console.profile('scroll down')
  testScrolling -50, ->
    testScrolling -100, ->
      testScrolling -200, ->
        testScrolling -400, ->
          testScrolling -800, ->
            testScrolling -1600, ->
              console.timelineEnd('scroll down')
              # console.profileEnd('scroll down')

atom.workspaceView.command 'user:create-selections', ->
  editor = atom.workspace.getActiveEditor()

  currentRow = 0
  lineCount = editor.getLineCount()
  while currentRow + 5 < lineCount
    editor.addSelectionForBufferRange([[currentRow, 0], [currentRow + 5, 0]])
    currentRow += 20

testScrolling = (delta, cb) ->
  editorNodes = document.querySelectorAll('.editor')
  editorNode = editorNodes[editorNodes.length - 1]
  scrollViewNode = editorNode.querySelector('.scroll-view')
  editor = atom.workspace.getActiveEditor()

  scrollDown = ->
    scrollViewNode.dispatchEvent(new WheelEvent('mousewheel', wheelDeltaX: -0, wheelDeltaY: delta))
    editorNode.dispatchEvent(new WheelEvent('mousewheel', wheelDeltaX: -0, wheelDeltaY: delta))

  stopScrolling = ->
    clearInterval(interval)
    cb?()

  interval = setInterval(scrollDown, 10)

  setTimeout(stopScrolling, 600)
