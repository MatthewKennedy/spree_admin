Turbo.setConfirmMethod((message, element) => {
  const dialog = document.getElementById('custom-turbo-confirm')
  dialog.querySelector('p').textContent = message
  dialog.showModal()

  return new Promise((resolve, reject) => {
    dialog.addEventListener('close', () => {
      resolve(dialog.returnValue === 'confirm')
    }, { once: true })
  })
})
