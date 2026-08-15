# Contribuindo com o Auto Projeto & Repo

Obrigado pelo interesse em contribuir com o **AutoProjRepo**! Este projeto é mantido pela comunidade e estamos abertos a correções, melhorias e novos templates de inicialização.

---

## 🎯 Formas de Contribuir

Você pode contribuir de diversas maneiras:

* **Adicionando Novos Templates de Stacks:** Criando scaffolds para stacks como Rust, Java/Spring, Flutter, Elixir, PHP/Laravel, etc.
* **Compatibilidade de Sistemas:** Melhorando a detecção de distros Linux, suporte a FreeBSD ou gerenciadores de pacotes alternativos.
* **Suporte a Outros Editores/IDEs:** Adicionando detecção de editores como Neovim, Zed, Cursor, IntelliJ ou Sublime Text via flags.
* **Correção de Bugs e Documentação:** Reportando problemas em Issues ou melhorando o `README.md`.

---

## 🚀 Como Adicionar um Novo Template

Para submeter um novo template de stack, edite a função `scaffold_project` dentro de `autoprojrepo.sh`:

1. Adicione a nova stack à estrutura `case "$stack" in`.
2. Crie a estrutura de diretórios (`mkdir -p`) necessária.
3. Adicione o `.gitignore` oficial/recomendado para a tecnologia.
4. Crie os arquivos base da stack (ex: `Cargo.toml`, `main.rs`, `pom.xml`, etc.).
5. Documente a nova flag no menu `show_help()` e na tabela do `README.md`.

### Exemplo de Template no Código

```bash
    rust)
      mkdir -p src tests
      cat <<EOF> Cargo.toml
[package]
name = "$name"
version = "0.1.0"
edition = "2021"

[dependencies]
EOF
      cat <<EOF> src/main.rs
fn main() {
    println!("Hello from $name!");
}
EOF
      cat <<EOF> .gitignore
/target/
**/*.rs.bk
*.log
.env
EOF
      touch .env.example
      ;;

```

---

## 🛠️ Fluxo de Trabalho (Workflow)

1. Faça um **Fork** deste repositório.
2. Clone o seu fork localmente:
```bash
git clone git@github.com:SEU_USUARIO/autoprojrepo.git
cd autoprojrepo

```


3. Crie uma branch para sua modificação:
```bash
git checkout -b feat/novo-template-rust
# ou
git checkout -b fix/compatibilidade-alpine

```


4. Faça suas alterações e teste localmente:
```bash
# Teste executando o script modificado
./autoprojrepo.sh meu-teste -t rust --no-remote

```


5. Valide a sintaxe do script usando o [ShellCheck](https://www.shellcheck.net/):
```bash
shellcheck autoprojrepo.sh install.sh

```


6. Faça commit usando o padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/):
* `feat: add rust project template`
* `fix: handle edge case in apk package detection`
* `docs: update supported templates table`


7. Faça o push para o seu fork:
```bash
git push origin feat/novo-template-rust

```


8. Abra um **Pull Request** detalhando as alterações propostas.

---

## 📋 Boas Práticas de Código

* **Segurança no Shell:** Mantenha a diretiva `set -euo pipefail` no início do script para evitar comportamentos inesperados em caso de falha.
* **Aspas em Variáveis:** Sempre envolva variáveis em aspas duplas (ex: `"$PROJECT_NAME"`, `"$1"`) para evitar quebras com espaços ou caracteres especiais.
* **Portabilidade:** Evite utilitários ou flags exclusivas de uma única distribuição sem tratamento condicional prévio.
* **Idempotência:** Garanta que novas rotinas não sobrescrevam arquivos existentes sem validação.

---

## 🐛 Reportando Problemas (Issues)

Ao abrir uma issue relatando um bug ou solicitando um recurso:

* Especifique sua **distribuição Linux / macOS** e a versão do **Bash/Zsh**.
* Inclua a saída completa do erro exibido no terminal.
* Descreva o passo a passo para reproduzir o comportamento.

