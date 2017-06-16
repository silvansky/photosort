//
//  main.swift
//  photosort
//
//  Created by Valentine on 03.09.15.
//  Copyright © 2015 silvansky. All rights reserved.
//

import Foundation

let fm: FileManager = FileManager.default

//fm.changeCurrentDirectoryPath("/Users/valentine/Dropbox/Camera Uploads")

var path: String = fm.currentDirectoryPath
let imagesPath = "\(path)/images"
let videosPath = "\(path)/videos"

if CommandLine.argc > 1 {
	path = CommandLine.arguments[1]
}

print("Working at path: \(path)")

do {
	try fm.createDirectory(atPath: imagesPath, withIntermediateDirectories: true, attributes: nil)
	try fm.createDirectory(atPath: videosPath, withIntermediateDirectories: true, attributes: nil)

	let allFiles = try fm.contentsOfDirectory(atPath: path)

	let images = allFiles.filter({ (file: String) -> Bool in
		return file.hasSuffix("jpg")
	})

	let videos = allFiles.filter({ (file: String) -> Bool in
		return file.hasSuffix("mov")
	})

	print("Found \(allFiles.count) files, \(images.count) images and \(videos.count) videos.")

	let totalImageCount = images.count

	var subdirs: [String: [String]] = [:]

	for (index, file) in images.enumerated() {
		let datePrefix = file.substring(to: file.characters.index(file.startIndex, offsetBy: 7))
		if let arr = subdirs[datePrefix] {
			subdirs[datePrefix] = arr + [file]
		} else {
			subdirs[datePrefix] = [file]
		}
	}

	print("Moving images into \(subdirs.count) dirs")

	for (subdir, files) in subdirs {
		let subdirPath = "\(imagesPath)/\(subdir)"
		try fm.createDirectory(atPath: subdirPath, withIntermediateDirectories: true, attributes: nil)
		print("Processing directory \(subdir)...")
		for file in files {
			try fm.moveItem(atPath: "\(path)/\(file)", toPath: "\(subdirPath)/\(file)")
		}
	}

	print("Moving videos into \(videosPath) dir")

	for file in videos {
		try fm.moveItem(atPath: "\(path)/\(file)", toPath: "\(videosPath)/\(file)")
	}

} catch {
	print("Failure!")
}
