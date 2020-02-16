document.addEventListener('turbolinks:load', onStatTurbolinksLoadHandler);

function onStatTurbolinksLoadHandler(event) {
  const budgetSelect = document.querySelector('#budget_budget_id');
  if (!budgetSelect) return;

  budgetSelect.addEventListener('change', onChangeBudgetHandler);
  setSelectedElement(budgetSelect);
}

function onChangeBudgetHandler({ target }) {
  const url = target.dataset.url;
  const id = target.selectedOptions[0].value;

  Turbolinks.visit(`${url}/${id}`);
}

function setSelectedElement(select) {
  const windowLocation = window.location.href;

  let matchData = windowLocation.match(/stats\/+\d{1,}/);
  let statId = '';

  if (matchData) {
    statId = matchData[0].match(/\d{1,}/)[0];
  }

  Array.from(select.children).forEach(option => {
    if (option.value === statId) option.selected = true;
  });
}
