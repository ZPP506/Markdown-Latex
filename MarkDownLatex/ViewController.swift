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
# 示例表格

| 姓名   | 年龄 | 职业   |
|--------|------|--------|
| 张三   | 25   | 工程师 |
| 李四   | 30   | 设计师 |
| 王五   | 22   | 学生   |

    # 最大化支持 LaTeX 示例
    ## 分数与分式
    行内分数：\\( \\frac{1}{2} \\)，块级分数：
    \\[ \\frac{x + y}{x - y} \\]

    ## 积分与求和
    行内积分：\\( \\int_{a}^{b} x^2 dx \\)，块级积分：
    \\[ \\sum_{i=1}^n i = \\frac{n(n+1)}{2} \\]

    ## 矩阵
    \\[ \\begin{pmatrix} 1 & 2 \\\\ 3 & 4 \\end{pmatrix} \\]

    ## 多行公式
    \\[ \\begin{aligned} f(x) &= (x + 1)(x - 1) \\\\ &= x^2 - 1 \\end{aligned} \\]

    ## 化学式（需加载 mhchem 扩展）
    \\[ \\ce{H2O} \\quad \\ce{CO2 + H2O -> H2CO3} \\]

    ## 物理符号（需加载 physics 扩展）
    \\[ \\grad \\cdot \\vec{E} = \\frac{\\rho}{\\epsilon_0} \\]

    ## 自定义宏（需加载 newcommand 扩展）
    \\[ \\newcommand{\\abs}[1]{\\left|#1\\right|} \\abs{\\frac{x}{y}} \\]


"""
    private lazy var wv: WKWebView = {
        let v = WKWebView(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size))
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.insertSubview(wv, at: 0)
        let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html")
        if let url = htmlURL {
            let templateRequest = URLRequest(url: url)
            wv.load(templateRequest)
        }
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
        //        guard let escapedMarkdown = escapedMarkdown else { return }
        //        let script = "renderMarkdown('\(escapedMarkdown)');"
        //        wv.evaluateJavaScript(script)
        socket()
    }
    func socket() {
        let array = markdown.components(separatedBy: "\n")
        for (index, item) in array.enumerated() {
            let escapedMarkdown = self.escape(markdown: item.trimmingCharacters(in: .whitespaces)) ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)){
                let script = "renderMarkdown('\(escapedMarkdown)');"
                self.wv.evaluateJavaScript(script)
            }
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

