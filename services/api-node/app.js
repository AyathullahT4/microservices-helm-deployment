const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/health', (_req, res) => res.json({ ok: true, service: 'node' }));

app.listen(port, () => {
  // keep logs minimal; looks production-ish
  console.log(`api-node listening on ${port}`);
});
