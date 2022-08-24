function updateOutput(result) {
  var outputContainer = document.getElementById('output-container')
  var outputElement = document.getElementById('output')
  outputElement.innerText = result;
  outputContainer.classList.remove('hidden');
}

function submitRequest() {
  var domainName = document.getElementById('domain').value
  if (!domainName) {
    alert("Please enter a domain name")
    return
  }
  $.ajax({
    url: '/test-domain',
    method: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({
      'domainName': domainName
    }),
    success: updateOutput
  })
}

var form = document.querySelectorAll('form')[0]
form.addEventListener('submit', function(evt) { evt.preventDefault(); submitRequest(); })
