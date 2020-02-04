// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
document.addEventListener('turbolinks:load', e => {
  const btnAddOperation = document.querySelector(
    '.btn.btn-link[data-toggle="collapse"]'
  );

  if (!btnAddOperation) return;

  btnAddOperation.addEventListener('ajax:before', event => {
    if (document.forms['addNewOperation']) event.preventDefault();
  });

  btnAddOperation.addEventListener('click', event => {
    if (document.getElementById('collapseExample')) return;
    template = createCollapseTemplate();
    btnAddOperation.insertAdjacentHTML('afterend', template);
  });
});

function createCollapseTemplate() {
  return `
    <div id="collapseExample" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
      <div class="card-body">
      </div>
    </div>
`;
}
