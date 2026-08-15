#!/usr/bin/env bash
# ==============================================================================
# Script: autoprojrepo
# Autor: Mazinho RJ (@mazinhorj)
# Repositório: https://github.com/mazinhorj/autoprojrepo
# Licença: MIT
# ==============================================================================
set -euo pipefail

# Metadados da Ferramenta (Origem do utilitário para auto-update)
VERSION="1.0.0"
TOOL_OWNER="mazinhorj"
TOOL_REPO="autoprojrepo"
BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/${TOOL_OWNER}/${TOOL_REPO}/${BRANCH}/autoprojrepo.sh"

TEMPLATE="generic"
VISIBILITY="--private"
OPEN_CODE=true
CREATE_REMOTE=true
PROJECT_NAME=""

# -----------------------------------------------------------------------------
# Exibição de Ajuda
# -----------------------------------------------------------------------------
show_help() {
  cat <<EOF
# MADE IN BRAZIL 🇧🇷 - @mazinhorj
Uso: autoprojrepo <nome-do-projeto> [OPÇÕES]

Inicializa um repositório padronizado com Git, GitHub CLI e scaffolds por stack.

Opções de Projeto:
  -t, --template <stack>   Stack: generic, n8n, python, node, docker, go
                           (Padrão: generic)
  --public                 Cria o repositório como público (Padrão: privado)
  --no-remote              Apenas inicializa o projeto localmente (sem GitHub)
  --no-code                Não abre o VS Code ao finalizar

Manutenção & Utilidades:
  --update                 Atualiza o script para a versão mais recente
  --uninstall              Remove o executável do sistema
  -v, --version            Exibe a versão instalada
  -h, --help               Exibe esta mensagem de ajuda

Exemplos:
  autoprojrepo meu-bot --template n8n
  autoprojrepo api-pagamento -t python --public
  autoprojrepo cli-tool -t go --no-remote
  autoprojrepo --update
EOF
}

# -----------------------------------------------------------------------------
# Rotinas de Manutenção
# -----------------------------------------------------------------------------
self_update() {
  echo "🔄 Verificando e baixando a versão mais recente..."
  local target_path
  target_path="$(command -v autoprojrepo 2>/dev/null || realpath "$0")"

  if [ ! -w "$target_path" ] && [ ! -w "$(dirname "$target_path")" ]; then
    echo "❌ Erro: Sem permissão de escrita em '$target_path'. Tente executar com sudo."
    exit 1
  fi

  if command -v curl &>/dev/null; then
    curl -fsSL "$RAW_URL" -o "$target_path"
  elif command -v wget &>/dev/null; then
    wget -qO "$target_path" "$RAW_URL"
  else
    echo "❌ Erro: 'curl' ou 'wget' é necessário para atualizar."
    exit 1
  fi

  chmod +x "$target_path"
  echo "✅ Atualização concluída com sucesso em: $target_path"
  exit 0
}

self_uninstall() {
  local target_path
  target_path="$(command -v autoprojrepo 2>/dev/null || realpath "$0")"

  echo "⚠️ Tem certeza que deseja remover o 'autoprojrepo'? (s/N)"
  read -r confirm
  if [[ "$confirm" =~ ^[sS]$ ]]; then
    rm -f "$target_path"
    echo "🗑️ Executável removido de: $target_path"
    echo "✅ Desinstalação concluída."
  else
    echo "Operação cancelada."
  fi
  exit 0
}

# -----------------------------------------------------------------------------
# Instalação Multi-distro do GitHub CLI
# -----------------------------------------------------------------------------
install_gh_cli() {
  echo "⚙️ GitHub CLI ('gh') não encontrado. Detectando gerenciador de pacotes..."

  if command -v apt-get &>/dev/null; then
    sudo mkdir -p -m 755 /etc/apt/keyrings
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update && sudo apt-get install -y gh

  elif command -v dnf &>/dev/null; then
    sudo dnf install -y 'dnf-command(config-manager)'
    sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo dnf install -y gh

  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm github-cli

  elif command -v zypper &>/dev/null; then
    sudo zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo
    sudo zypper ref
    sudo zypper install -y gh

  elif command -v apk &>/dev/null; then
    sudo apk add --no-cache github-cli

  elif command -v brew &>/dev/null; then
    brew install gh

  else
    echo "❌ Gerenciador de pacotes não reconhecido. Instale o GitHub CLI manualmente: https://cli.github.com"
    exit 1
  fi
}

