//
//  CoredDataPokemon.swift
//  PokemonGO2
//
//  Created by Wesley Camilo on 27/07/22.
//

import UIKit
import CoreData

class CoreDataPokemon {
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    func recuperarPokemoncapiturado(capiturado:Bool) -> [Pokemon] {
        let context = self.getContext()
        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        requisicao.predicate = NSPredicate(format: "capturado = %@", NSNumber(value: capiturado))
        do {
           let pokemons =  try context.fetch(requisicao) as [Pokemon]
            return pokemons
        } catch  {
            
        }
        return []
    }
    
    func salvarPokemons(pokemon: Pokemon) {
        let context = self.getContext()
        pokemon.capturado = true
        do {
            try context.save()
        } catch  {
        }
    }
    
    func recuperarTodosPokemons() -> [Pokemon] {
        let context = self.getContext()
        do {
            let pokemon = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            if pokemon.count == 0 {
                self.adicionarTodosPokemons()
                return self.recuperarTodosPokemons()
            }
            return pokemon
        } catch  {
            
        }
        return []
    }
    
    func adicionarTodosPokemons() {
        let context = self.getContext()
        
        self.criarPokemon(nome: "Pikachu" , nomeImagem: "pikachu-2" , capturado: true)
        self.criarPokemon(nome: "Bellsprout" , nomeImagem: "bellsprout" , capturado: false)
        self.criarPokemon(nome: "Bullbasaur" , nomeImagem: "bullbasaur" , capturado: false)
        self.criarPokemon(nome: "Caterpie" , nomeImagem: "caterpie" , capturado: false)
        self.criarPokemon(nome: "Charmander" , nomeImagem: "charmander" , capturado: false)
        self.criarPokemon(nome: "Psyduck" , nomeImagem: "psyduck" , capturado: false)
        self.criarPokemon(nome: "Rattata" , nomeImagem: "rattata" , capturado: false)
        self.criarPokemon(nome: "Snorlax" , nomeImagem: "snorlax" , capturado: false)
        self.criarPokemon(nome: "Squirtle" , nomeImagem: "squirtle" , capturado: false)
        self.criarPokemon(nome: "Zubat" , nomeImagem: "zubat" , capturado: false)
        self.criarPokemon(nome: "Meowth" , nomeImagem: "meowth" , capturado: false)
        self.criarPokemon(nome: "Mew" , nomeImagem: "mew" , capturado: false)
        do {
            try context.save()
        } catch  {
            
        }
    }
    
    func criarPokemon(nome: String, nomeImagem: String, capturado: Bool)  {
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        pokemon.nome = nome
        pokemon.nomeimagem = nomeImagem
        pokemon.capturado = capturado
    }
}
