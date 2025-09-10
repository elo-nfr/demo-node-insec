#  Insecure App (Node.js)

Aplicação **intencionalmente insegura** criada para estudo de vulnerabilidades comuns.

## Vulnerabilidades no código
- Credenciais/API keys hardcoded
- SQL Injection (simulada)
- Cross-Site Scripting (XSS)
- Remote Code Execution (simulada)

## Vulnerabilidades em dependências
- **Lodash 4.17.4** – Prototype Pollution
- **jQuery 1.6.4** – XSS antigo
- **Minimist 0.0.8** – Prototype Pollution
- **event-stream 3.3.6** – caso famoso de supply-chain attack
- **eslint-scope 3.7.2** – incidente de takeover
- **npmcli-login 0.0.10** – pacote malicioso

##  Aviso
- Não usar em produção.
- Rodar apenas em ambiente isolado.
- Dependências inseguras/maliciosas estão incluídas **apenas para análise estática** (scanners SCA).
