//
//  ViewController.swift
//  PokemonGO2
//
//  Created by Wesley Camilo on 26/07/22.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorDeLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemon: CoreDataPokemon!
    var pokemons: [Pokemon] = []
    override func viewDidLoad() {
        super.viewDidLoad()
    
        mapa.delegate = self
        gerenciadorDeLocalizacao.delegate = self
        gerenciadorDeLocalizacao.requestWhenInUseAuthorization()
        gerenciadorDeLocalizacao.startUpdatingLocation()
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recuperarTodosPokemons()
        
        Timer.scheduledTimer(withTimeInterval: 8, repeats: true) { timer in
            print("Exibir Anotação")
            if let coordenadas = self.gerenciadorDeLocalizacao.location?.coordinate{
                let totalPokemons = UInt32(self.pokemons.count)
                let indicePokemonAleatorio = arc4random_uniform(totalPokemons)
                let pokemon = self.pokemons[Int(indicePokemonAleatorio)]
                let anotacao = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemon)
                let latAleatoria = (Double(arc4random_uniform(400)) - 200) / 100000.0
                let longAleatoria = (Double(arc4random_uniform(400)) - 200) / 100000.0
                anotacao.coordinate = coordenadas
                anotacao.coordinate.latitude += latAleatoria
                anotacao.coordinate.longitude += longAleatoria
                self.mapa.addAnnotation(anotacao)
            }
        }
      
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            anotacaoView.image = UIImage(named: "player")
        }else {
            let pokemon = (annotation as! PokemonAnotacao).pokemon
            anotacaoView.image = UIImage(named: pokemon.nomeimagem!)
        }
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        anotacaoView.frame = frame
        return anotacaoView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let anotacao = view.annotation
        let pokemon = (view.annotation as! PokemonAnotacao).pokemon
        mapView.deselectAnnotation(anotacao, animated: true)
        if anotacao is MKUserLocation {
            return
        }
        if let coordenadas = anotacao?.coordinate {
            let regiao = MKCoordinateRegion.init(center: coordenadas, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (time) in
             if let coord = self.gerenciadorDeLocalizacao.location?.coordinate{
                 if self.mapa.visibleMapRect.contains(MKMapPoint.init(coord)){
                     print("Voce pode capiturar o pokemon")
                     self.coreDataPokemon.salvarPokemons(pokemon: pokemon)
                     self.mapa.removeAnnotation(anotacao!)
                     let alertaControoler = UIAlertController(title: "Parabéns!!", message: "Você capturou um Pokemon:\(pokemon.nome!)", preferredStyle: .alert)
                     let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                     alertaControoler.addAction(ok)
                     self.present(alertaControoler, animated: true, completion: nil)
                 }else {
                     let alertaControoler = UIAlertController(title: "Vocé não pode capturar", message: "Você precisa se aproximar para capturar o Pokemon:\(pokemon.nome!)", preferredStyle: .alert)
                     let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                     alertaControoler.addAction(ok)
                     self.present(alertaControoler, animated: true, completion: nil)
                 }
            }
        }
    
    }
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            let alertaController = UIAlertController(title: "Permissão da Localização", message: "Para que você possa caçar Pokemons, precisamos da sua localização!, por favor habilite!! ", preferredStyle: .alert)
            let acaoConfiguracao = UIAlertAction(title: "Abrir Configuraçoes", style: .default) { alertaConfiguracoes in
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            }
            let acaoCanselar = UIAlertAction(title: "Canselar", style: .default, handler: nil)
            alertaController.addAction(acaoConfiguracao)
            alertaController.addAction(acaoCanselar)
            present(alertaController, animated: true, completion: nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            if contador < 3 {
                self.centralizar()
                contador += 1
            } else {
                gerenciadorDeLocalizacao.startUpdatingLocation()
            }
        }
    
    func centralizar() {
        if let coordernadas = gerenciadorDeLocalizacao.location?.coordinate {
            let regiao = MKCoordinateRegion.init(center: coordernadas, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        }
    }
    @IBAction func centralizarUsuario(_ sender: Any) {
        self.centralizar()
    }
    @IBAction func abrirPokedex(_ sender: Any) {
    }
    
}

