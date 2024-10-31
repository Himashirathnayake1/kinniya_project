// item.controller.js
const Item = require('../models/item.model');

// Controller to handle item registration
exports.registerItem = async (req, res) => {
    try {
        const { name, description, category, price, quantity, discount, address, brand } = req.body;

        // Validate required fields
        if (!name || !category || !price) {
            return res.status(400).json({ message: 'Name, category, and price are required fields.' });
        }

        // Create new item
        const newItem = new Item({
            name,
            description,
            category,
            price,
            quantity,
            discount,
            address,
            brand,
            image: req.file ? req.file.path : null, // Save the path of the uploaded image
            totalAmount: price * quantity - (price * quantity * discount / 100), // Calculate total amount after discount
        });

        // Save the item to the database
        await newItem.save();
        res.status(201).json({ message: 'Item registered successfully', item: newItem });
    } catch (error) {
        console.error('Error:', error); 
        res.status(500).json({ message: 'Error registering item', error: error.message });
    }
};
// Controller to retrieve all items
// item.controller.js
exports.getAllItems = async (req, res) => {
    try {
        const items = await Item.find(); // Retrieve all items from the database

        // Calculate final price and add it to the items
        const itemsWithFinalPrice = items.map(item => {
            const finalPrice = item.price - (item.price * item.discount / 100);
            return {
                ...item._doc, // Spread the item document
                finalPrice, // Add final price
            };
        });

        res.status(200).json(itemsWithFinalPrice); // Return the list of items
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ message: 'Error retrieving items', error: error.message });
    }
};
