#!/bin/bash
# linux-audit.sh — Auditoria básica de endpoint Linux
# Uso: ./linux-audit.sh [--json] [--output arquivo]

set -euo pipefail

JSON_OUTPUT=false
OUTPUT_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --json) JSON_OUTPUT=true; shift ;;
        --output) OUTPUT_FILE="$2"; shift 2 ;;
        *) echo "Opção desconhecida: $1"; exit 1 ;;
    esac
done

escape_json() {
    printf '%s' "$1" | sed 's/[\\"]/\\&/g' | tr -d '\n\r\t'
}

collect_json() {
    local hostname=$(hostname)
    local kernel=$(uname -r)
    local uptime=$(uptime -p 2>/dev/null || uptime | sed 's/.*up *//' | sed 's/,.*//')
    local users=$(who | awk '{print $1}' | sort -u | paste -sd "," -)

    # Processos top 10
    local proc_json=$(ps aux --sort=-%cpu | head -11 | tail -10 | awk '
        {cmd=""; for(i=11;i<=NF;i++) cmd=cmd $i " "; gsub(/"/, "\\\"", cmd); gsub(/\n/, "", cmd); printf "{\"pid\":%s,\"user\":\"%s\",\"cpu\":%s,\"mem\":%s,\"cmd\":\"%s\"},", $2, $1, $3, $4, cmd}' | sed 's/,$//')

    # Portas
    local ports_json=$(ss -tulnp 2>/dev/null | awk 'NR>1 {split($7,a,"="); pid=a[2]; gsub(/,/,"",pid); gsub(/"/,"\\\"",$6); printf "{\"proto\":\"%s\",\"local\":\"%s\",\"pid\":\"%s\",\"process\":\"%s\"},", $1, $5, pid, $6}' | sed 's/,$//')

    # Logins
    local logins_json=""
    if command -v last &>/dev/null; then
        logins_json=$(last -n 10 2>/dev/null | head -10 | awk 'NF>=6 {gsub(/"/, "\\\"", $3); printf "{\"user\":\"%s\",\"tty\":\"%s\",\"from\":\"%s\",\"date\":\"%s %s %s\"},", $1, $2, $3, $4, $5, $6}' | sed 's/,$//')
    else
        logins_json=$(journalctl -u ssh --since "7 days ago" -n 10 -o cat 2>/dev/null | grep -E "(Accepted|Failed)" | head -10 | awk '{user=$(NF-5); tty=$(NF-3); from=$(NF-1); date=$1" "$2" "$3; gsub(/"/, "\\\"", from); printf "{\"user\":\"%s\",\"tty\":\"%s\",\"from\":\"%s\",\"date\":\"%s\"},", user, tty, from, date}' | sed 's/,$//')
    fi

    local updates=0
    if command -v apt &>/dev/null; then
        updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable 2>/dev/null)
        [[ -z "$updates" ]] && updates=0
    fi

    local ssh_status=$( (systemctl is-active ssh 2>/dev/null || systemctl is-active sshd 2>/dev/null) | head -1 || echo "inactive")

    cat <<EOF
{
  "timestamp": "$(date -Iseconds)",
  "host": {
    "hostname": "$(escape_json "$hostname")",
    "kernel": "$(escape_json "$kernel")",
    "uptime": "$(escape_json "$uptime")",
    "users_logged_in": "$(escape_json "$users")"
  },
  "processes_top_cpu": [$proc_json],
  "listening_ports": [$ports_json],
  "recent_logins": [$logins_json],
  "security": {
    "ssh_status": "$ssh_status",
    "pending_updates": $updates
  }
}
EOF
}

collect_text() {
    echo "=== AUDITORIA LINUX - $(date) ==="
    echo "Host: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime | sed 's/.*up *//' | sed 's/,.*//')"
    echo "Usuários logados: $(who | awk '{print $1}' | sort -u | paste -sd "," -)"
    echo ""
    echo "--- Top 10 Processos (CPU) ---"
    echo "PID     USER     CPU%   MEM%   CMD"
    ps aux --sort=-%cpu | head -11 | tail -10 | awk '{printf "%-8s %-8s %-6s %-6s %s\n", $2, $1, $3, $4, substr($0, index($0,$11))}'
    echo ""
    echo "--- Portas Ouvindo (TCP/UDP) ---"
    echo "PROTO   LOCAL ADDRESS         PID      PROCESS"
    ss -tulnp 2>/dev/null | awk 'NR>1 {split($7,a,"="); pid=a[2]; gsub(/,/,"",pid); printf "%-7s %-22s %-8s %s\n", $1, $5, pid, $6}'
    echo ""
    echo "--- Últimos Logins ---"
    echo "USER    TTY      FROM             DATE"
    if command -v last &>/dev/null; then
        last -n 10 2>/dev/null | head -10 | awk 'NF>=6 {printf "%-7s %-8s %-16s %s %s %s\n", $1, $2, $3, $4, $5, $6}'
    else
        journalctl -u ssh --since "7 days ago" -n 10 -o cat 2>/dev/null | grep -E "(Accepted|Failed)" | head -10 | awk '{user=$(NF-5); tty=$(NF-3); from=$(NF-1); date=$1" "$2" "$3; printf "%-7s %-8s %-16s %s\n", user, tty, from, date}'
    fi
    echo ""
    echo "--- Segurança ---"
    echo "SSH: $(systemctl is-active ssh 2>/dev/null || systemctl is-active sshd 2>/dev/null || echo "inactive")"
    local updates=0
    if command -v apt &>/dev/null; then
        updates=$(apt list --upgradable 2>/dev/null | grep -c upgradable || echo 0)
    fi
    echo "Updates pendentes: $updates"
}

main() {
    if [[ "$JSON_OUTPUT" == true ]]; then
        local data=$(collect_json)
        if [[ -n "$OUTPUT_FILE" ]]; then
            echo "$data" > "$OUTPUT_FILE"
            echo "Relatório salvo em: $OUTPUT_FILE"
        else
            echo "$data" | jq . 2>/dev/null || echo "$data"
        fi
    else
        collect_text
    fi
}

for cmd in ss ps awk; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "ERRO: '$cmd' não encontrado. Instale: sudo apt install $cmd" >&2
        exit 1
    fi
done

main "$@"