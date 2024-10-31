const mongoose = require('mongoose');

// Define the schema for merchant registration
const MerchantSchema = new mongoose.Schema({
    business_name: { type: String, required: true },
    owner_name: { type: String, required: true },
    phone: { type: String, required: true, unique: true },
    address: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    product_description: { type: String, required: true },
    product_category: { type: String, required: true },
}, { timestamps: true });

// Check if the model is already compiled to prevent OverwriteModelError
const MerchantModel = mongoose.models.Merchant || mongoose.model('Merchant', MerchantSchema);

module.exports = MerchantModel;
