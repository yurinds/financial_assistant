// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener('turbolinks:load', _ => {
  const cardDesk = document.querySelector('.card-deck');

  if (!cardDesk) return;

  cardDesk.addEventListener('click', event => {
    parentElement = event.target.closest('[data-url]');

    if (!parentElement) return;

    Turbolinks.visit(parentElement.dataset.url);
  });
});
