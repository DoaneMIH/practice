const express = require('express');
const router = express.Router();
const MedicalCertificate = require('../models/MedicalCertificate');

// Save medical certificate with txHash
router.post('/', async (req, res) => {
    try {
        console.log('POST /api/certificates', req.body); // <-- Add this
        const { patientAddress, doctorAddress, content, txHash } = req.body;
        const cert = new MedicalCertificate({
            patientAddress,
            doctorAddress,
            content,
            txHash,
        });
        await cert.save();
        res.status(201).json(cert);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

router.get('/:patientAddress', async (req, res) => {
    try {
        const certs = await MedicalCertificate.find({ patientAddress: req.params.patientAddress }).sort({ issuedAt: -1 });
        res.json(certs);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;