const mongoose = require('mongoose');

const MedicalApplicationSchema = new mongoose.Schema({
  patientAddress: { type: String, required: true, lowercase: true },
  fileName: { type: String, required: true },
  ipfsHash: { type: String, required: true },
  uploadedAt: { type: Date, default: Date.now },
  formData: { type: Object, required: true },
  // Add more fields as needed (e.g., status, metadata)
});

module.exports = mongoose.model('MedicalApplication', MedicalApplicationSchema);