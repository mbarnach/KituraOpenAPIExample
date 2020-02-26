import Foundation
import KituraContracts
import Kitura
import Credentials
import CredentialsJWT
import SwiftJWT

// The version middleware allows to filter resquest based on a version number in the header.
public final class CustomHeaderMiddleware: TypeSafeMiddleware {

    public let value: String

    public init(value: String) {
        self.value = value
    }

    public static func handle(request: RouterRequest,
                              response: RouterResponse,
                              completion: @escaping (CustomHeaderMiddleware?, RequestError?) -> Void) {
        guard let value = request.headers["x-api-version"]
            else {
                completion(nil, RequestError.badRequest)
                return
        }
        completion(CustomHeaderMiddleware(value: value), nil)
    }

    public static var parameters:[OpenAPI.Parameter]? {
        get {
            [
                OpenAPI.Parameter(
                    name: "x-api-value", in: .header,
                    content: (key: "x-api-value", entry: OpenAPI.Media(schema: OpenAPI.Schema(plain: "string"))),
                    description: "Ensure a custom value is set in the header of the request",
                    required: true,
                    deprecated: false,
                    allowEmptyValue: false)
            ]
        }
    }
}

public final class MyJWT: TypeSafeMiddleware {

    public static func handle(request: RouterRequest,
                              response: RouterResponse,
                              completion: @escaping (MyJWT?, RequestError?) -> Void) {
        completion(MyJWT(), nil)
    }
    public static var securitySchemes: OpenAPI.SecuritySchemes? { 
        get {
            [
                "jwt": OpenAPI.SecurityScheme(scheme: .bearer,
                                              bearerFormat: "JWT",
                                              description: "JSON Web Token authentication through HTTP protocol.")
            ]
        }
    }
}


extension CheckoutSession {
    public static var parameters:[OpenAPI.Parameter]? {
        get {
            [
                OpenAPI.Parameter(
                    name: "cart value", in: .header,
                    content: (key: "cart value", entry: OpenAPI.Media(schema: OpenAPI.Schema(plain: "string"))),
                    description: "Ensure a custom value is set in the header of the request",
                    required: true,
                    deprecated: false,
                    allowEmptyValue: false)
            ]
        }
    }

    public static var securitySchemes: OpenAPI.SecuritySchemes? { 
        get {
            [
                "dummy": OpenAPI.SecurityScheme(scheme: .bearer,
                                              bearerFormat: "Custom",
                                              description: "Custom Token authentication through HTTP protocol.")
            ]
        }
    }
}