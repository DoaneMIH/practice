const express = require('express');
const router = express.Router();
const MedicalApplication = require('../models/MedicalApplication');

// Save a new medical application
router.post('/', async (req, res) => {
  try {
    const { patientAddress, fileName, ipfsHash, formData } = req.body;
    if (!patientAddress || !fileName || !ipfsHash || !formData) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const newApp = new MedicalApplication({
      patientAddress,
      fileName,
      ipfsHash,
      formData, 
    });

    await newApp.save();
    res.status(201).json({ message: '✅ Medical application saved!', record: newApp });
  } catch (err) {
    console.error("❌ Error saving medical application:", err);
    res.status(500).json({ error: err.message || 'Failed to store medical application' });
  }
});


// router.post('/api/medical-applications', async (req, res) => {
//   try {
//     const { patientAddress, fileName, ipfsHash, formData } = req.body;
//     if (!patientAddress || !fileName || !ipfsHash || !formData) {
//       return res.status(400).json({ message: 'Missing required fields' });
//     }

//     const newApp = new MedicalApplication({
//       patientAddress,
//       fileName,
//       ipfsHash,
//       formData, 
//     });

//     await newApp.save();
//     res.status(201).json({ message: '✅ Medical application saved!', record: newApp });
//   } catch (err) {
//     console.error("❌ Error saving medical application:", err);
//     res.status(500).json({ error: err.message || 'Failed to store medical application' });
//   }
// });

// Get all medical applications for a patient
router.get('/:patientAddress', async (req, res) => {
  try {
    const apps = await MedicalApplication.find({
      patientAddress: req.params.patientAddress.toLowerCase(),
    });
    res.json(apps);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;