// models/Prescription.js
const mongoose = require('mongoose');

const PrescriptionSchema = new mongoose.Schema({
  patientAddress: { type: String, required: true },
  doctorAddress: { type: String, required: true },
  content: { type: String, required: true }, // The prescription string/content
  txHash: { type: String, required: true },  // The blockchain txHash
  issuedAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Prescription', PrescriptionSchema);