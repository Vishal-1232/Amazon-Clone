const express = require('express');
const bcryptjs = require('bcryptjs');
const jwt = require('jsonwebtoken');

const authRouter = express.Router();
const User = require("../models/user");
const auth = require('../middlewares/auth');

// authRouter.get('/user',(req,res)=>{
//     res.json({msg:"Vishal"});    
// })

// sign-in api 
authRouter.post("/api/signup",async(req,res)=>{
    try{
        const {name,email,password} = req.body; // getting user data
    const existingUser = await User.findOne({email});
    if(existingUser){
        return res.status(400).json({
            msg:"User with same e-mail already exists"
        });
    }

    // encrypting password
    const hashedPassword = await bcryptjs.hash(password,8);
    // post that data into database
    let user = new User({
        email,
        password : hashedPassword,
        name,
    })
    user = await user.save();
    res.json(user);
    // return that data into user
    }catch(e){
        res.status(500).json({error:e.message});
    }
})

// sign-up api
authRouter.post("/api/signin", async(req,res)=>{
    try{
        const {email,password} = req.body;
        // check email exists in DB
        const currUser = await User.findOne({email});
        if(!currUser){
            return res.status(400).json({msg:"User with this e-mail does not exists!!"});
        }
        // check user entered correct password
        const matched = await bcryptjs.compare(password,currUser.password);
        if(!matched){
            return res.status(400).json({msg:"Incorrect password!!"});
        }
       const token = jwt.sign({id: currUser._id}, "passwordKey");
       res.json({token,...currUser._doc}); // ... --> object destructuring i.e we are sending user doc and inside that user doc we are sharing token
    }catch(e){
        res.status(500).json({error:e.message});
    }
})

// api to check jwt token is valid or not
authRouter.post("/tokenIsValid",async(req,res)=>{
    try{
        // check if token is present 
        const token = req.header('x-auth-token');
        if(!token) return res.json(false);
        // to check if token is verified
        const verified = jwt.verify(token,"passwordKey");
        if(!verified) return res.json(false);
        // to check if any user associates with that token
        const user = await User.findById(verified.id);
        if(!user) return res.json(false);
        return res.json(true);
    }catch(e){
        res.status(500).json({error:e.message});
    }
})

// get user data
authRouter.get("/", auth, async(req,res)=>{
    const user = await User.findById(req.user);
    res.json({...user._doc, token: req.token});
})

module.exports = authRouter; // Now authRouter is not a private variable, it can be used anywhere in the application