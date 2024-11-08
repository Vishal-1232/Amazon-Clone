const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth");
const admin = require("../middlewares/admin");
const Category = require("../models/category");

// get all categories
router.get("/api/v1/categories", auth, async (req, res) => {
  try {
    const category = await Category.find();
    res.json(category);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Create a new category
router.post("/admin/api/v1/categories",admin, async (req, res) => {
  try {
    const { name, image } = req.body;
    if (!name || !image) {
      return res.status(400).json({ message: "Name and image are required" });
    }

    let newCategory = new Category({ image, name });
    newCategory = await newCategory.save();
    res
      .status(201)
      .json({ message: "Category created successfully", data: newCategory });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Get a specific category by ID
router.get("/admin/api/v1/categories/:id", admin, async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    if (!category) {
      return res.status(404).json({ message: "Category not found" });
    }
    res.status(200).json(category);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Update a category by ID
router.put("/admin/api/v1/categories/:id", admin, async (req, res) => {
  try {
    const { name, image } = req.body;
    const category = await Category.findByIdAndUpdate(
      req.params.id,
      { name, image },
      { new: true, runValidators: true }
    );

    if (!category) {
      return res.status(404).json({ message: "Category not found" });
    }

    res
      .status(200)
      .json({ message: "Category updated successfully", data: category });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Delete a category by ID
router.delete("/admin/api/v1/categories/:id", admin, async (req, res) => {
  try {
    const category = await Category.findByIdAndDelete(req.params.id);
    if (!category) {
      return res.status(404).json({ message: "Category not found" });
    }

    res.status(200).json({ message: "Category deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

module.exports = router;
