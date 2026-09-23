# Cybersecurity Portfolio

Portfólio técnico demonstrando progressão em fundamentos de redes, Linux e segurança da informação. Foco em automação, documentação e raciocínio analítico.

## Estrutura

```
cyber-portfolio/
├── scripts/                 # Automações úteis (Bash/Python)
│   ├── linux-audit.sh       # Coleta info de sistema: processos, portas, usuários, updates
│   ├── log-analyzer.py      # Parseia auth.log/syslog, alerta via stdout/Telegram
│   └── recon-automation/    # Recon passivo/ativo (nmap, nuclei, whois, dns)
├── writeups/                # Análises técnicas de labs/CTFs
│   ├── thm-linux-fundamentals-1.md
│   ├── thm-intro-to-lan.md
│   └── thm-passive-recon.md
├── configs/                 # Hardening, dotfiles, policies
│   ├── sshd_config.hardened
│   ├── ufw-rules.md
│   └── security-policy-template.md
├── studies/                 # Resumos técnicos (Anki export, cheatsheets)
│   ├── ports-protocols.md
│   ├── linux-permissions.md
│   └── crypto-basics.md
└── docs/                    # Documentação de projetos maiores
    └── siem-lab/            # Ex: Wazuh + Sigma rules
```

## Projetos Atuais

| Projeto | Descrição | Status | Tecnologias |
|---------|-----------|--------|-------------|
| `linux-audit.sh` | Script de auditoria básica de endpoint Linux | ✅ Concluído | Bash, systemd, ss, awk |
| `log-analyzer.py` | Parser de logs de autenticação com alerta | 🚧 Em andamento | Python, regex, logging |
| THM Writeups | Documentação de salas concluídas | ✅ 3/7 | Markdown, screenshots |

## Habilidades Demonstradas

- **Redes:** OSI/TCP-IP, subnetting, DNS/HTTP, captura de tráfego (tshark)
- **Linux:** Permissões, systemd, journalctl, bash scripting, hardening básico
- **Segurança:** CIA Triad, criptografia simétrica/assimétrica, TLS, firewall (UFW/iptables), LGPD
- **Ferramentas:** Nmap, Nuclei, Wireshark, TryHackMe, VirtualBox, Git
- **Metodologia:** Documentação técnica, versionamento, automação de tarefas repetitivas

## Próximos Passos (Roadmap)

- [ ] Concluir Security+ (SY0-701) — Dez/2025
- [ ] eJPT / PNPT — Hands-on pentest
- [ ] Lab SIEM caseiro (Wazuh + Elastic + Sigma rules)
- [ ] Especialização: Blue Team / Cloud Sec / AppSec

## Contato

- LinkedIn: [seu-linkedin]
- Email: [seu-email]
- TryHackMe: [seu-user]