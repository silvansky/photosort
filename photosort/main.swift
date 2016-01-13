//
//  main.swift
//  photosort
//
//  Created by Valentine on 03.09.15.
//  Copyright © 2015 silvansky. All rights reserved.
//

import Foundation

let fm: NSFileManager = NSFileManager.defaultManager()

//fm.changeCurrentDirectoryPath("/Users/valentine/Dropbox/Camera Uploads")

var path: String = fm.currentDirectoryPath
let imagesPath = "\(path)/images"
let videosPath = "\(path)/videos"

if Process.argc > 1 {
	path = Process.arguments[1]
}

print("Working at path: \(path)")

do {
	try fm.createDirectoryAtPath(imagesPath, withIntermediateDirectories: true, attributes: nil)
	try fm.createDirectoryAtPath(videosPath, withIntermediateDirectories: true, attributes: nil)

	let allFiles = try fm.contentsOfDirectoryAtPath(path)

	let images = allFiles.filter({ (file: String) -> Bool in
		return file.hasSuffix("jpg")
	})

	let videos = allFiles.filter({ (file: String) -> Bool in
		return file.hasSuffix("mov")
	})

	print("Found \(allFiles.count) files, \(images.count) images and \(videos.count) videos.")

	let totalImageCount = images.count

	var subdirs: [String: [String]] = [:]

	for (index, file) in images.enumerate() {
		let datePrefix = file.substringToIndex(file.startIndex.advancedBy(7))
		if let arr = subdirs[datePrefix] {
			subdirs[datePrefix] = arr + [file]
		} else {
			subdirs[datePrefix] = [file]
		}
	}

	print("Moving images into \(subdirs.count) dirs")

	for (subdir, files) in subdirs {
		let subdirPath = "\(imagesPath)/\(subdir)"
		try fm.createDirectoryAtPath(subdirPath, withIntermediateDirectories: true, attributes: nil)
		print("Processing directory \(subdir)...")
		for file in files {
			try fm.moveItemAtPath("\(path)/\(file)", toPath: "\(subdirPath)/\(file)")
		}
	}

	print("Moving videos into \(videosPath) dir")

	for file in videos {
		try fm.moveItemAtPath("\(path)/\(file)", toPath: "\(videosPath)/\(file)")
	}

} catch {
	print("Failure!")
}
