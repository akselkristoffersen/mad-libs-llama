use actix_web::{middleware, web, App, Error, HttpRequest, HttpResponse, HttpServer};
use actix_web_actors::ws;

mod server;
use self::server::MyWebSocket;

/// WebSocket handshake and start `MyWebSocket` actor.
async fn echo_ws(req: HttpRequest, stream: web::Payload) -> Result<HttpResponse, Error> {
    ws::start(MyWebSocket::new(), &req, stream)
}

// the actor-based WebSocket examples REQUIRE `actix_web::main` for actor support
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    HttpServer::new(|| {
        App::new()
            .service(web::resource("/ws").route(web::get().to(echo_ws)))
            .wrap(middleware::Logger::default())
    })
    .workers(2)
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}