# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'controladorqytetet'
require_relative 'qytetet'
require_relative 'opcion_menu'


module Vistatextualqytetet
    class VistaTextualQytetet
       @@controlador = Controladorqytetet::ControladorQytetet.instance
       @@modelo = ModeloQytetet::Qytetet.instance
    def obtenerNombreJugadores()
      nombres = Array.new
      n = 0
      
      puts "Introduzca numero de jugadores: "
      n=gets.chomp.to_i
      
      if n <= ModeloQytetet::Qytetet.getMaxJugadores and n >= 2
        for i in 0...n
          puts "Escribe el nombre del jugador #{i}: "
          cadena = gets
          nombres << cadena
        end
      end
      nombres
    end
    
    def elegirCasilla(opcionMenu)
      casillas = @@controlador.obtenerCasillasValidas(opcionMenu)
      casillass = Array.new

      if(casillas.empty?())
        return -1;
      else
        print "\nIndique la casilla que desea cambiar: "
        for cas in casillas
          print"#{cas} "
          casillass << (cas.to_s)
        end
        print "\n"
        return (leerValorCorrecto(casillass)).to_i
      end
    end
    
    def leerValorCorrecto(valoresCorrectos)
      orden = ""
      correcto = false
      while(!correcto)
        puts "Que quieres hacer? "
        orden = gets.chomp
        
        for valor in valoresCorrectos
          if(orden == valor.to_s)
            correcto = true
          end
        end
        if(!correcto)
          puts "Orden no valida, try again"
        end
      end
      return orden
    end
    
    def elegirOperacion()
      operaciones = @@controlador.obtenerOperacionesJuegoValidas
      ops = Array.new
      puts "Ordenes disponibles: "
      for operacion in operaciones
        print "#{Controladorqytetet::OpcionMenu::OpcionMenu[operacion]} (#{operacion}) "
        ops << operacion.to_i
      end
      puts ""
      self.leerValorCorrecto(ops).to_i
    end
    
    def self.main
      ui = VistaTextualQytetet.new
      @@controlador.setNombreJugadores(ui.obtenerNombreJugadores)
      operacionElegida, casillaElegida = 0
      while(true)
        operacionElegida = ui.elegirOperacion
        necesitaElegirCasilla = @@controlador.necesitaElegirCasilla(operacionElegida)
        if(necesitaElegirCasilla)
          casillaElegida = ui.elegirCasilla(operacionElegida)
        end
        if(!necesitaElegirCasilla || casillaElegida >= 0)
          puts @@controlador.realizarOperacion(operacionElegida, casillaElegida)
        end
      end
    end
  end
  VistaTextualQytetet.main
end
