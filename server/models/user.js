const mongoose = require("mongoose");
const {productSchema} = require("../models/product");

const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;

        return value.match(re);
      },
      message: "Plese enter valid email address",
    },
  },
  password: {
    required: true,
    type: String,
    validate:{
        validator:(value)=>{
            return value.length > 6;
        },
        message:"Plese enter a long password",
    }
  },
  address: {
    type: String,
    default: "",
  },
  type: {
    type: String,
    default: "user",
  },
  cart:[
    {
      product: productSchema,
      quantity: {
        type : Number,
        required: true,
      },
      isWishlisted:{
        type: Boolean,
        default: false,
      }
    }
  ],
});

const User = mongoose.model("User",userSchema);
module.exports = User;
