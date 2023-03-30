//
//  ViewController.swift
//  To-DoApp
//
//  Created by Cenker Soyak on 30.03.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    
    //Ana tablo görünümünü hazırlıyoruz ve ekrana veriyoruz.
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    //To-Do itemlerinin içinde bulunacağı array'i tanımlıyoruz.
    var items = [String]()

    override func viewDidLoad() {
        
        //Ana tablonun içinde gözükecek itemleri belirliyoruz.
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        title = "To-Do List"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    //"+" butonuna tıklandığında ne olacağını belirliyoruz
    @objc func didTapAdd(){
        let alert = UIAlertController(title: "Add To-Do", message: "Enter new To-Do", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter item"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
            if let field = alert.textFields?.first{
                if let text = field.text, !text.isEmpty{
                    print(text)
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        let newEntry = [text]
                        UserDefaults.standard.set(currentItems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    //Oluşturduğumuz items arrayinin içindeki itemlere bağlı olarak kaç adet satır göstereceğimizi beliriliyoruz.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //Her bir hücrede hangi itemlerin gözükeceğini bildiriyoruz.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}
