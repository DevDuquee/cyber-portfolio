# SSH Log Analyzer

Pequeno script em Python que analisa logs de autenticação SSH e conta as tentativas de login malsucedidas por endereço IP e usuário.

## Requisitos

- Python 3
- Um arquivo de log de autenticação SSH, como `/var/log/auth.log` (Debian/Ubuntu) ou `/var/log/secure` (Fedora/RHEL)

## Como usar

```bash
python3 analyzer.py /caminho/para/o/arquivo-de-log
```

Exemplo em um sistema Debian/Ubuntu:

```bash
python3 analyzer.py /var/log/auth.log
```

O script pode precisar de permissões para ler o arquivo. Ele apenas exibe as contagens no terminal; não bloqueia IPs nem altera o sistema.
