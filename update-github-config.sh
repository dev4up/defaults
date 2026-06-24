#!/usr/bin/env bash
set -euo pipefail

show_help() {
  cat <<'EOF'
Usage: ./update-github-config.sh

This script updates the current working directory with the following files from a GitHub repository branch:
  - .vscode/
  - settings.json
  - .editorconfig
  - .gitignore
  - custom.d.ts

It requires that the current directory contains a valid .git repository.

The repository is inferred from the current git origin remote. You can override the branch with BRANCH.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

if [[ ! -d .git ]]; then
  echo "Erro: diretório .git não encontrado neste caminho. Execute o script dentro do repositório git." >&2
  exit 1
fi

BRANCH="${BRANCH:-main}"

if ! repo_url=$(git remote get-url origin 2>/dev/null); then
  echo "Erro: não foi possível obter o remote 'origin'." >&2
  exit 1
fi

# Normalize GitHub remote URL
if [[ "$repo_url" =~ ^git@github.com:(.+)/(.+)\.git$ ]]; then
  REPO_USER="${BASH_REMATCH[1]}"
  REPO_NAME="${BASH_REMATCH[2]}"
elif [[ "$repo_url" =~ ^https://github.com/(.+)/(.+)\.git$ ]]; then
  REPO_USER="${BASH_REMATCH[1]}"
  REPO_NAME="${BASH_REMATCH[2]}"
elif [[ "$repo_url" =~ ^https://github.com/(.+)/(.+)$ ]]; then
  REPO_USER="${BASH_REMATCH[1]}"
  REPO_NAME="${BASH_REMATCH[2]}"
else
  echo "Erro: remote origin não parece ser um repositório GitHub válido." >&2
  exit 1
fi

ARCHIVE_URL="https://github.com/${REPO_USER}/${REPO_NAME}/archive/refs/heads/${BRANCH}.tar.gz"

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

echo "Baixando arquivos de ${REPO_USER}/${REPO_NAME}@${BRANCH}..."
if ! curl -fsSL "$ARCHIVE_URL" -o "$tmpdir/repo.tar.gz"; then
  echo "Erro: falha ao baixar o archive de $ARCHIVE_URL" >&2
  exit 1
fi

archive_root="${REPO_NAME}-${BRANCH}"

echo "Extraindo arquivos..."

tar -xzf "$tmpdir/repo.tar.gz" -C "$tmpdir" \
  "$archive_root/.vscode" \
  "$archive_root/settings.json" \
  "$archive_root/.editorconfig" \
  "$archive_root/.gitignore" \
  "$archive_root/custom.d.ts"

if [[ -d "$tmpdir/$archive_root/.vscode" ]]; then
  rm -rf .vscode
  cp -r "$tmpdir/$archive_root/.vscode" .
  echo "Atualizado .vscode/"
fi

for file in settings.json .editorconfig .gitignore custom.d.ts; do
  if [[ -f "$tmpdir/$archive_root/$file" ]]; then
    cp "$tmpdir/$archive_root/$file" .
    echo "Atualizado $file"
  else
    echo "Aviso: $file não existe no repositório remoto." >&2
  fi
 done

echo "? Atualização concluída com sucesso."
