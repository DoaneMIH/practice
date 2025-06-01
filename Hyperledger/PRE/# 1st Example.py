# Pseudocode for PRE
from pyumbral import generate_kfrags, reencrypt, decrypt

# Patient encrypts data
encrypted_data = encrypt(patient_private_key, medical_record)

# Patient generates re-encryption key for the doctor
kfrags = generate_kfrags(patient_private_key, doctor_public_key)

# Proxy re-encrypts the data
reencrypted_data = reencrypt(kfrags, encrypted_data)

# Doctor decrypts the data
decrypted_data = decrypt(doctor_private_key, reencrypted_data)