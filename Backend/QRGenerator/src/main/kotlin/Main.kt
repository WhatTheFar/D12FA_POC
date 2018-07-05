import io.ktor.application.*
import io.ktor.http.*
import io.ktor.response.*
import io.ktor.routing.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.content.*
import java.io.ByteArrayOutputStream
import java.math.BigInteger


public class Main {
    companion object {
        @JvmStatic fun main(args: Array<String>) {
//            while (true) {
//                System.out.println(Date())
//                OTP.genOTP()
//                Thread.sleep(10_000)
//            }

            val activationResponse = OTP.genActivation()

            activationResponse ?: return

            val staticVector: ByteArray = activationResponse.staticVector
            val dynamicVector: ByteArray = activationResponse.dynamicVector

            val staticHexStr: String = String.format("%040x", BigInteger(1, staticVector))
            val dynamicHexStr: String = String.format("%040x", BigInteger(1, dynamicVector))
            println(staticHexStr.length)
            println(dynamicHexStr.length)


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

                    get("/activate") {
                        val content = readFileFromResource("activate.html")
                        call.respondText(content, ContentType.Text.Html)
                    }

                    get("/activatecode") {

                        val qrCode = QRCode.genQRCode("${staticHexStr}FFFFFFFFFF$dynamicHexStr")

                        if (qrCode == null) {
                            call.respondText("error, please try again.", ContentType.Text.Plain)
                        } else {
                            call.respondBytes(qrCode, ContentType.Image.PNG)
                        }
                    }

                    get("/login") {
                        val otp = call.request.queryParameters["otp"]
                        if (otp != null) {
                            if (otp == OTP.genOTP()) {
                                val content = readFileFromResource("success.html")
                                call.respondText(content, ContentType.Text.Html)
                            } else {
                                val content = readFileFromResource("fail.html")
                                call.respondText(content, ContentType.Text.Html)
                            }
                            return@get
                        }
                        val content = readFileFromResource("login.html")
                        call.respondText(content, ContentType.Text.Html)
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