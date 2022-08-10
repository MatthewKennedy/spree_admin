document.addEventListener('turbo:before-stream-render', function (event) {
  if (event.target.action === 'update') {
    // Add a class to an element we are about to add to the page
    // as defined by its "data-stream-enter-class"
    const targetFrame = document.getElementById(event.target.target)
    const enterAnimationClass = targetFrame.dataset.streamEnterClass
    if (enterAnimationClass) {
      targetFrame.classList.add(enterAnimationClass)
      targetFrame.addEventListener('animationend', function () {
        targetFrame.classList.remove(enterAnimationClass)
      })
    }
  }

  if (event.target.action === 'append') {
    // Add a class to an element we are about to add to the page
    // as defined by its "data-stream-enter-class"
    const enterAnimationClass = event.target.templateContent.firstElementChild.dataset.streamEnterClass
    if (enterAnimationClass) event.target.templateElement.content.firstElementChild.classList.add(enterAnimationClass)
  }

  if (event.target.action === 'remove') {
    // Add a class to an element we are about to remove from the page
    // as defined by its "data-stream-exit-class"
    const elementToRemove = document.getElementById(event.target.target)

    if (elementToRemove) {
      const streamExitClass = elementToRemove.dataset.streamExitClass
      if (streamExitClass) {
        // Intercept the removal of the element
        event.preventDefault()
        elementToRemove.classList.add(streamExitClass)

        // Wait for its animation to end before removing the element
        elementToRemove.addEventListener('animationend', function () {
          event.target.performAction()
        })
      }
    }
  }
})
