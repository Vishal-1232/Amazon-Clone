const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth");
const admin = require("../middlewares/admin");
const Coupon = require("../models/coupon");
const { Product } = require("../models/product");
const User = require("../models/user");
const Order = require("../models/order");

// get all coupons
router.get("/api/v1/coupons",auth, async (req, res) => {
  try {
    const coupons = await Coupon.find();
    res.json(coupons);
  } catch (error) {
    res.status(500).json({ message: "Error fetching coupons", error });
  }
});

// Create a new coupon
router.post("/admin/api/v1/coupons",admin, async (req, res) => {
  try {
    const newCoupon = new Coupon(req.body);
    const savedCoupon = await newCoupon.save();
    res.status(201).json(savedCoupon);
  } catch (error) {
    res.status(400).json({ message: "Error creating coupon", error });
  }
});

// Get a specific coupon by ID
router.get("/admin/api/v1/coupons/:id", admin, async (req, res) => {
  try {
    const coupon = await Coupon.findById(req.params.id);
    if (!coupon) {
      return res.status(404).json({ message: "Coupon not found" });
    }
    res.json(coupon);
  } catch (error) {
    res.status(500).json({ message: "Error fetching coupon", error });
  }
});

// Update a coupon by ID
router.put("/admin/api/v1/coupons/:id", admin, async (req, res) => {
  try {
    const updatedCoupon = await Coupon.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    if (!updatedCoupon) {
      return res.status(404).json({ message: "Coupon not found" });
    }
    res.json(updatedCoupon);
  } catch (error) {
    res.status(400).json({ message: "Error updating coupon", error });
  }
});

// Delete a coupon by ID
router.delete("/admin/api/v1/coupons/:id", admin, async (req, res) => {
  try {
    const deletedCoupon = await Coupon.findByIdAndDelete(req.params.id);
    if (!deletedCoupon) {
      return res.status(404).json({ message: "Coupon not found" });
    }
    res.json({ message: "Coupon deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Error deleting coupon", error });
  }
});

// api to use a coupon
router.post("/api/v1/coupons/apply",auth, async (req, res) => {
  try {
    const { productId, couponCode} = req.body;
    const currentDate = new Date();

    const coupon = await Coupon.findOne({
      couponCode: couponCode.toUpperCase(),
    });
    const product = await Product.findById(productId);

    if (!coupon) {
      return res.status(404).json({ msg: "Coupon not found" });
    }
    if (!product) {
      return res.status(404).json({ msg: "Product not found" });
    }
    if (coupon.usageStatus === "inactive") {
      return res.status(400).json({ msg: "Coupon is not active" });
    }

    // Date validations
    if (currentDate < coupon.startDate) {
      return res.status(400).json({ msg: "Coupon is not yet valid" });
    }
    if (currentDate > coupon.endDate) {
      return res.status(400).json({ msg: "Coupon has expired" });
    }

    // Validate total usage limit
    const totalUsage = coupon.usageLimitPerUser.reduce(
      (total, usage) => total + usage.limitUsed,
      0
    );

    if (
      coupon.totalUsageLimit !== null &&
      totalUsage >= coupon.totalUsageLimit
    ) {
      return res.status(400).json({
        msg: "Total usage limit for this coupon has been reached",
      });
    }
    
    // Validate product eligibility
    if (coupon.eligibleProducts &&
      coupon.eligibleProducts.length > 0 &&
      !coupon.eligibleProducts.includes(productId)
    ) {
      return res
        .status(400)
        .json({ msg: "Product is not eligible for this coupon" });
    }
    
    // Validate category eligibility
    if (coupon.eligibleCategories &&
      coupon.eligibleCategories.length > 0 &&
      !coupon.eligibleCategories.includes(product.category._id)
    ) {
      return res
        .status(400)
        .json({ msg: "Product category is not eligible for this coupon" });
    }
  
    // Validate excluded products
    if (coupon.excludedProducts&&coupon.excludedProducts.includes(productId)) {
      return res
        .status(400)
        .json({ msg: "This product is excluded from the coupon" });
    }
    
    // Validate excluded categories
    if (coupon.excludedCategories && coupon.excludedCategories.includes(product.category._id)) {
      return res.status(400).json({
        msg: "This product's category is excluded from the coupon",
      });
    }

    // check for minimum purchase requirement
    if (product.price < coupon.minimumPurchaseRequirement) {
      return res.status(400).json({
        msg: `Product purchase amount should be greater than ${coupon.minimumPurchaseRequirement}`,
      });
    }

    // check user restrictions
    const userOrders = await Order.find({ userId: req.user });
    const userStatus = userOrders.length === 0 ? "new" : "existing";

    if (coupon.userRestrictions === "new" && userStatus !== "new") {
      return res
        .status(400)
        .json({ msg: "This coupon is only valid for new users only" });
    }
    if (coupon.userRestrictions === "existing" && userStatus !== "existing") {
      return res
        .status(400)
        .json({ msg: "This coupon is only valid for existing users" });
    }

    // apply coupon
    const userUsage = coupon.usageLimitPerUser.find(
      (usage) => usage.userId.toString() === req.user
    );

    if (userUsage) {
      // If the user has already used the coupon, increment the limitUsed
      if (userUsage.limitUsed >= coupon.perUserLimit) {
        return res.status(400).json({
          msg: `You have reached the usage limit for this coupon. Max allowed: ${coupon.perUserLimit}`,
        });
      }
      userUsage.limitUsed += 1;
    } else {
      // If the user hasn't used the coupon, add a new entry
      coupon.usageLimitPerUser.push({
        userId: req.user,
        limitUsed: 1,
      });
    }

    if(req.query.onlyCouponCheck){
      return res.status(200).json({ msg: `Coupon applied successfully, discount got: ${coupon.discountValue}`, coupon});
    }
    
    await coupon.save();
    res.status(200).json({ msg: "Coupon applied successfully", coupon });
  } catch (e) {
    console.log(e.message);
    res.status(500).json({ msg: "Error using coupon", err:e.message });
  }
});

module.exports = router;
