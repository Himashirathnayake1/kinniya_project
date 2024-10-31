const MerchantModel = require('../models/merchant.model');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const CustomResponse = require('../utils/custom.response');

// Register Merchant
exports.registerMerchant = async (req, res) => {
    try {
        const { business_name, owner_name, phone, address, email, password, product_description, product_category } = req.body;

        if (!business_name || !owner_name || !phone || !address || !email || !password || !product_description || !product_category) {
            return CustomResponse.badRequest(res, 'All fields are required');
        }

        const existingMerchant = await MerchantModel.findOne({ $or: [{ phone }, { email }] });
        if (existingMerchant) {
            return CustomResponse.badRequest(res, 'Phone or email already exists');
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newMerchant = new MerchantModel({
            business_name,
            owner_name,
            phone,
            address,
            email,
            password: hashedPassword,
            product_description,
            product_category,
        });

        const savedMerchant = await newMerchant.save();
        return CustomResponse.created(res, 'Merchant registered successfully', savedMerchant);

    } catch (error) {
        console.error(error);
        return CustomResponse.internalServerError(res, 'Registration failed. Try again later.');
    }
};

// Login Merchant
exports.loginMerchant = async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return CustomResponse.badRequest(res, 'Email and password are required.');
        }

        const merchant = await MerchantModel.findOne({ email });
        if (!merchant) {
            return CustomResponse.notFound(res, 'Merchant not found.');
        }

        const isMatch = await bcrypt.compare(password, merchant.password);
        if (!isMatch) {
            return CustomResponse.unauthorized(res, 'Invalid password.');
        }

        const token = jwt.sign({ id: merchant._id }, process.env.JWT_SECRET, { expiresIn: '1h' });
        return CustomResponse.success(res, 'Login successful.', { token });

    } catch (error) {
        console.error(error);
        return CustomResponse.internalServerError(res, 'An error occurred. Please try again.');
    }
};

// Get all Merchants
exports.getMerchants = async (req, res) => {
    try {
        const merchants = await MerchantModel.find();
        return CustomResponse.success(res, 'All merchants fetched successfully', merchants);
    } catch (error) {
        console.error(error);
        return CustomResponse.internalServerError(res, 'Failed to fetch merchants');
    }
};

// Find Merchant by Email
exports.findMerchantByEmail = async (req, res) => {
    const email = req.query.email;

    try {
        if (!email) {
            return CustomResponse.badRequest(res, 'Email not provided!');
        }

        const merchant = await MerchantModel.findOne({ email });
        if (merchant) {
            merchant.password = ''; // Hide password
            return CustomResponse.success(res, 'Merchant found successfully', merchant);
        } else {
            return CustomResponse.notFound(res, 'Merchant not found');
        }
    } catch (error) {
        console.error(error);
        return CustomResponse.internalServerError(res, 'Failed to fetch merchant');
    }
};
