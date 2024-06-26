//
//  ViewController.swift
//  KisilerApp
//
//  Created by Zeynep Sevgi on 25.10.2023.
//

import UIKit

class Anasayfa: UIViewController{

    @IBOutlet weak var kisilerTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var kisilerListesi = [Kisiler]()
    var viewModel = AnasayfaViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        kisilerTableView.delegate = self
        kisilerTableView.dataSource = self
     
        _ = viewModel.kisilerListesi.subscribe(onNext: { liste in
            self.kisilerListesi = liste
            self.kisilerTableView.reloadData()
        })
        
    }
    //yaşam döngüsü sayfaya geri dönüldüğünü anlamak için
    override func viewWillAppear(_ animated: Bool) {
        viewModel.kisileriYukle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let kisi = sender as? Kisiler {
                let gidilecekVC = segue.destination as! KisiDetay
                gidilecekVC.kisi = kisi
            }
        }
    }
    

}
extension Anasayfa: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.ara(aramaKelimesi: searchText)
    }
}
extension Anasayfa: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisilerListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kisi = kisilerListesi[indexPath.row]
        //celle eriştik tableviewe
        let hucre = tableView.dequeueReusableCell(withIdentifier: "kisilerHucre") as! KisilerHucre
        hucre.labelKisiAd.text = kisi.kisi_ad
        hucre.labelKisiTel.text = kisi.kisi_tel
        //tek tek labelları alıp yazdırıcak tableviewe
        return hucre
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kisi = kisilerListesi[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: kisi)
        tableView.deselectRow(at: indexPath, animated: true) //seçili olma özelliğini kaldırıyor
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil") {contextualAction, view, bool in
            let kisi = self.kisilerListesi[indexPath.row]
            
            let alert = UIAlertController(title: "Silme işlemi", message: "\(kisi.kisi_ad!) silinsin mi?", preferredStyle: .alert)
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel)
            alert.addAction(iptalAction)
            
            let evetAction = UIAlertAction(title: "evet", style: .destructive){ action in
                    self.viewModel.sil(kisi_id: kisi.kisi_id!)
            }
            alert.addAction(evetAction)
            self.present(alert, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [silAction])
    }
    
    
}

