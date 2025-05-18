// app.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();

// const templateRoutes = require('./routes/templateRoutes');
// const mailRoutes = require('./routes/mailRoutes');
const authRoute = require('./route/auth.route')
const mailRoutes = require('./route/mail.route')

const templetRoutes = require('./route/templet.route')
const userRoutes = require('./route/user.route')




const app = express();

app.use(cors());
app.use(express.json());

// app.use('/api/templates', templateRoutes);
app.use('/',authRoute );
app.use('/',mailRoutes );
app.use('/',userRoutes );
app.use('/',templetRoutes);



const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
