

import Foundation

class Downloader {
    class func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        //print("url a descargar \(url.absoluteString)")
        //print("url a guardar en \(localUrl.absoluteString)")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request =  URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if /*let tempLocalUrl = tempLocalUrl,*/ error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    //print("tep local url \(tempLocalUrl!.absoluteString)")
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl!, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
//
            } else {
                print("Failure: %@", error!.localizedDescription);
            }
        }
        task.resume()
    }
}
