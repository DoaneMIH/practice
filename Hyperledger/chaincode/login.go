// package main

// import (
// 	"context"
// 	"crypto/rand"
// 	"encoding/hex"
// 	"encoding/json"
// 	"log"
// 	"net/http"
// 	"time"

// 	"github.com/dgrijalva/jwt-go"
// 	"github.com/gorilla/mux"
// 	"go.mongodb.org/mongo-driver/bson"
// 	"go.mongodb.org/mongo-driver/mongo"
// 	"go.mongodb.org/mongo-driver/mongo/options"
// 	"golang.org/x/crypto/bcrypt"
// )

// type User struct {
// 	ID             string `json:"id" bson:"id"`
// 	Name           string `json:"name" bson:"name"`
// 	Email          string `json:"email" bson:"email"`
// 	Password       string `json:"password" bson:"password"`
// 	Role           string `json:"role" bson:"role"`
// 	Specialization string `json:"specialization,omitempty" bson:"specialization,omitempty"`
// }

// type Claims struct {
// 	Email string `json:"email"`
// 	Role  string `json:"role"`
// 	jwt.StandardClaims
// }

// var jwtKey = []byte("your_secret_key")
// var client *mongo.Client

// func connectDB() {
// 	var err error
// 	client, err = mongo.Connect(context.TODO(), options.Client().ApplyURI("your_mongodb_connection_string"))
// 	if err != nil {
// 		log.Fatal("Error connecting to MongoDB:", err)
// 	}
// 	err = client.Ping(context.TODO(), nil)
// 	if err != nil {
// 		log.Fatal("Failed to ping MongoDB:", err)
// 	}
// 	log.Println("✅ Successfully connected to MongoDB Atlas!")
// }

// func generateID() string {
// 	bytes := make([]byte, 16)
// 	rand.Read(bytes)
// 	return hex.EncodeToString(bytes)
// }

// func hashPassword(password string) (string, error) {
// 	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
// 	return string(hashedPassword), err
// }

// func checkEmailExists(email string) bool {
// 	collection := client.Database("medical_records").Collection("users")
// 	var existingUser User
// 	err := collection.FindOne(context.TODO(), bson.M{"email": email}).Decode(&existingUser)
// 	return err == nil
// }

// func createUser(w http.ResponseWriter, r *http.Request, role string) {
// 	var user User
// 	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
// 		http.Error(w, "Invalid input", http.StatusBadRequest)
// 		return
// 	}

// 	if checkEmailExists(user.Email) {
// 		http.Error(w, "Email already registered", http.StatusConflict)
// 		return
// 	}

// 	user.ID = generateID()
// 	user.Role = role

// 	hashedPassword, err := hashPassword(user.Password)
// 	if err != nil {
// 		http.Error(w, "Error hashing password", http.StatusInternalServerError)
// 		return
// 	}
// 	user.Password = hashedPassword

// 	collection := client.Database("medical_records").Collection("users")
// 	_, err = collection.InsertOne(context.TODO(), user)
// 	if err != nil {
// 		http.Error(w, "Error saving user", http.StatusInternalServerError)
// 		return
// 	}

// 	w.WriteHeader(http.StatusCreated)
// 	json.NewEncoder(w).Encode(map[string]string{"message": "User created successfully"})
// }

// func signupPatient(w http.ResponseWriter, r *http.Request) {
// 	createUser(w, r, "patient")
// }

// func signupDoctor(w http.ResponseWriter, r *http.Request) {
// 	createUser(w, r, "doctor")
// }

// func loginUser(w http.ResponseWriter, r *http.Request) {
// 	var loginData struct {
// 		Email    string `json:"email"`
// 		Password string `json:"password"`
// 	}

// 	if err := json.NewDecoder(r.Body).Decode(&loginData); err != nil {
// 		http.Error(w, "Invalid input", http.StatusBadRequest)
// 		return
// 	}

// 	collection := client.Database("medical_records").Collection("users")
// 	var user User
// 	err := collection.FindOne(context.TODO(), bson.M{"email": loginData.Email}).Decode(&user)
// 	if err != nil {
// 		http.Error(w, "Invalid email or password", http.StatusUnauthorized)
// 		return
// 	}

// 	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(loginData.Password))
// 	if err != nil {
// 		http.Error(w, "Invalid email or password", http.StatusUnauthorized)
// 		return
// 	}

// 	expirationTime := time.Now().Add(24 * time.Hour)
// 	claims := &Claims{
// 		Email: user.Email,
// 		Role:  user.Role,
// 		StandardClaims: jwt.StandardClaims{
// 			ExpiresAt: expirationTime.Unix(),
// 		},
// 	}

// 	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
// 	tokenString, err := token.SignedString(jwtKey)
// 	if err != nil {
// 		http.Error(w, "Error generating token", http.StatusInternalServerError)
// 		return
// 	}

// 	json.NewEncoder(w).Encode(map[string]string{"token": tokenString})
// }

// func main() {
// 	connectDB()
// 	r := mux.NewRouter()
// 	r.HandleFunc("/signup/patient", signupPatient).Methods("POST")
// 	r.HandleFunc("/signup/doctor", signupDoctor).Methods("POST")
// 	r.HandleFunc("/login", loginUser).Methods("POST")
// 	log.Fatal(http.ListenAndServe(":8080", r))
// }
// 