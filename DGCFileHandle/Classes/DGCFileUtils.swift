//
//  DGCFileUtils.swift
//  VLDLive
//
//  Created by Pi0007-linwieyan on 2024/2/21.
//

import Foundation
import MGLog

//let LogsPath = "logs"

public class DGCFileUtils {
    
    public enum DGCFileDirType : String , CaseIterable{
        case normal = "normal/"
        case animation = "animation/" // 动画资源
        case log = "logs/" // 日志
        case other = "other/" // 其他
        case music = "music/" // 音乐
        case expression = "expression/" // 表情
        case db = "db/" //数据库
        case lanuch = "lanuch/" // 开屏
        case theme = "theme/" //主题
    }
    
    public static let share = DGCFileUtils()
    
    private let dgc_fileManager = FileManager.default
//    private let dgc_paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    private var dgc_rootDir = "/Mango/"

    
    private init() {
        //获取document路径
        let dgc_paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //根目录
        let dgc_doucmentDir = dgc_paths.first ?? ""
        dgc_rootDir = dgc_doucmentDir + dgc_rootDir
        
        DGCFileDirType.allCases.forEach { dgc_type in
            let dgc_dirPath = dgc_rootDir + dgc_type.rawValue
            createDir(dir: dgc_dirPath)
        }
    }
    
//    public func createBaseDir() {
//        //创建文件夹
//        createDir(dir: rootDir)
//    }
    
    public func createDir(dir : String)  {
        
        let dgc_isExists = dgc_fileManager.fileExists(atPath: dir)
        if dgc_isExists == false{
            do {
                try dgc_fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true)
            } catch let dgc_err {
                MGLog.error("创建文件夹失败=\(dir) err = \(dgc_err)")
            }
        }
    }
    
    /// 判断文件是否存在
    public func fileExists(fileName : String, type : DGCFileDirType = .normal) -> Bool {
        let dgc_filePath = self.getFileFullPath(fileName: fileName,type: type)
        let dgc_isExists = fileExistsFullPath(fileFullPath: dgc_filePath)
        return dgc_isExists
    }
    
    // 获取文件路径 生存
    public func getFileFullPath(fileName : String, type : DGCFileDirType = .normal) -> String {
        return dgc_rootDir + type.rawValue + fileName
    }
    
    public func fileExistsFullPath(fileFullPath : String) -> Bool {
        let dgc_fileFullPath = dgc_handlePath(oPath: fileFullPath)
        let dgc_isExists = dgc_fileManager.fileExists(atPath: dgc_fileFullPath)
        return dgc_isExists
    }
    
    // 获取类型的目录
    public func getDir(type : DGCFileDirType) -> String {
        dgc_rootDir + type.rawValue
    }
        
//    public func getPathLogs() -> String {
//        return dgc_rootDir + DGCFileDirType.log.rawValue
//    }
    
    /// 获取目录下所有文件名
    public func getDirAllFile(dirPath : String) -> [String] {
        let dgc_path = dgc_handlePath(oPath: dirPath)
        let dgc_contentsOfPath = try? dgc_fileManager.contentsOfDirectory(atPath: dgc_path)
        return dgc_contentsOfPath ?? []
    }
    
    private func dgc_handlePath(oPath : String) -> String {
        var dgc_path = oPath
        if oPath.hasPrefix("file://"){
            dgc_path = oPath.replacingOccurrences(of: "file://", with: "")
        }
        return dgc_path
    }
    
    /// 删除文件 完整路径
    public func deleteFileFullPath(filePath : String){
        let dgc_path = dgc_handlePath(oPath: filePath)
        //删除文件
        do {
            try dgc_fileManager.removeItem(atPath: dgc_path)
        } catch let dgc_err {
            MGLog.log("deleteFile失败=\(dgc_err)")
        }
    }
}
