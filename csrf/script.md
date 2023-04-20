# CSRF Brownbag script

- Sejam bem-vindos a mais essa brownbag.
- continuaremos abordando aspectos de segurança.
- Na última vez que estive por aqui falei sobre XSS
- Hoje falaremos sobre um outro famoso ataque que é o Cross-Site Request Forgery ou simplesmente CSRF

- E temos aqui duas aplicações como de praxe, temos a nossa aplicação vítima que deve rodar em http://gambiarrabank.com
    e nossa aplicação maliciosa que roda em http://local.cutecat.com (http://cutecat.net).
- Em especial coloquei em dois domínios diferentes para evidenciar algumas coisas sobre cookies.

Cross-Site Request forgery consiste em forjar uma requisição, que naturalmente não vem do mesmo site, por isso
cross-site, com o objetivo de performar uma ação indesejada. Geralmente uma ação permanente.

## Demonstrando Gambiarrabank.com

- Temos basicamente um forma em que podemos selecionar um valor e um número de conta.
- Quando clicamos é feita a seguinte requisição:
  ```
  POST /submit
  amount=100&destination-account=123
  ```
- O que é bem como quando iniciamos nossas primeiras aplicações web. A gente só vê que é possível enviar uma request
    e recebe-la.
- E temos a mensagem de que o valor foi enviado
- Tudo funcionando muito bem... mas é aí que os problemas começam.
- Em uma aplicação que permite que qualquer um consiga fazer tal requisição qualquer um pode fazer.
- O nosso site local.cutecat.com é um site malicioso que vai aparecer da seguinte forma nos previews.
- E é um link que convida pessoas que gostam de gato a clicar.
- [Quem não clicaria nessa fofura, guys]
- Porém, uma vez que ce abriu esse site é isso que faz: [mostra a execução]
- Podemos ver que ele caiu em `/submit` com uma conta definida aqui.
- Se verificamos o código, é isso o que temos: [mostrar o código]

### Fatos importantes sobre essa execução

- Vamos fazer de novo só que detalhando
  1. Executar comando `ruby app.rb` e `node server.js`
  2. Vamos entrar em http://gambiarrabank.com/signin - esse endpoint vai inicializar alguns cookies.
  3. Isso simula um usuário que logou na aplicação do seu banco. Ele gerou alguns cookies como o cookie de sessão.
  4. Daí então, ele recebeu o link do gato e clicou o levando para http://local.cutecat.com.
  5. Uma vez que isso acontece, é como se o usuário tivesse dado submit no form de transferência.
  6. Porém com aqueles dados já definidos que seriam a conta do atacante com um valor X já definido também.
  7. Podemos ver na requisição que os cookies foram enviados junto. Então, a aplicação, checando pela sessão não teria
     como saber se essa é uma request maliciosa.

- E é basicamente assim que se dá o ataque de CSRF. Se você pesquisar vai ver algumas menções como o ataque de um
    clique.
- Perceba também que mesmo colocando o cabeçalho `Access-Control-Allow-Origin` não ajuda a prevenir contra CSRF (https://stackoverflow.com/questions/19793695/does-a-proper-cors-setup-prevent-csrf-attack).


## Defesas

E como podemos nos defender? (Chapolim colorado)

### Por que não usamos Referrer?
- Bom, se olharmos a request veremos que nela temos um referrer e origin.
- Ambos indicam a origem, de onde veio aquela request.
- É possível que pensemos: bom vou checar o referrer e garantir a origem.
- Porém referer e origin não são obrigatórios no protocolo HTTP (claro que você pode determinar que, esse endpoint só
    vai funcionar com referer presente)
- Além do que você teria que ter esse mecanismo pra mais de um referer dependendo do caso, pois sua aplicação pode
    precisar integrar com outras que vão fazer essa mesma request ou algo to tipo.
- Outra coisa que dá pra fazer e é o mais comum, é definir um token. Uma string randomica que é gerada por sessão
    e é associado ao form.
- Sempre que um form renderiza é gerado o token que identifica aquele form, vamos dizer assim.
- Daí, quando a informação é submetida, nós checamos se token passado é o mesmo que geramos
- Autenticando assim aquele formulário.
- Esse é o CSRF_TOKEN
