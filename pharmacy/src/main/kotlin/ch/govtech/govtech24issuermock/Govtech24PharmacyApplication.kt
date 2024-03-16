package ch.govtech.govtech24issuermock

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.web.servlet.config.annotation.EnableWebMvc

@SpringBootApplication
class Govtech24PharmacyApplication

fun main(args: Array<String>) {
    runApplication<Govtech24PharmacyApplication>(*args)
}
