from umbral import pre, keys, config

# Set up Umbral
config.set_default_curve()

# Generate keys for patient and doctor
patient_private_key = keys.UmbralPrivateKey.gen_key()
patient_public_key = patient_private_key.get_pubkey()

doctor_private_key = keys.UmbralPrivateKey.gen_key()
doctor_public_key = doctor_private_key.get_pubkey()

# Patient encrypts the medical record
plaintext = b"Patient's medical record"
ciphertext, capsule = pre.encrypt(patient_public_key, plaintext)

# Patient generates re-encryption key for the doctor
kfrags = pre.generate_kfrags(
    delegating_privkey=patient_private_key,
    receiving_pubkey=doctor_public_key,
    signer=patient_private_key,
    N=10,  # Number of fragments
    threshold=5,
)

# Proxy re-encrypts the ciphertext for the doctor
cfrag = pre.reencrypt(kfrags[0], capsule)

# Doctor decrypts the re-encrypted ciphertext
decrypted_data = pre.decrypt(
    ciphertext=ciphertext,
    capsule=capsule,
    cfrag=cfrag,
    decrypting_key=doctor_private_key,
)

print("Decrypted data:", decrypted_data.decode())