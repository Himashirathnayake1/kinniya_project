// item.model.js
const mongoose = require('mongoose');

const itemSchema = new mongoose.Schema({
    name: { type: String, required: true },
    description: { type: String, maxLength: 280 },
    category: { type: String, required: true },
    quantity: { type: Number, default: 0 },
    price: { type: Number, required: true },
    discount: { type: Number, default: 0 },
    totalAmount: { type: Number, required: true },
    address: { type: String },
    brand: { type: String },
    image: { type: String }, // URL or path to the image
}, { timestamps: true });

const Item = mongoose.model('Item', itemSchema, 'products'); // Specifies the collection name "products"

module.exports = Item;
