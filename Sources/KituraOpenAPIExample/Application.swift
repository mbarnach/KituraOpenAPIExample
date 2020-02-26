import Foundation
import Kitura
import LoggerAPI
import KituraContracts
import KituraOpenAPI
import Dispatch

public class App {
    let apiDocument: OpenAPI.Document
    let router: Router

    public init() throws {
        let servers = [
            OpenAPI.Server(url: "https://example.com", description: "The production API server"),
            OpenAPI.Server(url: "https://privateapi.example.com", description: "The development API server")
        ]
        let info = OpenAPI.Info(title: "OpenAPI example server",
                                version: "1.0.0",
                                description: "Show the OpenAPI capabilities with Kitura.")
        apiDocument = OpenAPI.Document(info: info, servers: servers, tags: [])
        router = Router(apiDocument: apiDocument)
    }

    func postInit() throws {
        // Hack to switch between OpenAPI 3.0 and 2.0
        router.get("doc/openapi") { request, response, next in
            self.router.openAPIVersion = .openapi3_0
            response.send(json: ["openapi": "\(self.router.openAPIVersion)"])
        }
        router.get("doc/swagger") { request, response, next in
            self.router.openAPIVersion = .swagger2_0
            response.send(json: ["openapi": "\(self.router.openAPIVersion)"])
        }

        initializeCodableRoutes(app: self)

        // OpenAPI
        let config = KituraOpenAPIConfig(apiPath: "/openapi", swaggerUIPath: "/openapi/ui")
        KituraOpenAPI.addEndpoints(to: router, with: config)
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }

    let workerQueue = DispatchQueue(label: "worker")
    func execute(_ block: (() -> Void)) {
        workerQueue.sync {
            block()
        }
    }
}