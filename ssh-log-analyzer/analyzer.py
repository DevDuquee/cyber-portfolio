import argparse
from pathlib import Path
import re
from collections import Counter

parser = argparse.ArgumentParser(
    description="Analisa tentativas de login SSH malsucedidas em um arquivo de log."
)
parser.add_argument("arquivo", type=Path, help="caminho do arquivo de log de autenticação")
args = parser.parse_args()

ips = Counter()
usuarios = Counter()

with args.arquivo.open(encoding="utf-8") as f:
    linhas = f.readlines()

padrao = re.compile(r"Failed password for (?:invalid user )?(\S+) from (\S+)", re.IGNORECASE)
for linha in linhas:
    resultado = padrao.search(linha)
    if resultado:
        usuario, ip = resultado.groups()
        ips[ip] += 1
        usuarios[usuario] += 1

print("IPs que mais tentaram logar:")
for ip, qnt in ips.most_common():
    print(f"{ip} : {qnt}")

print("\nUsuários que mais tentaram logar:")
for usuario, qnt in usuarios.most_common():
    print(f"{usuario} : {qnt}")
