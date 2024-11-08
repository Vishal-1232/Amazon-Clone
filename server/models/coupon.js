const mongoose = require("mongoose");

const couponSchema = new mongoose.Schema(
  {
    couponCode: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      uppercase: true,
    },
    description: {
      type: String,
      required: true,
      trim: true,
    },
    discountType: {
      type: String,
      enum: ["percentage", "fixed"], // percentage or fixed discount
      required: true,
    },
    discountValue: {
      type: Number,
      required: true,
    },
    minimumPurchaseRequirement: {
      type: Number,
      required: true,
      default: 0, // No minimum by default
    },
    maximumDiscountLimit: {
      type: Number,
      default: null, // No limit by default
    },
    startDate: {
      type: Date,
      required: true,
    },
    endDate: {
      type: Date,
      required: true,
    },
    perUserLimit: {
      type: Number,
      required: true,
      default: 1, // Default limit for each user
    },
    usageLimitPerUser: [
      {
        userId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "User",
        },
        limitUsed: {
          type: Number,
          default: 1, // Initially when the user uses the coupon
        },
       // _id: false, // Disable _id for this subdocument
      },
    ],
    totalUsageLimit: {
      // The total number of times the coupon can be used across all users.
      type: Number,
      default: null, // Unlimited by default
    },
    eligibleProducts: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Product", // Assuming you have a Product model
      },
    ],
    excludedProducts: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Product", // Assuming you have a Product model
      },
    ],
    eligibleCategories: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Category", // Assuming you have a Category model
      },
    ],
    excludedCategories: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Category", // Assuming you have a Category model
      },
    ],
    userRestrictions: {
      type: String,
      enum: ["new", "existing", "all"], // e.g., restrict to new, existing users, or all users
      default: "all",
    },
    usageStatus: {
      type: String,
      enum: ["active", "inactive"],
      default: "active",
    },
    autoApply: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

const Coupon = mongoose.model("Coupon", couponSchema);
module.exports = Coupon;
