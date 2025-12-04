import subprocess
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent


def run(cmd, description):
    print(f"\n=== {description} ===")
    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError:
        print(f"[ERROR] Falló: {cmd}")
        sys.exit(1)


def main():
    paths = ["scripts", "tools", "tests"]

    # 1. BLACK — formateo completo
    run(["black"] + paths, "Formateando código con black")

    # 2. ISORT — ordenar imports
    run(["isort"] + paths, "Ordenando imports con isort")

    # 3. FLAKE8 — validación final
    try:
        subprocess.run(["flake8"] + paths, check=True)
    except subprocess.CalledProcessError:
        print("\n[LINTER] Encontró problemas tras autoformatear.")
        print("Corrige manualmente los casos especiales.")
        sys.exit(1)

    print("\n✓ Código formateado y validado correctamente.")


if __name__ == "__main__":
    main()
