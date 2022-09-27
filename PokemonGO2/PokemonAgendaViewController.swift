//
//  PokemonAgendaViewController.swift
//  PokemonGO2
//
//  Created by Wesley Camilo on 28/07/22.
//

import UIKit

class PokemonAgendaViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var pokemonsCapiturados: [Pokemon] = []
    var pokemonsNaoCapiturados: [Pokemon] = []
    
    @IBAction func voltarMapa(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let coreDataPokemon = CoreDataPokemon()
        self.pokemonsCapiturados = coreDataPokemon.recuperarPokemoncapiturado(capiturado: true)
        self.pokemonsNaoCapiturados = coreDataPokemon.recuperarPokemoncapiturado(capiturado: false)
        print(String(self.pokemonsNaoCapiturados.count))
        
    }
    
    // MARK: - Navigation
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Capturados"
        }else {
            return "Não Capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.pokemonsCapiturados.count
        }else {
            return self.pokemonsNaoCapiturados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var pokemon = Pokemon()
        if indexPath.section == 0 {
            pokemon = self.pokemonsCapiturados[indexPath.row]
        }else {
            pokemon = self.pokemonsNaoCapiturados[indexPath.row]
        }
        let celula = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "celula")
        celula.textLabel?.text = pokemon.nome
        celula.imageView?.image = UIImage(named: pokemon.nomeimagem!)
        return celula
    }
    
}
