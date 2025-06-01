// const express = require('express');
// const mongoose = require('mongoose');
// const bcrypt = require('bcrypt');
// const jwt = require('jsonwebtoken');
// const User = require('./models/User'); // Ensure this path is correct
// const app = express();
// app.use(express.json());

// // Connect to MongoDB Atlas
// const uri = "mongodb+srv://doanemariehorlador:Daryl0712@cluster0.sxoqc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";
// mongoose.connect(uri)
//   .then(() => console.log("Connected to MongoDB Atlas"))
//   .catch(err => console.error("Failed to connect to MongoDB", err));

// // Signup API
// app.post('/api/signup', async (req, res) => {
//   const { name, email, password, role } = req.body;

//   try {
//     // Check if user already exists
//     const existingUser = await User.findOne({ email });
//     if (existingUser) {
//       return res.status(400).json({ message: 'User already exists' });
//     }

//     // Hash the password
//     const hashedPassword = await bcrypt.hash(password, 10);

//     // Create a new user
//     const user = new User({ name, email, password: hashedPassword, role });
//     await user.save();

//     res.status(201).json({ message: 'User created successfully' });
//   } catch (error) {
//     res.status(500).json({ message: 'Failed to create user', error });
//   }
// });

// // Login API
// app.post('/api/login', async (req, res) => {
//   const { email, password } = req.body;

//   try {
//     // Find the user by email
//     const user = await User.findOne({ email });
//     if (!user) {
//       return res.status(400).json({ message: 'Invalid email or password' });
//     }

//     // Compare passwords
//     const isPasswordValid = await bcrypt.compare(password, user.password);
//     if (!isPasswordValid) {
//       return res.status(400).json({ message: 'Invalid email or password' });
//     }

//     // Generate a JWT token
//     const token = jwt.sign({ userId: user._id, role: user.role }, 'YOUR_SECRET_KEY', { expiresIn: '1h' });

//     res.status(200).json({ token, role: user.role });
//   } catch (error) {
//     res.status(500).json({ message: 'Failed to login', error });
//   }
// });

// // app.listen(3000, () => {
// //   console.log('Server running on port 3000');
// // });

// app.listen(3000, '0.0.0.0', () => {
//     console.log('Server running on port 3000');
// });

// const cors = require("cors");
// app.use(cors());

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const User = require('./models/User');  // Import the User model
const bcrypt = require('bcryptjs'); //hasing the password


const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());


// MongoDB Connection (Replace with your MongoDB URI)
mongoose.connect('mongodb+srv://doanemariehorlador:Daryl0712@cluster0.sxoqc.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0', {
    // useNewUrlParser: true,
    // useUnifiedTopology: true
}).then(() => console.log("Connected to MongoDB"))
  .catch(err => console.log("MongoDB Connection Error:", err));


// app.post('/api/signup', (req, res) => {
//     console.log("Received signup request:", req.body);
//     res.status(200).json({ message: "Signup successful" });
// });


// Start the Server
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

// Signup Route with hashed password
app.post('/api/signup', async (req, res) => {
    try {
        const { name, email, password, role } = req.body;

        // Check if the user already exists
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ message: 'User already exists' });
        }

        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create a new user
        const newUser = new User({
            name,
            email,
            password: hashedPassword,
            role,
        });

        await newUser.save();
        res.status(201).json({ message: 'Signup successful' });
    } catch (err) {
        console.error('Error signing up user:', err);
        res.status(500).json({ message: 'Server error' });
    }
});

// Login Route with password comparison
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email });

        if (!user) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        // Compare the provided password with the hashed password
        const isMatch = await bcrypt.compare(password, user.password);

        if (isMatch) {
            res.status(200).json({ role: user.role });
        } else {
            res.status(401).json({ message: 'Invalid credentials' });
        }
    } catch (err) {
        console.error('Error logging in user:', err);
        res.status(500).json({ message: 'Server error' });
    }
});

// // Define Signup Route
// app.post('/api/signup', async (req, res) => {
//     try {
//         const { name, email, password, role } = req.body;

//         // Check if the user already exists
//         const existingUser = await User.findOne({ email });
//         if (existingUser) {
//             return res.status(400).json({ message: 'User already exists' });
//         }

//         // Create a new user
//         const newUser = new User({
//             name,
//             email,
//             password,  // In a real-world scenario, hash the password!
//             role,
//         });

//         await newUser.save();  // Save the user to the database
//         res.status(201).json({ message: 'Signup successful' });
//     } catch (err) {
//         console.error('Error signing up user:', err);
//         res.status(500).json({ message: 'Server error' });
//     }
// });

// // Define Login Route
// app.post('/api/login', async (req, res) => {
//     const { email, password } = req.body;

//     try {
//         // Find the user by email
//         const user = await User.findOne({ email });

//         if (!user) {
//             return res.status(401).json({ message: 'Invalid credentials' });
//         }

//         // Check if the password matches (in a real-world scenario, hash the password and compare)
//         if (user.password === password) {
//             // Return the user's role if authentication is successful
//             res.status(200).json({ role: user.role });
//         } else {
//             res.status(401).json({ message: 'Invalid credentials' });
//         }
//     } catch (err) {
//         console.error('Error logging in user:', err);
//         res.status(500).json({ message: 'Server error' });
//     }
// });

// Route to fetch all users
app.get('/api/users', async (req, res) => {
    try {
        // Fetch all users from the database
        const users = await User.find();  // Fetch users from the MongoDB database

        res.status(200).json(users);  // Send back the users in JSON format
    } catch (err) {
        console.error('Error fetching users:', err);
        res.status(500).json({ message: 'Server error' });
    }
});

// app.post('/api/signup', (req, res) => {
//     console.log("Received data:", req.body);
//     res.status(200).json({ message: "Signup successful" });
// });