const mongoose = require("mongoose");
const ratingSchema = require("./rating");

const productSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  },
  description: {
    required: true,
    type: String,
    trim: true,
  },
  brand: {
    required: true,
    type: String,
    trim: true,
  },
  images: [
    {
      type: String,
      required: true,
    },
  ],
  quantity: {
    type: Number,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  ratings: [ratingSchema],
});

// Virtual field for stock status based on quantity
productSchema.virtual("stockStatus").get(function () {
  return this.quantity > 0 ? "In stock" : "Out of stock";
});

productSchema.set('toJSON', { getters: true, virtuals: true });

const Product = mongoose.model("Product", productSchema);
module.exports = { Product, productSchema };