# -----------------------------------------------------------------------------
# Templates de Estrutura de Arquivos
# -----------------------------------------------------------------------------
scaffold_project() {
  local stack="$1"
  local name="$2"

  cat <<EOF > README.md
# $name

Projeto inicializado via \`autoprojrepo\` (Template: **$stack**).

## Branches
* \`main\`: Produção
* \`stg\`: Homologação / Staging
* \`dsv\`: Desenvolvimento ativo
EOF

  case "$stack" in
    n8n)
      mkdir -p workflows sql
      echo "n8n workflows storage" > workflows/myworkflows.txt
      echo "-- SQL migration scripts" > sql/mysqls.sql
      cat <<EOF > .gitignore
.env
*.log
__pycache__/
EOF
      touch .env.example
      ;;

    python)
      mkdir -p src tests
      touch src/__init__.py tests/__init__.py
      cat <<EOF > requirements.txt
# Dependências do projeto
EOF
      cat <<EOF > .gitignore
__pycache__/
*.py[cod]
*$py.class
.venv/
env/
venv/
.env
*.log
.pytest_cache/
EOF
      touch .env.example
      ;;

    node)
      mkdir -p src tests
      cat <<EOF > package.json
{
  "name": "$name",
  "version": "1.0.0",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "MIT"
}
EOF
      touch src/index.js
      cat <<EOF > .gitignore
node_modules/
dist/
.env
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF
      touch .env.example
      ;;

    docker)
      cat <<EOF > Dockerfile
FROM alpine:latest
WORKDIR /app
COPY . .
CMD ["sh"]
EOF
      cat <<EOF > docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    volumes:
      - .:/app
    environment:
      - NODE_ENV=development
EOF
      cat <<EOF > .dockerignore
.git
.gitignore
.env
*.log
EOF
      cat <<EOF > .gitignore
.env
*.log
EOF
      touch .env.example
      ;;

    go)
      mkdir -p cmd/"$name" internal pkg
      touch cmd/"$name"/main.go
      cat <<EOF > .gitignore
bin/
dist/
*.exe
*.exe~
*.dll
*.so
*.dylib
.env
*.log
EOF
      touch .env.example
      ;;

    generic|*)
      cat <<EOF > .gitignore
.env
*.log
.DS_Store
EOF
      touch .env.example
      ;;
  esac
}

# -----------------------------------------------------------------------------
# Parsing de Parâmetros de Linha de Comando
# -----------------------------------------------------------------------------
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update)
      self_update
      ;;
    --uninstall)
      self_uninstall
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    -v|--version)
      echo "autoprojrepo v$VERSION - por @mazinhorj"
      exit 0
      ;;
    -t|--template)
      TEMPLATE="$2"
      shift 2
      ;;
    --public)
      VISIBILITY="--public"
      shift
      ;;
    --no-remote)
      CREATE_REMOTE=false
      shift
      ;;
    --no-code)
      OPEN_CODE=false
      shift
      ;;
    -*)
      echo "❌ Opção desconhecida: $1"
      show_help
      exit 1
      ;;
    *)
      if [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME="$1"
      else
        echo "❌ Argumento inesperado: $1"
        show_help
        exit 1
      fi
      shift
      ;;
  esac
done

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ Erro: O nome do projeto é obrigatório."
  show_help
  exit 1
fi

if [ -d "$PROJECT_NAME" ]; then
  echo "❌ Erro: O diretório '$PROJECT_NAME' já existe."
  exit 1
fi

# -----------------------------------------------------------------------------
# Verificação de Dependências e Autenticação
# -----------------------------------------------------------------------------
if [ "$CREATE_REMOTE" = true ]; then
  if ! command -v gh &>/dev/null; then
    install_gh_cli
  fi

  if ! gh auth status &>/dev/null; then
    echo "🔑 Autenticação necessária no GitHub. Conecte sua conta:"
    gh auth login
  fi
fi

# -----------------------------------------------------------------------------
# Criação do Projeto e Fluxo Git
# -----------------------------------------------------------------------------
mkdir "$PROJECT_NAME"
cd "$PROJECT_NAME"

git init
git branch -M main

# 1. Commit inicial vazio (raiz limpa para ramificações)
git commit --allow-empty -m "chore: initial empty commit"

# 2. Gera arquivos do scaffold
scaffold_project "$TEMPLATE" "$PROJECT_NAME"

# 3. Commit da estrutura de arquivos
git add .
git commit -m "feat: scaffold $TEMPLATE project structure"

# 4. Configuração Remota no GitHub
if [ "$CREATE_REMOTE" = true ]; then
  echo "🚀 Criando repositório ($VISIBILITY) no GitHub..."
  gh repo create "$PROJECT_NAME" "$VISIBILITY" --source=. --remote=origin

  echo "📤 Publicando branches (main, stg, dsv)..."
  git push -u origin main

  git branch stg
  git push -u origin stg

  git checkout -b dsv
  git push -u origin dsv
else
  git branch stg
  git checkout -b dsv
fi

echo "✅ Projeto '$PROJECT_NAME' ($TEMPLATE) pronto na branch 'dsv'!"

# 5. Abertura no Editor
if [ "$OPEN_CODE" = true ] && command -v code &>/dev/null; then
  code .
fi
