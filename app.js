/**
 * Insecure App - Exemplo educacional
 * Versão com bibliotecas vulneráveis/maliciosas no package.json
 *
 * Esta aplicação é INTENCIONALMENTE vulnerável.
 * NÃO use em produção, apenas em ambiente isolado (VM / Docker).
 */

const express = require('express');
const bodyParser = require('body-parser');
const escapeHtml = require('escape-html');
const { exec } = require('child_process');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

/* ---------- Credenciais embutidas (vulnerável) ---------- */
const USER = 'admin';
const PASSWORD = 'PKB09#4cFwq$!';
const API_KEY = 'APIKEY_987654321';

/* ---------- Banco de dados simulado ---------- */
const dbUsers = [
  { id: 1, username: 'alice', email: 'alice@example.com' },
  { id: 2, username: 'bob', email: 'bob@example.com' },
  { id: 3, username: 'charlie', email: 'charlie@example.com' },
];

/* ---------- Rotas vulneráveis ---------- */

// 1. Login inseguro
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  if (username === USER && password === PASSWORD) {
    return res.send({ ok: true, msg: 'Autenticado (fictício).' });
  }
  res.status(401).send({ ok: false, msg: 'Credenciais inválidas.' });
});

// 2. SQL Injection (simulada)
app.get('/search-users', (req, res) => {
  const q = req.query.q || '';
  const vulnerableSql = `SELECT * FROM users WHERE username LIKE '%${q}%' OR email LIKE '%${q}%'`;
  const results = dbUsers.filter(u =>
    u.username.includes(q) || u.email.includes(q)
  );
  res.send({ vulnerableSql, results });
});

// 3. XSS
app.get('/greet', (req, res) => {
  const name = req.query.name || 'visitante';
  const unsafeHtml = `
    <html>
      <body>
        <h1>Olá, ${name}!</h1>
        <p>Exemplo vulnerável a XSS.</p>
      </body>
    </html>`;
  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  res.send(unsafeHtml);
});

// 4. RCE (simulada)
app.post('/run-command', (req, res) => {
  const { cmd } = req.body || {};
  res.send({ note: 'Simulação: este comando NÃO foi executado.', wouldRun: cmd });
});

// 5. Uso de API key hardcoded
app.get('/pay', (req, res) => {
  res.send({ apiKey: API_KEY });
});

/* ---------- Rota segura para comparação ---------- */
app.get('/greet-safe', (req, res) => {
  const name = escapeHtml(req.query.name || 'visitante');
  res.send(`<h1>Olá, ${name}!</h1><p>Versão segura.</p>`);
});

/* ---------- Start ---------- */
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Insecure App rodando em http://localhost:${PORT}`);
});

