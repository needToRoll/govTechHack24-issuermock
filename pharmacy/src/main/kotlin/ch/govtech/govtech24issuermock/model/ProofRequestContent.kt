package ch.govtech.govtech24issuermock.model

import com.fasterxml.jackson.annotation.JsonProperty
import jakarta.persistence.Embedded
import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.ManyToOne
import jakarta.persistence.OneToMany
import java.time.ZonedDateTime
import java.util.UUID

data class ProofRequestContent(
    @JsonProperty("date_from") var issuedFrom: ZonedDateTime?,
    @JsonProperty("date_to") val issuedTo: ZonedDateTime?,
    val type: String?,
    @JsonProperty("present_url") val presentationUrl: String
) {

    constructor() : this(null, null, null, "")
}

@Entity
data class ProofRequest(
    @Id var id: String,
    @Embedded var content: ProofRequestContent,
    @OneToMany var responses: MutableList<Medication>
) {
    constructor() : this(
        UUID.randomUUID().toString(),
        ProofRequestContent(null, null, null, ""),
        mutableListOf()
    ) {

    }
}

