

module ModeloQytetet
  module TipoSorpresa
      PAGARCOBRAR = :pagar_cobrar
      IRACASILLA = :ir_a_casilla
      PORCASAHOTEL = :por_casa_hotel
      PORJUGADOR = :por_jugador
      SALIRCARCEL = :salir_carcel
      CONVERTIRME = :convertirme
  end
end

#La forma de acceder a ellos sería TipoSorpresa::PAGARCOBRAR 
#o bien TipoSorpresa.const_get(PAGARCOBRAR)