import KituraContracts
import Credentials
import CredentialsJWT
import SwiftJWT
import Kitura
import KituraSession

func initializeCodableRoutes(app: App) {
    // Book
    let bookRouter = app.router.route("/book")
    bookRouter.post("/book", handler: app.postHandler)
    bookRouter.post("/book", handler: app.postOneHandler)
    bookRouter.get("/book", handler: app.getAllHandler)
    bookRouter.get("/book", handler: app.getOneHandler)
    bookRouter.patch("/book", handler: app.patchHandler)
    bookRouter.put("/book", handler: app.putHandler)
    bookRouter.delete("/book", handler: app.deleteHandler)
    
    // Session
    let cartRouter = app.router.route("/cart", tags: [OpenAPI.Tag(name: "Cart routes")])
    cartRouter.post("/session", handler: app.postSessionHandler)
    cartRouter.get("/session", handler: app.getSessionHandler)
}

extension App {
    func postSessionHandler(session: CheckoutSession, book: Book, completion: (Book?, RequestError?) -> Void) {
        session.books.append(book)
        session.save()
        completion(book, nil)
    }
    func getSessionHandler(session: CheckoutSession, completion: ([Book]?, RequestError?) -> Void) -> Void {
        completion(session.books, nil)
    }
}

extension App {
    static var codableStore = [Book]()

    func postHandler(jwt: MyJWT, header: CustomHeaderMiddleware, book: Book, completion: (Book?, RequestError?) -> Void) {
        execute {
            App.codableStore.append(book)
        }
        completion(book, nil)
    }

    func postOneHandler(jwt: MyJWT, header: CustomHeaderMiddleware, book: Book, completion: (Int?, Book?, RequestError?) -> Void) {
        execute {
            App.codableStore.append(book)
        }
        completion(book.id, book, nil)
    }

    func getAllHandler(jwt: MyJWT, header: CustomHeaderMiddleware, completion: ([Book]?, RequestError?) -> Void) {
        execute {
            completion(App.codableStore, nil)
        }
    }
    func getOneHandler(jwt: MyJWT, header: CustomHeaderMiddleware, id: Int, completion: (Book?, RequestError?) -> Void) {
        execute {
            guard id < App.codableStore.count, id >= 0 else {
                return completion(nil, .notFound)
            }
            completion(App.codableStore[id], nil)
        }
    }

    func patchHandler(jwt: MyJWT, header: CustomHeaderMiddleware, id: Int, book: Book, completion: (Book?, RequestError?) -> Void) {
        execute {
            guard id < App.codableStore.count, id >= 0 else {
                return completion(nil, .notFound)
            }
            App.codableStore[id] = book
        }
        completion(book, nil)
    }

    func putHandler(jwt: MyJWT, header: CustomHeaderMiddleware, id: Int, book: Book, completion: (Book?, RequestError?) -> Void) {
        execute {
            guard id < App.codableStore.count, id >= 0 else {
                return completion(nil, .notFound)
            }
            App.codableStore[id] = book
        }
        completion(book, nil)
    }

    func deleteHandler(jwt: MyJWT, header: CustomHeaderMiddleware, id: Int, completion: (RequestError?) -> Void) {
        execute {
            guard id < App.codableStore.count, id >= 0 else {
                return completion(.notFound)
            }
            App.codableStore.remove(at: id)
            completion(nil)

        }
    }
}