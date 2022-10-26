export function flashToastNotice (message) {
  const body = document.querySelector('body')
  body.insertAdjacentHTML('beforeend', `<div class="toast-container position-fixed bottom-0 start-50 translate-middle-x p-5">
    <div class="toast align-items-center border-0 py-2 text-bg-dark animate__animated animate__faster animate__fadeInUp"
         role="alert"
         aria-live="assertive"
         data-bs-animation="false"
         aria-atomic="true"
         data-controller="toast">
      <div class="d-flex">
        <div class="toast-body">
          ${message}
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    </div>
  </div>`)
}
