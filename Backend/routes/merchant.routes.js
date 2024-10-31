const express = require('express');
const MerchantModel = require('../models/merchant.model');
const MerchantController = require('../controllers/merchant.controller');
const authenticateToken = require('../middleware/auth');
const router = express.Router();

// Define the route for merchant registration
router.post('/register', MerchantController.registerMerchant);

// Define the route for merchant login
router.post('/login', MerchantController.loginMerchant);

// Route to get all merchants
router.get('/all', MerchantController.getMerchants);

// Route to find a merchant by email
router.get('/find', MerchantController.findMerchantByEmail);

// Profile retrieval route
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    const merchant = await MerchantModel.findById(req.user._id); // Assuming the user ID is stored in the JWT token
    if (!merchant) {
      return res.status(404).json({ message: 'Merchant not found' });
    }
    res.json(merchant);
  } catch (error) {
    console.error("Error fetching profile:", error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
