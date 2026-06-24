# Especificação: Defaults Configuration Management System

## Visão Geral

O **Defaults Configuration Management System** é um sistema automatizado para distribuir, atualizar e sincronizar arquivos padrão de configuração entre múltiplos projetos. Ele centraliza as definições de padrões de desenvolvimento (VS Code, Editor Config, Git Config, etc.) em um repositório único e facilita a propagação dessas configurações para todos os projetos que as utilizam.

## Objetivo Principal

Facilitar a **atualização centralizada de padrões de configuração** em múltiplos projetos, eliminando a necessidade de atualizar manualmente arquivos de configuração em cada repositório individual.

## Problemas Resolvidos

1. **Sincronização Manual**: Antes, era necessário copiar manualmente os arquivos de configuração entre projetos
2. **Inconsistência**: Diferentes projetos podiam ter configurações desatualizadas ou inconsistentes
3. **Manutenibilidade**: Alterações em padrões precisavam ser aplicadas em múltiplos locais
4. **Distribuição**: Não havia forma automática de disponibilizar as configurações atualizadas

## Componentes Principais

### 1. Script de Atualização (`update-github-config.sh`)

**Função**: Baixa e sincroniza os arquivos de configuração padrão do repositório central.

**O que faz**:
- Verifica se o diretório atual é um repositório Git (`.git` presente)
- Baixa o arquivo compactado do GitHub (tarball) do repositório `dev4up/defaults`
- Extrai os arquivos padrão
- Copia/sobrescreve os arquivos locais com as versões mais recentes

**Arquivos sincronizados**:
- `.vscode/` (configurações do VS Code)
- `settings.json` (configurações locais VS Code)
- `.editorconfig` (padrões de editor)
- `.gitignore` (regras de ignore global)
- `custom.d.ts` (definições TypeScript customizadas)

**Como usar**:
```bash
curl -fsSL https://raw.githubusercontent.com/dev4up/defaults/main/update-github-config.sh | bash
```

**Variáveis de ambiente opcionais**:
- `BRANCH`: Especifica o branch a baixar (padrão: `main`)
- `REPO_USER`: Username do GitHub (padrão: `dev4up`)
- `REPO_NAME`: Nome do repositório (padrão: `defaults`)

### 2. Workflow GitHub Actions (`.github/workflows/build-artifact.yml`)

**Função**: Automatizar a geração de artefatos sempre que os padrões mudam.

**O que faz**:
- Monitora alterações nos arquivos de configuração padrão
- Cria um arquivo compactado (tarball) com todos os arquivos
- Disponibiliza como artefato no GitHub Actions

**Gatilhos**:
- `push` em qualquer arquivo monitorado
- `workflow_dispatch` (execução manual)

**Arquivos monitorados**:
- `.github/workflows/build-artifact.yml`
- `.vscode/**`
- `settings.json`
- `.editorconfig`
- `.gitignore`
- `custom.d.ts`

**Artefato gerado**: `downloadable-files.tar.gz`

### 3. Arquivos de Configuração Padrão

- **`.vscode/settings.json`**: Configurações padrão do VS Code
- **`settings.json`**: Overrides locais de configurações
- **`.editorconfig`**: Padrões de edição (indentação, charset, etc.)
- **`.gitignore`**: Regras globais de ignore do Git
- **`custom.d.ts`**: Definições TypeScript customizadas

## Fluxo de Funcionamento

```
┌─────────────────────────────────────────────────────────┐
│ Dev4up/Defaults Repository (Repositório Central)        │
│ ├── .vscode/                                            │
│ ├── settings.json                                       │
│ ├── .editorconfig                                       │
│ ├── .gitignore                                          │
│ └── custom.d.ts                                         │
└─────────────────┬───────────────────────────────────────┘
                  │
                  ▼
        ┌─────────────────────┐
        │ Arquivo é alterado  │
        └──────────┬──────────┘
                   │
                   ▼
    ┌──────────────────────────────────┐
    │ GitHub Actions Workflow Dispara  │
    │ - Detecta alteração              │
    │ - Cria tarball                   │
    │ - Upload artifact                │
    └──────────────┬───────────────────┘
                   │
        ┌──────────┴──────────┐
        ▼                     ▼
  ┌──────────────┐    ┌──────────────────────┐
  │ Artifact do  │    │ Script disponível    │
  │ GitHub       │    │ via raw.githubusercontent│
  │ Actions      │    └──────────────────────┘
  └──────────────┘              │
                                │
                    ┌───────────▼────────────┐
                    │ Projeto do Usuário     │
                    │ $ curl ... | bash      │
                    │ - Verifica .git        │
                    │ - Baixa arquivos       │
                    │ - Sobrescreve config   │
                    │ - Sincroniza padrões   │
                    └────────────────────────┘
```

