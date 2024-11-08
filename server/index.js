// import from packages
const express = require('express');
const mongoose = require('mongoose');
const cors = require("cors");
    // For logging
// const morgan = require('morgan')
// const fs = require("fs");
// const path = require('path');

// import from other files
const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');
const categoryRouter = require("./routes/category");
const couponRouter = require("./routes/coupon");


// initialization
const app = express(); // initialize
const PORT = 8000;
const DB = "mongodb+srv://Vishal:VishalDB@cluster0.esv5nyf.mongodb.net/?retryWrites=true&w=majority";

// create a write stream (in append mode)
//var accessLogStream = fs.createWriteStream(path.join(__dirname, 'access.log'), { flags: 'a' })

// middleware
app.use(express.json()); // It parses the incoming payload request into JSON Format
app.use(cors());
//app.use(morgan('tiny',{stream:accessLogStream})); // For Logger
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
app.use(categoryRouter);
app.use(couponRouter);

// connections
mongoose.connect(DB).then(()=>{
    console.log("Connection Successful");
}).catch((e)=>{
    console.log(e);
})


// creating an api
app.listen(PORT,"0.0.0.0",()=>{
    console.log(`connected at port : ${PORT}`);
});
