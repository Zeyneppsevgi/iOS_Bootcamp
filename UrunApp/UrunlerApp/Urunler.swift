//
//  Urunler.swift
//  UrunlerApp
//
//  Created by Zeynep Sevgi on 27.10.2023.
//

import Foundation
//class ürünleri tutuyor.
class Urunler {
    
    var id: Int?
    var ad: String?
    var resim: String?
    var fiyat: Int?
    
    init() {
        
    }
    
    internal init(id: Int, ad: String, resim: String, fiyat: Int) {
        self.id = id
        self.ad = ad
        self.resim = resim
        self.fiyat = fiyat
    }
}
