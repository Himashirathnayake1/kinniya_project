const jwt = require('jsonwebtoken');
const MerchantModel = require('../models/merchant.model');

const authenticateToken = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Unauthorized, token missing' });
  }

  const token = authHeader.split(' ')[1];
  jwt.verify(token, process.env.JWT_SECRET, async (err, decoded) => {
    if (err) {
      console.error('Token verification failed:', err);
      return res.status(403).json({ message: 'Forbidden, invalid token' });
    }

    try {
      const user = await MerchantModel.findById(decoded.id).select('-password');
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }
      req.user = user;
      next();
    } catch (error) {
      console.error("Authentication error:", error);
      res.status(500).json({ message: 'Server error' });
    }
  });
};

module.exports = authenticateToken;
