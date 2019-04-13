import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    //outlets
    
    @IBOutlet weak var urlTextView: UITextField!
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlData : String!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Web Info"
        
        // Make the webview to display the URL
        let url = URL(string: urlData)
        let request = URLRequest(url: url!)
        
        webView.load(request)
        
        webView.navigationDelegate = self
        
        urlTextView.text = urlData
        

        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
