const express = require('express');
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const {Product} = require("../models/product");


// /api/products?category=Essentials -----> req.query.category

// /api/amazon?theme=dark -----> req.query.theme

// /api/products:category=Essentials -----> req.params.category

// api to get product by category 

productRouter.get("/api/v1/products",auth,async (req,res)=>{
    try{
        const {category,brand,sort,select} = req.query;
        const queryObject = {};
        
        if(category){
            const categories = category.split(",");
            queryObject.category = { $in: categories };
        }
        if(brand){
            queryObject.brand = brand;
        }
        let apiData = Product.find(queryObject);
        if(sort){
            let sortFix = sort.replaceAll(","," ");
            apiData = apiData.sort(sortFix);
        }
        if(select){
            let selectFix = select.replaceAll(","," ");
            console.log(selectFix);
            apiData = apiData.select(selectFix); 
        }

        // applying pagination
        let page = Number(req.query.page) || 1;
        let limit = Number(req.query.limit) || 5;
        let skip = (page-1)*limit;
        apiData = apiData.skip(skip).limit(limit);
        //---------------------------------------
        const products = await apiData;
        
        res.json(products);
    }catch(e){
        console.log(e);
        
        res.status(500).json({error:e.message});
    }
});

// api to search product
productRouter.get("/api/products/search/:name",auth,async (req,res)=>{
    try{
        const products = await Product.find({name: {$regex: req.params.name, $options: "i"}});
        res.json(products);
    }catch(e){
        res.status(500).json({error:e.message});
    }
})

// api to rate a product
productRouter.post("/api/rate-product",auth,async (req,res)=>{
    try{
        const {id,rating} = req.body;
        let product = await Product.findById(id);
        for(let i = 0; i < product.ratings.length; i++){
            if(product.ratings[i].userId == req.user){
                product.ratings.splice(i,1); // deletes that index element
                break;
            }
        }

        const ratingSchema = {
            userId:req.user,
            rating,
        }

        product.ratings.push(ratingSchema);
        product = await product.save();
        res.json(product);

    }catch (e){
        res.status(500).json({error:e.message});
    }
})

// api to fetch deal of the day
productRouter.get("/api/deal-of-day", auth, async(req,res)=>{
    try{
        let products = await Product.find();
        products = products.sort((a,b)=>{
            let aSum = 0;
            let bSum = 0;
            
            for(let i = 0; i < a.ratings.length; i++){
                aSum += a.ratings[i].rating;
            }
            for(let i = 0; i < b.ratings.length; i++){
                bSum += b.ratings[i].rating;
            }

            return aSum < bSum ?1:-1; // Sort in Descend Order 
        });

        res.json(products[0]);
    }catch(e){
        res.status(500).json({error:e.message});
    }
})

module.exports = productRouter;