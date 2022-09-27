//
//  PokemonAnotacao.swift
//  PokemonGO2
//
//  Created by Wesley Camilo on 27/07/22.
//

import UIKit
import MapKit
class PokemonAnotacao: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
    
}
