//
//  DebugPrint.swift
//  iOSTest201904
//
//  Created by YukiOkudera on 2019/04/20.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation

/// デバッグ時のみ出力するログ
///
/// - Parameters:
///   - debug: 出力する文字列
///   - function: 関数名
///   - file: ファイル名
///   - line: 行数
func print(debug: Any = "", function: String = #function, file: String = #file, line: Int = #line) {
    #if DEBUG
    let filename: NSString = file as NSString
    Swift.print("File: \(filename.lastPathComponent), Line: \(line), Func: \(function) > \(debug)")
    #endif
}
