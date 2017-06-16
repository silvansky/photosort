//
//  exec.swift
//  photosort
//
//  Created by Valentine on 03.09.15.
//  Copyright © 2015 silvansky. All rights reserved.
//

import Foundation

func exec(_ command: String) -> String {
	let task = Process()
	task.launchPath = "/bin/bash"
	let args = ["-c", command]
	task.arguments = args

	let pipe = Pipe()
	task.standardOutput = pipe
	task.launch()

	let data = pipe.fileHandleForReading.readDataToEndOfFile()
	let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

	return output;
}
