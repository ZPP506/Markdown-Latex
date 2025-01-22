//
//  ViewController.swift
//  ZPPDemo
//
//  Created by 张朋朋 on 1/21/25.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    let markdown = """
        \n要解决这道数学题，我们需要进行简单的乘法运算。以下是详细的步骤：\n\n### 简要步骤：\n1. **识别问题**：题目要求我们计算 \\( 23 \\times 4 \\)。\n2. **进行乘法运算**：\n   - 首先，将4乘以23的个位数3，得到 \\( 4 \\times 3 = 12 \\)。\n   - 然后，将4乘以23的十位数2，得到 \\( 4 \\times 2 = 8 \\)。\n   - 最后，将两个结果相加，即 \\( 12 + 80 = 92 \\)。\n\n### 最终答案：\n\\[ 23 \\times 4 = 92 \\]\n\n所以，\\( 23 \\times 4 \\) 的结果是 92。","answer":"所以，\\( 23 \\times 4 \\) 的结果是 92。
    """
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    @IBAction func readString(_ sender: Any) {
        let escapedMarkdown = self.escape(markdown: markdown) ?? ""
        load(escapedMarkdown:escapedMarkdown)
    }
    @IBAction func readFile(_ sender: Any) {
        
        let path = Bundle.main.path(forResource: "sample", ofType: "md")!
        let url = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: url)
        let str = String(data: data!, encoding: .utf8) ?? ""
        let escapedMarkdown = self.escapeFile(markdown: str) ?? ""
        load(escapedMarkdown:escapedMarkdown)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
  
    }
    @objc public func load(escapedMarkdown: String?, enableImage: Bool = true) {
      guard let escapedMarkdown = escapedMarkdown else { return }
        let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html")
      if let url = htmlURL {
        let templateRequest = URLRequest(url: url)

               let imageOption = enableImage ? "true" : "false"
               let script = "window.showMarkdown('\(escapedMarkdown)', \(imageOption));"
               let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

               let controller = WKUserContentController()
               controller.addUserScript(userScript)

               let configuration = WKWebViewConfiguration()
               configuration.userContentController = controller


          let wv = WKWebView(frame: self.view.bounds, configuration: configuration)
         
          view.addSubview(wv)
        wv.load(templateRequest)
      } else {
        // TODO: raise error
      }
    }
    func escape(markdown: String) -> String? {
        let escaped = markdown
            .replacingOccurrences(of: "\\", with: "\\\\\\\\")  // 转义反斜杠
            .replacingOccurrences(of: "'", with: "\\'")    // 转义单引号
            .replacingOccurrences(of: "\n", with: "\\n")   // 转义换行符
            .replacingOccurrences(of: "\r", with: "\\r")   // 转义回车符
        return escaped
    }
    func escapeFile(markdown: String) -> String? {
        let escaped = markdown
            .replacingOccurrences(of: "\\", with: "\\\\")  // 转义反斜杠
            .replacingOccurrences(of: "'", with: "\\'")    // 转义单引号
            .replacingOccurrences(of: "\n", with: "\\n")   // 转义换行符
            .replacingOccurrences(of: "\r", with: "\\r")   // 转义回车符
        return escaped
    }
}

