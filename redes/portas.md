# Dia 12 — Portas abertas na minha máquina

Comando usado:

```bash
sudo ss -tulnp
```

Saída:

```
Netid State  Recv-Q Send-Q                               Local Address:Port  Peer Address:PortProcess
udp   UNCONN 0      0                                        127.0.0.1:323        0.0.0.0:*    users:(("chronyd",pid=2354,fd=4))
udp   UNCONN 0      0                                      224.0.0.251:5353       0.0.0.0:*    users:(("brave",pid=6978,fd=45))
udp   UNCONN 0      0                                          0.0.0.0:5353       0.0.0.0:*    users:(("avahi-daemon",pid=2238,fd=12))
udp   UNCONN 0      0                                       10.0.0.156:3702       0.0.0.0:*    users:(("python3",pid=5975,fd=10))
udp   UNCONN 0      0                                          0.0.0.0:48883      0.0.0.0:*    users:(("python3",pid=5975,fd=9))
udp   UNCONN 0      0                                       127.0.0.54:53         0.0.0.0:*    users:(("systemd-resolve",pid=1087,fd=18))
tcp   LISTEN 0      4096                                     127.0.0.1:631        0.0.0.0:*    users:(("cupsd",pid=6256,fd=7))
[... resto da saída, veja redes/saida-ss.txt]
```

## Análise

- A porta 5353 (UDP, mDNS) estava aberta em `0.0.0.0` e também em `[::]`, usada pelo 
  `avahi-daemon`. Serve para descobrir dispositivos na rede local (impressoras, 
  outros PCs). É exposta, mas é um serviço padrão em redes domésticas.
- A porta 48883 (UDP) estava aberta em `0.0.0.0`, usada por um processo `python3` 
  (PID 5975). Não reconheci de imediato o que é esse processo — pesquisei e 
  provavelmente está ligado a algum programa de sincronização ou descoberta na 
  rede local (fd=9, fd=10 e fd=12 do mesmo PID aparecem em outras portas também).
- A porta 631 (impressão, CUPS) e as portas 53 (DNS local) e 323 (sincronização de 
  horário) estavam restritas a `127.0.0.1`/`[::1]`, ou seja, só acessíveis pela 
  própria máquina. Bem mais seguras que as anteriores.
- Não há nenhum serviço tipo SSH (porta 22) ou servidor web (80/443) escutando, 
  o que é esperado numa máquina de uso pessoal sem esses serviços habilitados.

## O que aprendi

Rodar esse comando na minha própria máquina, e não só numa VM de teste, deixou 
mais claro que sistemas do dia a dia já têm vários serviços rodando em segundo 
plano sem eu perceber (avahi, chrony, cups). A maioria está bem configurada, 
restrita ao localhost, mas o `python3` na porta 48883 me mostrou que vale a 
pena eu investigar todo processo desconhecido escutando em `0.0.0.0`, em vez de 
assumir que está tudo bem. Numa auditoria de verdade, esse seria o primeiro 
processo que eu investigaria a fundo (`ls -l /proc/5975/exe` para achar o 
executável, por exemplo).
