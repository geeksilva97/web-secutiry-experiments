POST to transfer money

curl -X POST http://localhost:4567/submit -d "amount=100&destination-account=123"

Para testar o CORS podemos abrir o console em cutecate.net e executar o codigo JS abaixo

fetch('http://gambiarrabank.com').then(res => res.text()).then(responseText => console.log(responseText))

gerar data de expiracao do cookie -> console.log(new Intl.DateTimeFormat('en-US', { dateStyle: 'medium', timeStyle: 'long', timeZone: 'America/Sao_Paulo' }).format(date));

https://security.stackexchange.com/questions/97825/is-cors-helping-in-anyway-against-cross-site-forgery
