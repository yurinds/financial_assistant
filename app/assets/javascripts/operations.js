// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('turbolinks:load', e => {
  const btnAddOperation = document.querySelector(
    '.btn.btn-link[data-toggle="collapse"]'
  );
  const operationsTable = document.querySelector('tbody');

  if (!btnAddOperation) return;

  btnAddOperation.addEventListener('ajax:before', event => {
    if (document.forms['operationForm']) event.preventDefault();
  });

  btnAddOperation.addEventListener('click', createOperationsForm);
  if (operationsTable) {
    operationsTable.addEventListener('click', ({ target }) => {
      if (!target.nodeName === 'I') return;

      createOperationsForm();
    });
  }

  function createOperationsForm(event) {
    if (document.getElementById('collapseExample')) return;

    const card = document.querySelector('#accordionExample .card');

    if (!card) return;

    template = createCollapseTemplate();
    card.insertAdjacentHTML('beforeend', template);
  }
});

function createCollapseTemplate() {
  return `
    <div id="collapseExample" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
      <div class="card-body">
      </div>
    </div>
`;
}