## Casos de Uso

### 1. Novo Projeto
Um novo projeto que precisa dos padrões:
```bash
cd meu-novo-projeto
git init
curl -fsSL https://raw.githubusercontent.com/dev4up/defaults/main/update-github-config.sh | bash
```

### 2. Atualização de Padrões
Quando os padrões centrais são alterados:
```bash
cd projeto-existente
# Os desenvolvedores rodam:
curl -fsSL https://raw.githubusercontent.com/dev4up/defaults/main/update-github-config.sh | bash
```

### 3. Sincronização em CI/CD
Integrar no pipeline para garantir que deployments usem padrões atualizados:
```yaml
- name: Sync Defaults
  run: curl -fsSL https://raw.githubusercontent.com/dev4up/defaults/main/update-github-config.sh | bash
```

## Arquitetura

```
dev4up/defaults (Repositório Central)
│
├── .vscode/
│   └── settings.json (Configurações VS Code padrão)
│
├── settings.json (Configurações adicionais)
├── .editorconfig (Padrões de editor universal)
├── .gitignore (Ignore rules padrão)
├── custom.d.ts (Tipos TypeScript padrão)
│
├── .github/
│   └── workflows/
│       └── build-artifact.yml (Automação)
│
├── update-github-config.sh (Script de sincronização)
├── README.md (Instruções de uso)
└── SPEC.md (Esta documentação)
```

## Vantagens

✅ **Centralizado**: Uma única fonte de verdade para configurações  
✅ **Automatizado**: GitHub Actions gera artefatos automaticamente  
✅ **Simples**: Um comando curl para sincronizar  
✅ **Flexível**: Suporta diferentes branches e repositórios  
✅ **Confiável**: Apenas sobrescreve se o arquivo existe  
✅ **Rastreável**: Histórico no Git e logs de atualização  

## Requisitos

- **Git**: Repositório Git no projeto (`.git` obrigatório)
- **Curl**: Para baixar o script e arquivo
- **Bash**: Shell compatível com bash 4+
- **Tar**: Para descompactar o arquivo
- **Conectividade**: Acesso ao GitHub (raw.githubusercontent.com)

## Fluxo de Desenvolvimento

```
1. Desenvolvedor faz alteração em dev4up/defaults
   └─> git push main

2. GitHub Actions detecta alteração
   └─> build-artifact.yml executa
       └─> Cria downloadable-files.tar.gz

3. Usuários rodam o script em seus projetos
   └─> curl ... | bash

4. Arquivos locais são atualizados
   └─> Padrões sincronizados
```

## Segurança

- ✓ Apenas sobrescreve arquivos esperados
- ✓ Valida arquivos antes de copiar
- ✓ Usa HTTPS para download
- ✓ Requer `.git` para executar (previne execução acidental)
- ✓ Remove temporários após uso
- ✓ Exibe erros claramente

## Manutenção

### Para Atualizar os Padrões
```bash
cd dev4up/defaults
# Edite os arquivos desejados
# Commit e push
git add .
git commit -m "Update configuration standards"
git push origin main
```

### Para Usar em um Novo Projeto
```bash
cd novo-projeto
git init
BRANCH=main curl -fsSL https://raw.githubusercontent.com/dev4up/defaults/main/update-github-config.sh | bash
```

### Para Sincronizar em Projeto Existente
```bash
cd projeto-existente
curl -fsSL https://raw.githubusercontent.com/dev4up/defaults/main/update-github-config.sh | bash
```

## Limitações e Considerações

- ⚠ O repositório deve ser **público** para acessar via HTTPS
- ⚠ Sobrescreve arquivos locais sem backup automático
- ⚠ Requer `.git` no diretório de execução
- ⚠ Não sincroniza arquivos que não existem no padrão
- ⚠ Requer conectividade com GitHub

## Próximas Melhorias Potenciais

- [ ] Backup automático dos arquivos antes de sobrescrever
- [ ] Suporte a diferentes configurações por branch
- [ ] Validação de checksum para integridade
- [ ] Instalação como alias no shell
- [ ] Suporte a repositórios privados com token
- [ ] CI/CD hook para sincronização automática

## Roadmap

**v1.0 (Atual)**
- Script básico de sincronização
- GitHub Actions automation
- Suporte a branch customizável

**v1.1 (Planejado)**
- Backup de arquivos antes de sobrescrever
- Validação de integridade

**v2.0 (Futuro)**
- Instalador global (npm, homebrew)
- Suporte a repositórios privados
- Dashboard web de gerenciamento
