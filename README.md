# Atualização de Configurações do GitHub

Este projeto inclui um script e um workflow para atualizar arquivos de configuração locais a partir de um repositório GitHub.

## O que é incluído

O script baixa e atualiza os seguintes itens no diretório atual:

- `.vscode/`
- `settings.json`
- `.editorconfig`
- `.gitignore`
- `custom.d.ts`

## Workflow automático

Um workflow GitHub Actions (`.github/workflows/build-artifact.yml`) é executado sempre que há mudanças em um dos arquivos listados acima. Ele gera um artefato de download chamado `downloadable-files` contendo os arquivos:

- `.vscode/`
- `settings.json`
- `.editorconfig`
- `.gitignore`
- `custom.d.ts`

## Uso do script via curl

O script `update-github-config.sh` pode ser executado diretamente via `curl` usando o repositório atual `dev4up/defaults`:

```bash
curl -fsSL https://raw.githubusercontent.com/dev4up/defaults/main/update-github-config.sh | bash
```

### Se usar outro branch

```bash
BRANCH=develop curl -fsSL https://raw.githubusercontent.com/dev4up/defaults/main/update-github-config.sh | bash
```

## Requisitos

- o diretório atual deve ser um repositório Git com `.git`
- o remoto `origin` deve apontar para um repositório GitHub

## Observações

- O script sobrescreve os arquivos locais mencionados.
- Se algum dos arquivos não estiver presente no repositório remoto, o script exibirá um aviso.
