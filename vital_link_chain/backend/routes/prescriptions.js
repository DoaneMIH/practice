  const express = require('express');
  const router = express.Router();
  const Prescription = require('../models/Prescription');

  // Save a prescription with txHash
  router.post('/', async (req, res) => {
    try {
      const { patientAddress, doctorAddress, content, txHash } = req.body;
      if (!patientAddress || !doctorAddress || !content || !txHash) {
        return res.status(400).json({ message: 'Missing required fields' });
      }
      const prescription = new Prescription({
        patientAddress,
        doctorAddress,
        content,
        txHash: txHash.toLowerCase(), //   Ensure txHash is stored in lowercase
      });
      await prescription.save();
      res.status(201).json(prescription);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });

  router.get('/by-tx/:txHash', async (req, res) => {
    try {
        console.log('Received txHash:', req.params.txHash);
      const prescription = await Prescription.findOne({ txHash: new RegExp(`^${req.params.txHash}$`, 'i') });
      // const prescription = await Prescription.findOne({ txHash: req.params.txHash });
      if (!prescription) {
        return res.status(404).json({ message: 'Prescription not found' });
      }
      res.json(prescription);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });

  // Get all prescriptions for a patient
  router.get('/:patientAddress', async (req, res) => {
    try {
      console.log("Prescription 1 API hit for", req.params.patientAddress);
      const {patientAddress} = req.params
      
      const prescriptions = await Prescription.find({ patientAddress: req.params.patientAddress.toLowerCase() });
      console.log('Stored prescriptions:', prescriptions);
      res.json(prescriptions);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });

  // Find a prescription by content and return its txHash
  router.get('/txhash/by-content/:content', async (req, res) => {
    try {
      const content = req.params.content;
      const prescription = await Prescription.findOne({ content: content });
      if (!prescription) {
        return res.status(404).json({ message: 'Prescription not found' });
      }
      res.json({ txHash: prescription.txHash });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });

  router.get('/prescriptions/:patientAddress', async (req, res) => {
    console.log("Prescription API hit for", req.params.patientAddress);
    const { patientAddress } = req.params;

    try {
      const prescriptions = await Prescription.find({ patientAddress: patientAddress.toLowerCase() });
      res.json(prescriptions);
    } catch (err) {
      console.error(err);
      res.status(500).send('Error retrieving prescriptions');
    }
  });

  module.exports = router;