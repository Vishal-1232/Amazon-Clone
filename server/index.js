console.log("Hello, World")
// import from packages
const express = require('express');
const mongoose = require('mongoose');

// import from other files
const authRouter = require('./routes/auth');
const adminRouter = require('./routes/admin');
const productRouter = require('./routes/product');
const userRouter = require('./routes/user');


// initialization
const app = express(); // initialize
const PORT = 3000;
const DB = "mongodb+srv://Vishal:VishalDB@cluster0.esv5nyf.mongodb.net/?retryWrites=true&w=majority";

// middleware
app.use(express.json()); // It parses the incoming payload request into JSON Format
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

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

// // get api
// app.get("/",(req,res)=>{
//     res.json({Name:"Vishal Kaushik"});
// })

app.get("/hello-world",(req,res)=>{
    //res.send("HEllo World");
    res.json({hi:"Hello World"});
})
