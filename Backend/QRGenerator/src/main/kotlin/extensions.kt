import io.ktor.application.ApplicationCall
import io.ktor.content.OutgoingContent
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode
import io.ktor.response.defaultTextContentType
import io.ktor.response.respond

class extensions {
}

suspend fun ApplicationCall.respondBytes(bytes: ByteArray, contentType: ContentType? = null, status: HttpStatusCode? = null, configure: OutgoingContent.() -> Unit = {}) {
    val message = ByteContent(bytes, defaultTextContentType(contentType), status).apply(configure)
    return respond(message)
}