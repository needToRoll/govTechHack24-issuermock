package ch.govtech.govtech24issuermock

import ch.govtech.govtech24issuermock.model.Medication
import ch.govtech.govtech24issuermock.service.MockDataService
import ch.govtech.govtech24issuermock.service.ProofRequestService
import ch.govtech.govtech24issuermock.service.QrImageService
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping


@Controller
@RequestMapping("/pharmacy")
class PharmacyController(val mockDataService: MockDataService, val proofRequestService: ProofRequestService, val qrImageService: QrImageService) {

    @GetMapping()
    fun showWelcomePage(model: Model): Any {
        var createNewProofRequest = proofRequestService.createNewProofRequest()
        model.addAttribute("imageBase64", qrImageService.generateQrForPrContent(createNewProofRequest.id))
        model.addAttribute("prId", createNewProofRequest.id)
        return "welcome"
    }

    @GetMapping("/medications")
    fun showMedications(model: Model): Any {
        // Assuming you have a method to fetch JSON data and parse it into a List<Medication>
        val medications = fetchMedicationsFromJson()
        model.addAttribute("medications", medications)
        model.addAttribute("person", mockDataService.getInsuranceCard())
        return "medication"
    }
    @GetMapping("/medications/{id}")
    fun showMedications(model: Model, @PathVariable id: String): Any {
        // Assuming you have a method to fetch JSON data and parse it into a List<Medication>
        val medications = proofRequestService.getById(id).responses
        model.addAttribute("medications", medications)
        model.addAttribute("person", mockDataService.getInsuranceCard())
        return "medication"
    }
    // Method to fetch JSON data and parse it into a List<Medication>
    private fun fetchMedicationsFromJson(): List<Medication> {
        return mockDataService.getAllCredentials().filter { it.type == "Medication" }.map { it as Medication }.toList()
    }
}

