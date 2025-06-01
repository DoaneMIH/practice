// Pseudocode for chaincode
func CreateRecord(patientID string, recordData string) error {
    // Store record on the ledger
}

func RequestAccess(doctorID string, patientID string) error {
    // Request access to patient's record
}

func ApproveAccess(patientID string, doctorID string) error {
    // Approve access to the record
}

func AddDoctorNote(patientID string, doctorID string, note string) error {
    // Add a note to the patient's record
}