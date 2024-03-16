package ch.govtech.govtech24issuermock.model

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface ProofRepository: JpaRepository<ProofRequest, String>

@Repository
interface MedicationRepository: JpaRepository<Medication, String>
