# 🚀 Auto Projeto & Repo

> CLI em Shell Script para automatizar a inicialização de projetos, estrutura de arquivos (scaffolding), estratégia de branches Git e criação de repositórios no GitHub em um único comando.

![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS-informational?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

---

## ⚡ Instalação Rápida

Instale ou atualize o executável em `~/.local/bin` com um único comando:

```bash
curl -sSL [https://raw.githubusercontent.com/mazinhorj/autoprojrepo/main/install.sh](https://raw.githubusercontent.com/mazinhorj/autoprojrepo/main/install.sh) | bash

```

> **Nota:** Certifique-se de que `~/.local/bin` esteja no seu `$PATH`. Se necessário, adicione `export PATH="$HOME/.local/bin:$PATH"` ao seu `~/.bashrc` ou `~/.zshrc`.

---

## ✨ Funcionalidades

* **Scaffolding Multi-Stack:** Estruturas prontas com `.gitignore`, `.env.example` e arquivos base para diversas tecnologias.
* **Git Flow Pré-configurado:** Inicializa o repositório com branch principal `main`, homologação `stg` e deixa você pronto para programar na branch `dsv`.
* **Commit Inicial Limpo:** Cria um commit vazio na raiz antes de aplicar o scaffold, facilitando rebase e histórico limpo.
* **Integração com GitHub CLI:** Cria repositórios (pessoais ou em organizações) e publica todas as branches com rastreamento upstream configurado (`-u`).
* **Instalação Automática do `gh`:** Detecta distribuições Linux (Debian, Ubuntu, Fedora, Arch, Alpine, openSUSE) e macOS (Homebrew) para instalar dependências que faltarem.
* **Abertura Automática:** Abre diretamente o diretório do projeto no VS Code (`code .`) ao concluir.
* **Auto-Update e Desinstalação:** Atualize para a versão mais recente com `--update` ou remova com `--uninstall`.

---

## 🛠️ Como Usar

```bash
autoprojrepo <nome-do-projeto> [OPÇÕES]

```

### Exemplos de Uso

```bash
# Projeto n8n privado (padrão)
autoprojrepo bot-automacao --template n8n

# API Python pública no GitHub
autoprojrepo api-pagamento -t python --public

# Microsserviço em Go para uma organização do GitHub
autoprojrepo minha-org/auth-service -t go

# Apenas local (sem criar repositório remoto no GitHub)
autoprojrepo teste-local --no-remote

# Atualizar o script para a versão mais recente
autoprojrepo --update

```

---

## 📦 Stacks & Templates Suportados

| Template | Flag | Arquivos e Estrutura Gerada |
| --- | --- | --- |
| **Generic** *(Padrão)* | `-t generic` | `.gitignore` amplo, `.env.example`, `README.md` |
| **n8n** | `-t n8n` | Pastas `workflows/` e `sql/`, `.env.example`, `.gitignore` |
| **Python** | `-t python` | Pastas `src/` e `tests/`, `requirements.txt`, `.gitignore` Python |
| **Node.js** | `-t node` | Pastas `src/` e `tests/`, `package.json`, `.gitignore` Node |
| **Docker** | `-t docker` | `Dockerfile`, `docker-compose.yml`, `.dockerignore`, `.gitignore` |
| **Go** | `-t go` | Pastas `cmd/<projeto>/`, `internal/`, `pkg/`, `main.go`, `.gitignore` |

---

## ⚙️ Opções & Flags

| Flag | Descrição |
| --- | --- |
| `-t, --template <stack>` | Define a stack do scaffold (padrão: `generic`) |
| `--public` | Cria o repositório GitHub como **público** (padrão: `privado`) |
| `--no-remote` | Inicializa apenas a estrutura Git local, sem criar repositório no GitHub |
| `--no-code` | Não abre o VS Code automaticamente ao finalizar |
| `--update` | Atualiza o `autoprojrepo` para a última versão disponível |
| `--uninstall` | Remove o utilitário do sistema |
| `-v, --version` | Exibe a versão instalada |
| `-h, --help` | Exibe o menu de ajuda e opções |

---

## 🌿 Estratégia de Branches

O script implementa automaticamente o seguinte fluxo de ramificação:

```text
(initial empty commit)
         │
       main (Produção)
         │
        stg (Homologação / Staging)
         │
        dsv (Desenvolvimento ativo ── checkout inicial)

```

---

## 🤝 Como Contribuir

Contribuições da comunidade são muito bem-vindas! Você pode colaborar com:

* Novos templates de stacks (ex: Rust, Java/Spring, Flutter, PHP/Laravel, Elixir).
* Suporte a outros editores além do VS Code (ex: Neovim, Zed, Cursor, IntelliJ).
* Melhorias de compatibilidade em sistemas operacionais e shells.

Consulte o nosso guia em [CONTRIBUTING.md](https://github.com/mazinhorj/autoprojrepo/tree/main?tab=contributing-ov-file) para saber como enviar uma Pull Request ou abrir uma Issue.

---

## 📄 Licença

Distribuído sob a licença **MIT**. Veja o arquivo `LICENSE` para mais detalhes.

## 👤 Autor

Criado e mantido por **Mazinho RJ** ([@mazinhorj](https://github.com/mazinhorj)). \
Founder & CEO na [OM Software **<ॐ/>** &copy;](https://omsoftware.com.br)

* **GitHub:** [@mazinhorj](https://github.com/mazinhorj)
* **LinkedIn:** [@mazinhorj](https://www.linkedin.com/in/mazinhorj)

