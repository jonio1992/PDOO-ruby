#encoding: utf-8
require_relative "opcion_menu"
require_relative "metodo_salir_carcel"
require_relative "estado_juego"
require_relative "Qytetet"
require "singleton"
module Controladorqytetet
  class ControladorQytetet
    include Singleton
    @@modelo = ModeloQytetet::Qytetet.instance
    def initialize
      @nombreJugadores = Array.new
    end
    
    def setNombreJugadores(nombreJugadores)
      @nombreJugadores = nombreJugadores
    end
    
    def obtenerOperacionesJuegoValidas()
      permitidas  = Array.new
      if(@@modelo.jugadores == nil)
        permitidas << OpcionMenu::OpcionMenu.index(:INICIARJUEGO)
        else 
          if(@@modelo.estadoJuego == ModeloQytetet::EstadoJuego::ALGUNJUGADORENBANCARROTA)
            permitidas << OpcionMenu::OpcionMenu.index(:OBTENERRANKING)
          elsif (@@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_PREPARADO)
            permitidas << OpcionMenu::OpcionMenu.index(:JUGAR)
          elsif(@@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_PUEDEGESTIONAR)
            permitidas << OpcionMenu::OpcionMenu.index(:PASARTURNO)
            permitidas << OpcionMenu::OpcionMenu.index(:VENDERPROPIEDAD)
            permitidas << OpcionMenu::OpcionMenu.index(:HIPOTECARPROPIEDAD)
            permitidas << OpcionMenu::OpcionMenu.index(:CANCELARHIPOTECA)
            permitidas << OpcionMenu::OpcionMenu.index(:EDIFICARCASA)
            permitidas << OpcionMenu::OpcionMenu.index(:EDIFICARHOTEL)
          elsif(@@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_PUEDECOMPRAROGESTIONAR)
            permitidas << OpcionMenu::OpcionMenu.index(:COMPRARTITULOPROPIEDAD)
            permitidas << OpcionMenu::OpcionMenu.index(:VENDERPROPIEDAD)
            permitidas << OpcionMenu::OpcionMenu.index(:HIPOTECARPROPIEDAD)
            permitidas << OpcionMenu::OpcionMenu.index(:CANCELARHIPOTECA)
            permitidas << OpcionMenu::OpcionMenu.index(:EDIFICARCASA)
            permitidas << OpcionMenu::OpcionMenu.index(:EDIFICARHOTEL)
            permitidas << OpcionMenu::OpcionMenu.index(:PASARTURNO)
          elsif(@@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_CONSORPRESA) 
            permitidas << OpcionMenu::OpcionMenu.index(:APLICARSORPRESA)
          elsif(@@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_ENCARCELADO)
            permitidas << OpcionMenu::OpcionMenu.index(:PASARTURNO)
          elsif(@@modelo.estadoJuego == ModeloQytetet::EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD) 
            permitidas << OpcionMenu::OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD)
            permitidas << OpcionMenu::OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO)
          end
          permitidas << OpcionMenu::OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          permitidas << OpcionMenu::OpcionMenu.index(:MOSTRARJUGADORES)
          permitidas << OpcionMenu::OpcionMenu.index(:MOSTRARTABLERO)
          permitidas << OpcionMenu::OpcionMenu.index(:TERMINARJUEGO)
      end
      return permitidas
    end
    
    def necesitaElegirCasilla(opcionMenu)
      opcion = OpcionMenu::OpcionMenu.at(opcionMenu)
      return opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:HIPOTECARPROPIEDAD)) || opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:CANCELARHIPOTECA)) ||
             opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:EDIFICARCASA)) || opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:EDIFICARHOTEL)) ||
             opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:VENDERPROPIEDAD))
    end
    
    def obtenerCasillasValidas(opcionMenu)
      opcion = OpcionMenu::OpcionMenu.at(opcionMenu)
      
      if(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:HIPOTECARPROPIEDAD)))
        return @@modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false);
      elsif (opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:CANCELARHIPOTECA)))
        return @@modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(true);
      elsif (opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:HIPOTECARPROPIEDAD)))
        return @@modelo.obtenerPropiedadesJugador
      elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:EDIFICARCASA)))
        return @@modelo.obtenerPropiedadesJugador
      elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:EDIFICARHOTEL)))
        return @@modelo.obtenerPropiedadesJugador
      elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:VENDERPROPIEDAD)))
        return @@modelo.obtenerPropiedadesJugador
      end    
        return nil;
    end
    
    def realizarOperacion(opcionElegida, casillaElegida)
      opcion = OpcionMenu::OpcionMenu.at(opcionElegida)
      mensaje = ""
        
        if(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:INICIARJUEGO)))
           @@modelo.inicializarJuego(@nombreJugadores)
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:JUGAR)))
           @@modelo.jugar()
            mensaje = "El dado ha sido tirado y te ha salido un: " + "#{@@modelo.getValorDado()}" + ".\n" +"#{@@modelo.obtenerCasillaJugadorActual()}"
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:APLICARSORPRESA)))
            mensaje = "Sorpresa aplicada:\n" + "#{@@modelo.cartaActual}"
           @@modelo.aplicarSorpresa()
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD)))
          @@modelo.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::PAGANDOLIBERTAD)
                mensaje = "Saliste pagando....que poderio XD"
            if(@@modelo.jugadorActualEncarcelado)
                mensaje = "No se pudo salir de la carcel."
            end
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO)))
           @@modelo.intentarSalirCarcel(ModeloQytetet::MetodoSalirCarcel::TIRANDODADO)
                 mensaje = "Saliste tirando dato."
            if(@@modelo.jugadorActualEncarcelado())
                mensaje = "No se pudo salir de la carcel."
            end
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:COMPRARTITULOPROPIEDAD)))
           comprado =@@modelo.comprarTituloPropiedad()
                mensaje = "Compra de la propiedad, con exito!."
            if(!comprado)
                mensaje = "No se pudo comprar: no tienes saldo suficiente."
            end
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:CANCELARHIPOTECA)))
            cancelada =@@modelo.cancelarHipoteca(casillaElegida)
                mensaje = "Cancelacion con exito "
            if(!cancelada)
                mensaje = "No se pudo cancelar. "
            end
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:EDIFICARCASA)))
            sepudo =@@modelo.edificarCasa(casillaElegida)
                mensaje = "Casa edificada"
            if(!sepudo)
                mensaje = "No se pudo edificar la casa. "
            end
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:EDIFICARHOTEL)))
            sepudo =@@modelo.edificarHotel(casillaElegida)
            mensaje = "Hotel edificado"
            if(!sepudo)
                mensaje = "No se pudo edificar el hotel. "
            end
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:VENDERPROPIEDAD)))
            vendida = @@modelo.venderPropiedad(casillaElegida)
                mensaje = "Venta satisfactoria"
            if(!vendida)
                mensaje = "No se pudo vender la propiedad. "
            end
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:PASARTURNO)))
           @@modelo.siguienteJugador()
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:OBTENERRANKING)))
           @@modelo.obtenerRanking()
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:TERMINARJUEGO)))
            puts "Juego terminado"
            abort("")
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:MOSTRARJUGADORACTUAL)))
            mensaje =@@modelo.jugadorActual().to_s
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:MOSTRARJUGADORES)))
            for jugador in @@modelo.jugadores
              mensaje += jugador.to_s + "\n"
            end
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:MOSTRARTABLERO)))
            mensaje = @@modelo.tablero().to_s
        elsif(opcion == OpcionMenu::OpcionMenu.at(OpcionMenu::OpcionMenu.index(:HIPOTECARPROPIEDAD)))
           @@modelo.hipotecarPropiedad(casillaElegida)
        end
        return mensaje
    end
  end
end
