const express = require("express");
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const User = require("../models/user");
const userRouter = express.Router();
const Order = require("../models/order");
const mongoose = require("mongoose");

userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 });
    } else {
      let isProductFound = false;
      let alreadyInWishlist = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
          alreadyInWishlist = user.cart[i].isWishlisted;
          break;
        }
      }

      if (isProductFound) {
        if (alreadyInWishlist) {
          return res
            .status(400)
            .json({
              msg: "Product is present in your wishlist, so cant be added into your cart!!",
            });
        }

        let producttt = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 });
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        if (user.cart[i].quantity == 1) {
          user.cart.splice(i, 1);
        } else {
          user.cart[i].quantity -= 1;
        }
      }
    }

    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// save user address
userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { address } = req.body;
    let user = await User.findById(req.user);
    user.address = address;
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// order product
userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, address } = req.body;
    let products = [];

    for (let i = 0; i < cart.length; i++) {
      if(cart[i].isWishlisted){
        continue;
      }

      let product = await Product.findById(cart[i].product._id);
      if (product.quantity >= cart[i].quantity) {
        product.quantity -= cart[i].quantity;
        products.push({ product, quantity: cart[i].quantity });
        await product.save();
      } else {
        return res
          .status(400)
          .json({ msg: `${product.name} is out of stock!` });
      }
    }

    if(products.length==0){
      return res.status(400).json({msg: 'Please add items in your cart!!'});
    }

    let user = await User.findById(req.user);
    user.cart = [];
    user = await user.save();

    let order = new Order({
      products,
      totalPrice,
      address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user });
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// api to wishlist a product
userRouter.post("/api/v1/add-to-wishlist", auth, async (req, res) => {
  try {
    const { id } = req.body;
    if (!mongoose.Types.ObjectId.isValid(String(id))) {
      return res.status(400).json({ error: "Invalid Product Id" });
    }
    const product = await Product.findById(id);
    if (!product) {
      return res.status(400).json({ msg: "Product not found!!" });
    }

    let user = await User.findById(req.user);
    let isCartProduct = false;
    let alreadyWishlisted = false;
    let i;
    for (i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        isCartProduct = true;
        alreadyWishlisted = user.cart[i].isWishlisted;
        break;
      }
    }
    if (!isCartProduct) {
      return res
        .status(400)
        .json({ error: "Product does not belongs to cart!!" });
    }

    if (alreadyWishlisted) {
      return res.status(400).json({ msg: "Product is already in wishlist" });
    }
    console.log(i);
    user.cart[i].isWishlisted = true;
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
// api to remove product from wishlist
userRouter.delete(
  "/api/v1/remove-from-wishlist/:id",
  auth,
  async (req, res) => {
    try {
      const { id } = req.params;
      if (!mongoose.Types.ObjectId.isValid(String(id))) {
        return res.status(400).json({ error: "Invalid Product Id" });
      }
      const product = await Product.findById(id);
      if (!product) {
        return res.status(400).json({ msg: "Product not found!!" });
      }
      let user = await User.findById(req.user);

      let isWishlistedProduct = false;
      let i;
      for (i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isWishlistedProduct = user.cart[i].isWishlisted;
          break;
        }
      }

      if (!isWishlistedProduct) {
        return res.status(400).json({ error: "Product is not in wishlist!!" });
      }
      user.cart[i].isWishlisted = false;
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);
module.exports = userRouter;
