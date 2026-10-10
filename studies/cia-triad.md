# CIA Triad

## Confidencialidade

Confidencialidade é garantir que só quem tem permissão consegue ver uma 
informação. No meu próprio estudo isso já apareceu na prática: no dia 12, 
quando rodei o `ss -tulnp` e vi a diferença entre um serviço escutando em 
`0.0.0.0` (qualquer um na rede pode acessar) e um escutando só em 
`127.0.0.1` (só a própria máquina acessa). Restringir o acesso de um 
serviço é, na prática, proteger a confidencialidade dele.

## Integridade

Integridade é garantir que uma informação não seja alterada sem 
autorização, e que, se for alterada, isso deixe rastro. Isso conecta 
direto com o `chmod` que usei no dia 10: ao controlar quem pode **escrever** 
num arquivo, eu estou protegendo a integridade dele — impedindo que 
alguém sem permissão mude o conteúdo sem eu saber.

## Disponibilidade

Disponibilidade é garantir que o sistema ou a informação esteja acessível 
quando for necessário. Um exemplo claro: se alguém conseguisse derrubar o 
serviço SSH com um volume grande de tentativas de conexão, o serviço 
ficaria indisponível para quem realmente precisa usá-lo — isso seria uma 
quebra de disponibilidade.

