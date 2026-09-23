# Writeup: THM Linux Fundamentals Part 1

**Data:** 2025-XX-XX  
**Sala:** [Linux Fundamentals Part 1](https://tryhackme.com/room/linuxfundamentalspart1)  
**Dificuldade:** Fácil  
**Tempo:** ~1h30

---

## Objetivo
Consolidar navegação no sistema de arquivos, manipulação de arquivos/diretórios e comandos básicos de terminal Linux.

---

## Comandos Principais Utilizados

| Comando | Função | Exemplo Prático |
|---------|--------|-----------------|
| `pwd` | Diretório atual | `pwd` → `/home/user` |
| `ls -la` | Lista tudo (inclui ocultos) | `ls -la /etc` |
| `cd` | Muda diretório | `cd /var/log` |
| `mkdir -p` | Cria diretórios recursivos | `mkdir -p projetos/scripts` |
| `touch` | Cria arquivo vazio | `touch notes.txt` |
| `cp -r` | Copia recursivo | `cp -r /etc/ssh ~/backup/` |
| `mv` | Move/renomeia | `mv old.txt new.txt` |
| `rm -rf` | Remove recursivo (cuidado!) | `rm -rf temp/` |
| `cat` / `less` | Visualiza conteúdo | `less /var/log/syslog` |
| `grep` | Busca padrão | `grep "error" /var/log/auth.log` |
| `find` | Busca arquivos | `find /home -name "*.sh" -type f` |
| `chmod` | Muda permissões | `chmod 750 script.sh` |
| `chown` | Muda dono | `chown user:group arquivo` |

---

## Desafios Resolvidos

### 1. Navegação e Estrutura
**Pergunta:** "Qual o caminho absoluto do diretório home do usuário?"
```bash
pwd
# Resposta: /home/ubuntu
```

### 2. Permissões
**Pergunta:** "Crie um arquivo que só o dono possa ler/escrever/executar."
```bash
touch secreto.sh
chmod 700 secreto.sh
ls -l secreto.sh
# -rwx------ 1 ubuntu ubuntu 0 ...
```

### 3. Busca de Arquivos
**Pergunta:** "Encontre todos os arquivos .conf em /etc modificados nos últimos 7 dias."
```bash
find /etc -name "*.conf" -type f -mtime -7
```

---

## Lições Aprendidas

1. **Tab completion** economiza digitação e evita erros de path
2. `man <comando>` > Google para flags obscuras (`man find` salvou no desafio 3)
3. Permissões `rwx` mapeiam para bits: 4+2+1 = 7 (dono), 5 = r-x, etc.
4. `grep -r` (recursivo) + `-i` (case-insensitive) + `-n` (linha) = combo poderoso
5. **Sempre teste `rm` com `ls` antes** — `ls arquivo*` → `rm arquivo*`

---

## Prints de Tela

> *Adicione screenshots dos terminais resolvendo os desafios principais*
> - `![navegacao](screenshots/01-pwd.png)`
> - `![permissoes](screenshots/02-chmod.png)`

---

## Referências

- `man hier` — estrutura de diretórios Linux (FHS)
- `man chmod` — tabela de permissões octais
- [Linux Journey - Permissions](https://linuxjourney.com/lesson/permissions)

---

## Próximos Passos

- [ ] Refazer sem consultar anotações
- [ ] Criar script que automatize backup de `/etc` com `tar + gpg`
- [ ] Avançar para *Linux Fundamentals Part 2* (processos, serviços, rede)