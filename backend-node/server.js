const express = require('express')
const cors = require('cors')
const app = express()

app.use(cors()) // agar bisa diakses dari frontend

app.get('/api/sales', (req, res) => {
  res.json({
    categories: ['Jan', 'Feb', 'Mar'],
    data: [120, 200, 150]
  })
})

app.listen(3001, () => {
  console.log('Server API running at http://localhost:3001')
})

// const express = require('express');
// const app = express();
// const port = 3000;

// // Route GET untuk '/'
// app.get('/', (req, res) => {
//   res.send('Halo dari route GET /');
// });

// app.listen(port, () => {
//   console.log(`Server berjalan di http://localhost:${port}`);
// });