import io.ktor.content.OutgoingContent
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode

class ByteContent(val bytes: ByteArray, override val contentType: ContentType, override val status: HttpStatusCode? = null): OutgoingContent.ByteArrayContent(){
    override val contentLength: Long
        get() = bytes.size.toLong()

    override fun bytes(): ByteArray = bytes

    override fun toString() = "ByteContent[$contentType] ${bytes.size} bytes"
}