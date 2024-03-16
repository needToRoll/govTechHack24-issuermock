package ch.govtech.govtech24issuermock.service

import ch.govtech.govtech24issuermock.model.ProofRequestContent
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.google.zxing.BarcodeFormat
import com.google.zxing.MultiFormatWriter
import com.google.zxing.WriterException
import com.google.zxing.client.j2se.MatrixToImageWriter
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import java.io.ByteArrayOutputStream
import java.util.*


@Service
class QrImageService(@Value("\${present-endpoint-base-url}") var url: String,) {
    companion object {
        val mapper: ObjectMapper = jacksonObjectMapper().registerModule(JavaTimeModule())

    }
    fun generateQRCodeBase64(text: String, width: Int, height: Int): String? {
        return try {
            val bitMatrix = MultiFormatWriter().encode(text, BarcodeFormat.QR_CODE, width, height)
            val baos = ByteArrayOutputStream()
            MatrixToImageWriter.writeToStream(bitMatrix, "PNG", baos)
            val bytes = baos.toByteArray()
            Base64.getEncoder().encodeToString(bytes)
        } catch (e: WriterException) {
            println("Could not generate QR code: ${e.message}")
            null
        }
    }

    fun generateQrForPrContent(id: String): String {
        val toEndode = url + "/api/pharmacy/pr/" + id
        return generateQRCodeBase64(toEndode, 300, 300)!!
    }
}