import io.ktor.application.*
import io.ktor.http.*
import io.ktor.response.*
import io.ktor.routing.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import com.vasco.image.exception.ImageGeneratorSDKException;
import com.vasco.image.generator.ImageGeneratorSDK;
import javax.imageio.ImageIO
import java.io.ByteArrayOutputStream

public class Main {
    companion object {
        // Number of pixels per square in Cronto Image
        private val CRONTO_IMAGE_SQUARE_SIZE = 6

        // If the image is to be printed on paper
        private val CRONTO_IMAGE_ON_PAPER = true

        // Test string to generate the Cronto Image
        private val CRONTO_TEST_STRING = "5465737420537472696e6720666f7220496d61676547656e657261746f72"

        @JvmStatic fun main(args: Array<String>) {
            val server = embeddedServer(Netty, port = 8080) {
                routing {
                    get("/") {
                        val qrCode = genQRCode()

                        if (qrCode == null) {
                            call.respondText("error, please try again.", ContentType.Text.Plain)
                        } else {
                            call.respondBytes(qrCode, ContentType.Image.PNG)
                        }
                    }
                    get("/demo") {
                        call.respondText("HELLO WORLD!")
                    }
                }
            }
            server.start(wait = true)
        }

        private fun genQRCode(): ByteArray? {
            try {
                println("Generating Cronto image...")

                // Generate Cronto image
                val crontoImg = ImageGeneratorSDK.generateDynamicCrontoImage(CRONTO_IMAGE_SQUARE_SIZE,
                        CRONTO_TEST_STRING, CRONTO_IMAGE_ON_PAPER)

                val baos = ByteArrayOutputStream()
                ImageIO.write(crontoImg, "png", baos)
                val bytes = baos.toByteArray()

                return bytes
            } catch (e: ImageGeneratorSDKException) {
                System.err.println("Cronto image generation failed: s " + e.errorMessage)
                return null
            } catch (e: Exception) {
                System.err.println("Cronto image generation failed: r " + e.message)
                return null
            }

        }
    }
}