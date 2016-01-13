//
//  exec.swift
//  photosort
//
//  Created by Valentine on 03.09.15.
//  Copyright © 2015 silvansky. All rights reserved.
//

import Foundation

func exec(command: String) -> String {
	let task = NSTask()
	task.launchPath = "/bin/bash"
	let args = ["-c", command]
	task.arguments = args

	let pipe = NSPipe()
	task.standardOutput = pipe
	task.launch()

	let data = pipe.fileHandleForReading.readDataToEndOfFile()
	let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String

	return output;
}
