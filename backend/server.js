const express    = require('express');
const cors       = require('cors');
const bodyParser = require('body-parser');
const routes     = require('./routes/index');

const app  = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(express.json());
app.use('/api', routes);
app.get('/', (_, res) => res.send('🚂 RailBook Pro API is running'));

app.listen(PORT, () => {
  console.log(`\n🚀 Server  → http://localhost:${PORT}`);
  console.log(`📡 API     → http://localhost:${PORT}/api\n`);
});
