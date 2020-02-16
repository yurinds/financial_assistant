// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

document.addEventListener('turbolinks:load', onBudgetTurbolinksLoadHandler);

function onBudgetTurbolinksLoadHandler(event) {
  loadMonthpicker();
  loadOwlCarousel();

  createCardsOnClickHandler();
  addClassToOwlCarousel();
}

function loadMonthpicker() {
  $('#monthpicker').datetimepicker({
    locale: 'ru',
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
}

function loadOwlCarousel() {
  const carousel = document.querySelector('.owl-carousel');
  if (!carousel) return;

  const windowLocation = window.location.href;

  let matchData = windowLocation.match(/budgets\/+\d{1,}/);
  let startPosition = '';

  if (matchData) {
    startPosition = matchData[0].match(/\d{1,}/)[0];
  }
  window.location.hash = '#' + startPosition;

  $('.owl-carousel').owlCarousel({
    startPosition: startPosition,
    margin: 10,
    responsiveClass: true,
    responsive: {
      0: {
        items: 1,
        nav: true,
      },
      1000: {
        items: 3,
        nav: true,
      },
    },
  });
}

function createCardsOnClickHandler() {
  const cardDesk = document.querySelector('.owl-carousel');

  if (!cardDesk) return;

  cardDesk.addEventListener('click', event => {
    if (event.target.nodeName === 'I') return;
    parentElement = event.target.closest('[data-url]');

    if (!parentElement) return;

    Turbolinks.visit(parentElement.dataset.url);
  });
}

function addClassToOwlCarousel(params) {
  const owlCarouselDots = document.querySelector('.owl-dots.disabled');
  const owlCarousel = document.querySelector('.owl-carousel');

  if (!owlCarouselDots) return;
  if (!owlCarousel) return;

  owlCarousel.classList.add('mb-3');
}
