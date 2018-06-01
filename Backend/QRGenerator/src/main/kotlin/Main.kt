import io.ktor.application.*
import io.ktor.http.*
import io.ktor.response.*
import io.ktor.routing.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.content.*
import java.io.ByteArrayOutputStream
import java.math.BigInteger
import java.util.*


public class Main {
    companion object {
        @JvmStatic fun main(args: Array<String>) {
//            while (true) {
//                System.out.println(Date())
//                OTP.genOTP()
//                Thread.sleep(60000)
//            }

            val server = embeddedServer(Netty, port = 8080) {
                routing {
                    get("/") {
                        val content = readFileFromResource("index.html")
                        call.respondText(content, ContentType.Text.Html)
                    }

                    static("/images") {
                        resources("images")
                    }

                    get("/main") {
                        val content = readFileFromResource("main.html")
                        call.respondText(content, ContentType.Text.Html)
                    }

                    get("/qrcode") {
                        val params = call.request.queryParameters
                        val str = "Hello, " + params.get("user") + ".\nyou are authenticated"
                        val hexStr = String.format("%040x", BigInteger(1, str.toByteArray(Charsets.UTF_8)))

                        val qrCode = QRCode.genQRCode(hexStr)

                        if (qrCode == null) {
                            call.respondText("error, please try again.", ContentType.Text.Plain)
                        } else {
                            call.respondBytes(qrCode, ContentType.Image.PNG)
                        }
                    }
                }
            }

            server.start(wait = true)
        }

        fun readFileFromResource(filename: String): String {
            val inputStream = javaClass.getResourceAsStream(filename)

            val result = ByteArrayOutputStream()
            val buffer = ByteArray(1024)
            var length: Int
            while (true) {
                length = inputStream.read(buffer)

                if (length == -1) break

                result.write(buffer, 0, length)
            }

            val str = result.toString("UTF-8")
            return str
        }
    }
}