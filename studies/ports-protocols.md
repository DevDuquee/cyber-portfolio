# Portas & Protocolos — Cheatsheet Security+

## TCP Essenciais

| Porta | Protocolo | Serviço | Uso Comum | Risco se Exposta |
|-------|-----------|---------|-----------|------------------|
| 21 | FTP | File Transfer | Legacy, anonymous login | Credenciais em claro, anonymous access |
| 22 | SSH | Secure Shell | Admin remoto | Brute force, chaves fracas, versões antigas |
| 23 | Telnet | Remote Login | **NUNCA USE** | Tudo em claro |
| 25 | SMTP | Mail Transfer | Envio e-mail | Open relay, enumeração usuários |
| 53 | DNS | Domain Resolution | Resolução nomes | Zone transfer, DNS tunneling, amplification |
| 80 | HTTP | Web | Sites não criptografados | MITM, injection, info disclosure |
| 110 | POP3 | Mail Retrieval | E-mail cliente | Credenciais em claro (se não TLS) |
| 139 | NetBIOS | File Sharing (SMB v1) | Legacy Windows | EternalBlue, enumeração shares |
| 143 | IMAP | Mail Retrieval | E-mail cliente | Credenciais em claro (se não TLS) |
| 443 | HTTPS | Web Secure | Sites modernos | TLS downgrade, certs expirados, vulns app |
| 445 | SMB | File Sharing (Windows) | Compartilhamento rede | EternalBlue, WannaCry, lateral movement |
| 3389 | RDP | Remote Desktop | Admin Windows | Brute force, BlueKeep, credential theft |
| 5900 | VNC | Remote Desktop | Admin multiplataforma | Auth fraca, sem criptografia nativa |
| 3306 | MySQL | Database | Apps web | SQLi, credenciais default, exposição dados |
| 5432 | PostgreSQL | Database | Apps web | Similar ao MySQL |
| 6379 | Redis | Cache/DB | Sessions, queues | Sem auth default, RCE via config |
| 8080 | HTTP Proxy | Web Alternate | Dev, proxies | Frequentemente sem auth, painéis admin |
| 8443 | HTTPS Alt | Web Secure Alt | Admin panels | Certs auto-assinados, vulns app |

## UDP Essenciais

| Porta | Protocolo | Serviço | Risco |
|-------|-----------|---------|-------|
| 53 | DNS | Resolução | Amplification, tunneling |
| 67/68 | DHCP | IP Assignment | Rogue DHCP, MITM |
| 69 | TFTP | File Transfer | Sem auth, config devices |
| 123 | NTP | Time Sync | Amplification (monlist), drift |
| 161/162 | SNMP | Monitoring | Community strings default, info leak |
| 500/4500 | IPsec/IKE | VPN | Weak PSK, aggressive mode |
| 1900 | SSDP | UPnP | Reflection/amplification |

## Portas de Gerenciamento/Monitoramento

| Porta | Protocolo | Serviço |
|-------|-----------|---------|
| 161 | SNMP | Monitoramento rede |
| 389/636 | LDAP/LDAPS | Diretório (AD) |
| 88 | Kerberos | Auth Windows/Linux |
| 464 | Kerberos Password Change | |
| 5985/5986 | WinRM | Remote mgmt Windows |
| 9100 | Prometheus | Metrics exporter |

## Flags de Scan Nmap Úteis

```bash
# Top 1000 portas TCP SYN (rápido, stealth)
nmap -sS -T4 --top-ports 1000 <target>

# Todas portas TCP + versão + scripts default
nmap -sS -sV -sC -p- -T4 <target>

# UDP top 100 (lento)
nmap -sU --top-ports 100 -T4 <target>

# Detecção de OS + traceroute
nmap -O --traceroute <target>

# Output parsável
nmap -oX scan.xml -oN scan.txt -oG scan.gnmap <target>

# Vuln scripts específicos
nmap --script vuln <target>
nmap --script smb-vuln-ms17-010 <target>  # EternalBlue
```

## Protocolos Camada Aplicação (Security+ Foco)

| Protocolo | Porta(s) | Criptografia | Auth | Notas Exame |
|-----------|----------|--------------|------|-------------|
| HTTP | 80 | ❌ | Basic/Digest | Inseguro |
| HTTPS | 443 | TLS 1.2/1.3 | Certificados | Obrigatório |
| SSH | 22 | AES/ChaCha20 | Pubkey/Password | Substitui Telnet/rsh |
| SFTP | 22 | SSH | Pubkey/Password | Sobre SSH, não FTP |
| FTPS | 990/21 | TLS | Certificados | FTP sobre TLS |
| SMTPS | 465 | TLS | Certificados | SMTP sobre TLS |
| IMAPS | 993 | TLS | Certificados | IMAP sobre TLS |
| POP3S | 995 | TLS | Certificados | POP3 sobre TLS |
| LDAPS | 636 | TLS | Certificados/SASL | LDAP sobre TLS |
| SNMPv3 | 161 | AES/DES | User-based | v1/v2c inseguros |
| DNS over TLS | 853 | TLS | — | Privacidade DNS |
| DNS over HTTPS | 443 | HTTPS | — | Privacidade DNS |

## Memorização Rápida (Anki)

**Front:** Porta 22  
**Back:** SSH — Admin remoto seguro. Brute force comum. Hardening: `PermitRootLogin no`, `PubkeyAuthentication yes`, `PasswordAuthentication no`, `Port 2222`.

**Front:** Porta 445  
**Back:** SMB (CIFS) — Compartilhamento Windows. EternalBlue (MS17-010). Bloquear na borda. Desabilitar SMBv1.

**Front:** Porta 3389  
**Back:** RDP — Remote Desktop Windows. BlueKeep (CVE-2019-0708). MFA + Gateway RD + Network Level Auth.

**Front:** Diff TCP vs UDP  
**Back:** TCP: conexão, confiável, ordenado (HTTP, SSH, SMTP). UDP: sem conexão, rápido, sem garantia (DNS, DHCP, NTP, streaming).

---

## Referências Rápidas

- `/etc/services` — mapeamento porta/serviço local
- `getent services <porta>` — consulta programática
- IANA Port Registry: https://www.iana.org/assignments/service-names-port-numbers/