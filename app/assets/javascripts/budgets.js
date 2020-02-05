// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener('turbolinks:load', _ => {
  $('#monthpicker').datetimepicker({
    viewMode: 'months',
    format: 'YYYY/MM',
    toolbarPlacement: 'top',
    allowInputToggle: true,
    icons: {
      time: 'fa fa-time',
      date: 'fa fa-calendar',
      up: 'fa fa-chevron-up',
      down: 'fa fa-chevron-down',
      previous: 'fa fa-chevron-left',
      next: 'fa fa-chevron-right',
      today: 'fa fa-screenshot',
      clear: 'fa fa-trash',
      close: 'fa fa-remove',
    },
  });

  const cardDesk = document.querySelector('.card-deck');

  if (!cardDesk) return;

  cardDesk.addEventListener('click', event => {
    if (event.target.nodeName === 'I') return;
    parentElement = event.target.closest('[data-url]');

    if (!parentElement) return;

    Turbolinks.visit(parentElement.dataset.url);
  });
});
