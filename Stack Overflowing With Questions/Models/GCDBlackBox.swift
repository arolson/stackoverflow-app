//
//  GCDBlackBox.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 11/5/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
func performInBackGround(_ handler: @escaping () ->Void)
{
    DispatchQueue.global(qos: .userInitiated).async {
      handler()
    }
}

func dispatchAfter(updates: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
        updates()
    }
}
