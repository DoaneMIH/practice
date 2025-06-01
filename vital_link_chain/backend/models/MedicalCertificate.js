const mongoose = require('mongoose');

const certificateSchema = new mongoose.Schema({
  patientAddress: { type: String, required: true },
  doctorAddress: { type: String, required: true },
  content: { type: String, required: true },
  txHash: { type: String, required: true },
  issuedAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Certificate', certificateSchema);