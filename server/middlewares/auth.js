const jwt = require("jsonwebtoken");

const auth = async(req,res,next)=>{
    try{
        const token = req.header("x-auth-token");
        if(!token) return res.status(401).json({msg:"No auth token, access denied"});

        const verified = jwt.verify(token,"passwordKey");
        if(!verified) return res.status(401).json({msg:"Token verification failed, authorization denied"});

        req.user = verified.id; // adding user in request like we have headers,body 
        req.token = token; // adding token in request
        next(); // used to run callback of route which uses this middleware
    }catch(e){
        res.status(500).json({error:e.message})
    }
}

module.exports = auth;