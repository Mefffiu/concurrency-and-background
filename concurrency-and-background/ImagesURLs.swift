//
//  ImagesURLs.swift
//  concurrency-and-background
//
//  Created by Mateusz Rybka on 24/01/2020.
//  Copyright © 2020 Mateusz Rybka. All rights reserved.
//

import Foundation

struct ImageURLs {
    
    static var IMAGES: Dictionary<String, URL> = {
        let IMAGESURLStrings = [
            "Family" : "https://upload.wikimedia.org/wikipedia/commons/0/04/Dyck,_Anthony_van_-_Family_Portrait.jpg",
            "FatMan" : "https://upload.wikimedia.org/wikipedia/commons/0/06/Master_of_Flémalle_-_Portrait_of_a_Fat_Man_-_Google_Art_Project_(331318).jpg",
            "YoungWoman" : "https://upload.wikimedia.org/wikipedia/commons/c/ce/Petrus_Christus_-_Portrait_of_a_Young_Woman_-_Google_Art_Project.jpg",
            "Grotesque" : "https://upload.wikimedia.org/wikipedia/commons/3/36/Quentin_Matsys_-_A_Grotesque_old_woman.jpg",
            "Battle" : "https://upload.wikimedia.org/wikipedia/commons/c/c8/Valmy_Battle_painting.jpg"
        ]
        
        var urls = Dictionary<String,URL>()
        for (key, value) in IMAGESURLStrings {
            urls[key] = URL(string: value)
        }
        return urls
    }()
}
