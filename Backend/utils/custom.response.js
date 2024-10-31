class CustomResponse {
    constructor(status, message, data = null) {
        this.status = status;
        this.message = message;
        this.data = data;
    }

    static success(res, message = 'Request was successful', data = null) {
        return res.status(200).json({ success: true, message, data });
    }

    static created(res, message = 'Resource created successfully', data = null) {
        return res.status(201).json({ success: true, message, data });
    }

    static notFound(res, message = 'Resource not found') {
        return res.status(404).json({ success: false, message });
    }

    static badRequest(res, message = 'Bad request') {
        return res.status(400).json({ success: false, message });
    }

    static unauthorized(res, message = 'Unauthorized access') {
        return res.status(401).json({ success: false, message });
    }

    static internalServerError(res, message = 'Internal server error') {
        return res.status(500).json({ success: false, message });
    }
}

module.exports = CustomResponse;
