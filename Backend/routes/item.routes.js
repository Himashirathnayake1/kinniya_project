// item.routes.js
const express = require('express');
const router = express.Router();
const itemController = require('../controllers/item.controller'); // Adjust the path as necessary
const multer = require('multer');
const path = require('path'); // Ensure path is imported
const fs = require('fs'); // Import fs for file system operations

// Configure multer for file uploads
const uploadDir = path.join(__dirname, '../uploads');
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true }); // Create the uploads directory if it doesn't exist
}

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir); // Set the destination to the uploads directory
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname)); // Save the file with a unique name
    },
});
const upload = multer({ storage: storage });

// Define routes
router.post('/items', upload.single('image'), itemController.registerItem);
router.get('/items', itemController.getAllItems);
module.exports = router;
