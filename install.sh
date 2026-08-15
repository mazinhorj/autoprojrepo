#!/usr/bin/env bash
# ==============================================================================
# Script: autoprojrepo
# Autor: Mazinho RJ (@mazinhorj)
# Repositório: https://github.com/mazinhorj/autoprojrepo
# Licença: MIT
# ==============================================================================
set -euo pipefail

# Metadados do repositório oficial
TOOL_OWNER="mazinhorj"
TOOL_REPO="autoprojrepo"
BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/${TOOL_OWNER}/${TOOL_REPO}/${BRANCH}/autoprojrepo.sh"

INSTALL_DIR="${HOME}/.local/bin"
BIN_NAME="autoprojrepo"
TARGET_PATH="${INSTALL_DIR}/${BIN_NAME}"

echo "📦 Instalando ${BIN_NAME}..."

# 1. Cria o diretório de destino caso não exista
mkdir -p "${INSTALL_DIR}"

# 2. Download do script principal
if command -v curl &>/dev/null; then
  curl -fsSL "${RAW_URL}" -o "${TARGET_PATH}"
elif command -v wget &>/dev/null; then
  wget -qO "${TARGET_PATH}" "${RAW_URL}"
else
  echo "❌ Erro: 'curl' ou 'wget' é necessário para concluir a instalação."
  exit 1
fi

# 3. Concede permissão de execução
chmod +x "${TARGET_PATH}"

echo "✅ Executável instalado em: ${TARGET_PATH}"

# 4. Verificação da variável PATH
if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
  echo ""
  echo "⚠️  Atenção: '${INSTALL_DIR}' não está no seu PATH atual."
  echo "Adicione a linha abaixo ao seu arquivo de configuração (~/.bashrc ou ~/.zshrc):"
  echo ""
  echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
  echo "Depois recarregue a sessão com: source ~/.bashrc (ou source ~/.zshrc)"
else
  echo "🚀 Instalação concluída com sucesso!"
  echo "Execute para testar: ${BIN_NAME} --help"
fi
