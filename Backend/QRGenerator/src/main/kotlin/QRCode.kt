import com.vasco.image.exception.ImageGeneratorSDKException;
import com.vasco.image.generator.ImageGeneratorSDK;
import java.io.ByteArrayOutputStream
import javax.imageio.ImageIO

class QRCode {
    companion object {
        // Number of pixels per square in Cronto Image
        private const val CRONTO_IMAGE_SQUARE_SIZE = 6

        // If the image is to be printed on paper
        private const val CRONTO_IMAGE_ON_PAPER = true

        fun genQRCode(hexStr: String): ByteArray? {
            //sample hexStr "5465737420537472696e6720666f7220496d61676547656e657261746f72"

            try {
                println("Generating Cronto image...")

                val crontoImg = ImageGeneratorSDK.generateDynamicCrontoImage(CRONTO_IMAGE_SQUARE_SIZE,
                        hexStr, CRONTO_IMAGE_ON_PAPER)

                val baos = ByteArrayOutputStream()
                ImageIO.write(crontoImg, "png", baos)
                val bytes = baos.toByteArray()

                println("Cronto image created.")

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