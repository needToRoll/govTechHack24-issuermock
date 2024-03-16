package ch.govtech.govtech24issuermock.model

import java.time.LocalDate


data class HealthInsuranceCard(
    val cardNumber: String,
    val holderName: String,
    val dateOfBirth: LocalDate,
    val gender: Gender,
    val insuranceCompany: String
    ) {
        enum class Gender {
            Male, Female, Other
        }
}