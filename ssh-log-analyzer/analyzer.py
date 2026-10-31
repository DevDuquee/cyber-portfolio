import argparse
from collections import Counter
from pathlib import Path
import re


def ler_log(caminho):
    with caminho.open(encoding="utf-8") as arquivo:
        return arquivo.readlines()


def contar_falhas(linhas):
    padrao = re.compile(
        r"Failed password for (?:invalid user )?(\S+) from (\S+)",
        re.IGNORECASE,
    )
    ips = Counter()
    usuarios = Counter()

    for linha in linhas:
        resultado = padrao.search(linha)
        if resultado:
            usuario, ip = resultado.groups()
            ips[ip] += 1
            usuarios[usuario] += 1

    return ips, usuarios


def mostrar_resumo(ips, usuarios, limite=5):
    print("IPs que mais tentaram logar:")
    for ip, quantidade in ips.most_common(limite):
        print(f"{ip} : {quantidade}")

    print("\nUsuários que mais tentaram logar:")
    for usuario, quantidade in usuarios.most_common(limite):
        print(f"{usuario} : {quantidade}")


def salvar_relatorio(ips, usuarios, caminho_final):
    with caminho_final.open("w", encoding="utf-8") as arquivo:
        arquivo.write("IPs que mais tentaram logar:\n")
        for ip, quantidade in ips.most_common():
            arquivo.write(f"{ip} : {quantidade}\n")

        arquivo.write("\nUsuários que mais tentaram logar:\n")
        for usuario, quantidade in usuarios.most_common():
            arquivo.write(f"{usuario} : {quantidade}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Analisa tentativas de login SSH malsucedidas em um arquivo de log."
    )
    parser.add_argument(
        "arquivo",
        type=Path,
        help="caminho do arquivo de log de autenticação",
    )
    parser.add_argument(
        "--relatorio",
        type=Path,
        default=Path("relatorio_falhas.log"),
        help="caminho do relatório de saída (padrão: relatorio_falhas.log)",
    )
    args = parser.parse_args()

    linhas = ler_log(args.arquivo)
    ips, usuarios = contar_falhas(linhas)
    mostrar_resumo(ips, usuarios)
    salvar_relatorio(ips, usuarios, args.relatorio)


if __name__ == "__main__":
    main()
