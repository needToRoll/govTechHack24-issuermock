package ch.govtech.govtech24issuermock

import ch.govtech.govtech24issuermock.model.Credential
import ch.govtech.govtech24issuermock.model.Diagnosis
import ch.govtech.govtech24issuermock.model.HealthInsuranceCard
import ch.govtech.govtech24issuermock.service.MockDataService
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("api/v1/mock/vc")
class WebController(
    val mockDataService: MockDataService
) {

    @GetMapping("/insurance")
    fun insurance(): HealthInsuranceCard {
        return mockDataService.getInsuranceCard()
    }

    @GetMapping("/medical")
    fun test(): List<Credential> {
        return mockDataService.getAllCredentials()
    }
    @GetMapping("/new-diagnosis")
    fun newDiagnosis(): Diagnosis {
        return mockDataService.getCredentialOfTypeDiagnosis()
    }

}