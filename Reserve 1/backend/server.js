const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();


const app = express();
const PORT = process.env.PORT || 3000;

const Web3 = require('web3').default;
const contractABI = require('../build/contracts/HealthSystem.json'); // Adjust path as needed
const contractAddress = '0x9Ac4CB5B3182FF54EdcF82a52027bc1F5c16fe33'; // change to your contract address
const web3 = new Web3('http://127.0.0.1:7545');
const healthSystemContract = new web3.eth.Contract(contractABI.abi, contractAddress);

// Middleware
app.use(cors());
app.use(express.json());

// MongoDB Connection
mongoose.connect('mongodb://localhost:27017/medicalApp', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log("✅ Connected to MongoDB"))
  .catch(err => console.error("❌ MongoDB Connection Error:", err));

// Mongoose Schema
const RecordSchema = new mongoose.Schema({
  patientAddress: { type: String, required: true }, // Patient's public key
  fileName: { type: String, required: true },
  ipfsHash: { type: String, required: true },
  doctorPublicKey: { type: String, required: true }, // Doctor's public key
  uploadedAt: { type: Date, default: Date.now },
});

const Record = mongoose.model('Record', RecordSchema);

// Routes
app.get('/', (req, res) => {
  res.send('IPFS Record API is running');
});

// Add a new record for a specific patient
app.post('/api/records', async (req, res) => {
  try {
    const { patientAddress, fileName, ipfsHash, doctorPublicKey } = req.body;

    // Validate required fields
    if (!patientAddress || !fileName || !ipfsHash || !doctorPublicKey) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const newRecord = new Record({
      patientAddress: patientAddress.toLowerCase(), // Normalize patientAddress
      fileName,
      ipfsHash,
      doctorPublicKey: doctorPublicKey.toLowerCase(), // Normalize doctorPublicKey
    });

    await newRecord.save();
    res.status(201).json({ message: 'Record saved successfully!', record: newRecord });
  } catch (err) {
    console.error("❌ Error saving record:", err);
    res.status(500).json({ message: 'Failed to save record' });
  }
});

// Get all records for a specific patient
app.get('/api/records/:patientAddress', async (req, res) => {
  try {
    const { patientAddress } = req.params;

    // Validate patientAddress
    if (!patientAddress) {
      return res.status(400).json({ message: 'Patient address is required' });
    }

    const records = await Record.find({
      patientAddress: { $regex: new RegExp(`^${patientAddress}$`, 'i') }, // Case-insensitive match
    });

    res.status(200).json(records);
  } catch (err) {
    console.error("❌ Error fetching records:", err);
    res.status(500).json({ message: 'Failed to fetch records' });
  }
});

// Get all records (for debugging or admin purposes)
app.get('/api/records', async (req, res) => {
  try {
    const records = await Record.find();
    res.status(200).json(records);
  } catch (err) {
    console.error("❌ Error fetching all records:", err);
    res.status(500).json({ message: 'Failed to fetch records' });
  }
});

//Doctor's endpoint to get all patients associated with their public key
// app.get('/api/doctor/records/:doctorPublicKey', async (req, res) => {
//   try {
//     const { doctorPublicKey } = req.params;

//     // Fetch all records where the doctorPublicKey matches (case-insensitive)
//     const records = await Record.find({ doctorPublicKey: doctorPublicKey.toLowerCase() });

//     if (records.length === 0) {
//       return res.status(404).json({ message: 'No records found for this doctor' });
//     }

//     // Group records by patientAddress
//     const patientRecords = records.reduce((acc, record) => {
//       const { patientAddress, fileName, ipfsHash, uploadedAt } = record;
//       if (!acc[patientAddress]) {
//         acc[patientAddress] = [];
//       }
//       acc[patientAddress].push({ fileName, ipfsHash, uploadedAt });
//       return acc;
//     }, {});

//     res.status(200).json(patientRecords);
//   } catch (err) {
//     console.error("❌ Error fetching records:", err);
//     res.status(500).json({ message: 'Failed to fetch records' });
//   }
// });

app.get('/api/doctor/records/:doctorPublicKey', async (req, res) => {
  try {
    const { doctorPublicKey } = req.params;

    // Fetch the list of patients who have granted access to the doctor from the Solidity contract
    // const [patients] = await healthSystemContract.methods
    //   .getPatientsForDoctor(doctorPublicKey)
    //   .call();
    const result = await healthSystemContract.methods
      .getPatientsForDoctor(doctorPublicKey)
      .call();

    const patients = result['0'];
    const patientNames = result['1'];
    const timestamps = result['2'];
    // console.log("Patients from Solidity:", patients);

    if (patients.length === 0) {
      return res.status(200).json({}); // Return an empty object if no patients have granted access
    }

    // Fetch records from MongoDB for the patients who still have access
    const records = await Record.find({
      // doctorPublicKey: doctorPublicKey.toLowerCase(),
      patientAddress: { $in: patients.map((p) => p.toLowerCase()) }, // Filter by patients with access
    });

    console.log("Records from MongoDB:", records);

    // Group records by patientAddress
    const patientRecords = records.reduce((acc, record) => {
      const { patientAddress, fileName, ipfsHash, uploadedAt } = record;
      if (!acc[patientAddress]) {
        acc[patientAddress] = [];
      }
      acc[patientAddress].push({ fileName, ipfsHash, uploadedAt });
      return acc;
    }, {});

    res.status(200).json(patientRecords);
  } catch (err) {
    console.error('❌ Error fetching records:', err);
    res.status(500).json({ message: 'Failed to fetch records' });
  }
});

app.get('/api/doctor/patients/:doctorAddress', async (req, res) => {
  try {
    const { doctorAddress } = req.params;

    // Call the Solidity function to get patients for the doctor
    const [patients, patientNames, timestamps] = await healthSystemContract.methods
      .getPatientsForDoctor(doctorAddress)
      .call();

    if (patients.length === 0) {
      return res.status(200).json([]); // Return an empty array if no patients are found
    }

    // Format the response
    const result = patients.map((patient, index) => ({
      address: patient,
      name: patientNames[index],
      timestamp: new Date(timestamps[index] * 1000).toISOString(),
    }));

    res.status(200).json(result);
  } catch (err) {
    console.error('Error fetching patients:', err);
    res.status(500).json({ message: 'Failed to fetch patients' });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});