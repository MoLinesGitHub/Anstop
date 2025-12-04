"""
Linter básico para scripts Python de Anstop.
Verifica formato PEP8, imports no usados y errores comunes.
"""

import subprocess
import sys


def run_linter():
    print("=== Ejecutando Linter ===")
    try:
        subprocess.run(["flake8", "scripts", "tools"], check=True)
    except FileNotFoundError:
        print("[ERROR] flake8 no está instalado.")
        print("Instálalo dentro de tu entorno venv:")
        print("pip install flake8")
        sys.exit(1)
    except subprocess.CalledProcessError:
        print("[LINTER] Encontró problemas.")
        sys.exit(1)

    print("✔ OK: No hay problemas de estilo.")


if __name__ == "__main__":
    run_linter()
