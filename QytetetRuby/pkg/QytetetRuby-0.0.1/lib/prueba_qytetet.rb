

require_relative 'tipo_sorpresa'
require_relative 'sorpresa'
require_relative 'qytetet'

module ModeloQytetet
  class PruebaQytetet
        
    attr_reader :mazoprueba
    @@mazoprueba = Array.new
    
    #metodo 1
    def self.sorpresasValorMayor0(mazo)
        puts "soy el sorpresasValorMayor0"
        arrayValor = Array.new
        #Bucle que va desde i hasta el tamaño del mazo
        mazo.each { |sorpresa| arrayValor << sorpresa if sorpresa.valor > 0}
      return arrayValor 
               
    end
    
    #metodo 2
    def self.sorpresastipoIrCasilla(mazo)
        puts "soy el sorpresastipoIrCasilla"
        arrayValor = Array.new
        #Bucle que va desde i hasta el tamaño del mazo
        mazo.each { |sorpresa| arrayValor << sorpresa if sorpresa.tipo == TipoSorpresa::IRACASILLA}
      return arrayValor 
    end

    #metodo 3
    def self.sorpresastipoArgumento(mazo, i)
        puts "soy el sorpresastipoArgumento"
        arrayValor = Array.new
        
          
          puts "Para el tipo #{i}"               
            mazo.each do |sorpresa|
              arrayValor << sorpresa if sorpresa.tipo == TipoSorpresa.const_get(i)
            end         
        
        
      return arrayValor
    end 
    
    #metodo auxiliar para nombre jugadores manual
    def self.getNombreJugadores
      nombres = Array.new
      n = 0
      
      puts "Introduzca numero de jugadores: "
      n=gets.chomp.to_i
      
      if n <= 4 and n >= 2
        for i in 0...n
          puts "Escribe el nombre del jugador #{i}: "
          cadena = gets
          nombres << cadena
        end
      end
      nombres
    end
    
    #--------------------------------Test practicas------------------------------------------#
    def self.pract1
                                                    
                                        #prac 1

      juego = Qytetet.instance
      @@mazoprueba = juego.mazo
      
      #faltan las comprobaciones de los metodos
      
      puts "\nMetodo1 ----------------------------"
     # puts sorpresasValorMayor0(@@mazoprueba)
      
      puts "\nMetodo2 ----------------------------"
      puts sorpresastipoIrCasilla(@@mazoprueba)
    
      
      puts "\nMetodo3 ----------------------------"
      TipoSorpresa::constants.each { |p|  puts sorpresastipoArgumento(@@mazoprueba,p)
                }
      #sesion2
      puts "\nTablero ----------------------------"
      
      puts  juego.tablero.to_s
    end
      
    def self.pract2
      #forma automatica

                                          #prac 2
=begin


      @jugadores = Array.new
      
      @jugadores << "Jug1"
      @jugadores << "Jug2"
      @jugadores << "Jug3"
      
      @qytetet = Qytetet.instance
      @qytetet.inicializarJuego(@jugadores)      
      puts @qytetet.to_s
=end

      
      #prac 2

      @jugadores = Array.new #inicializar array jugadores
      @qytetet = Qytetet.instance #inicializa instancia qytetet
      
      begin
         valido=true;
        puts "Escribe el numero de jugadores: (de 2 a 4):"
        lectura = gets.chomp
        
        if Integer(lectura) < 2 
          valido=false
          puts "Numero de jugadores no valido"
        elsif Integer(lectura) >4
          valido =false
          puts "Numero de jugadores no valido"
        end
      end while(!valido)
      
      for i in 1..Integer(lectura)
         puts('Jugador:  '+ i.to_s)
         nombre=gets.chomp
         @jugadores<<nombre
      end
      
      @qytetet.inicializarJuego(@jugadores)      
      puts @qytetet.to_s
    end
    
    def self.pract3
                                          #pract3
      juego = Qytetet.instance
      nombres = getNombreJugadores
      juego.inicializarJuego(nombres)
      puts"---------------------------------------------------------"
      movimiento = juego.tirarDado
      juego.mover(1)
      juego.comprarTituloPropiedad
      puts juego.jugadorActual
      puts "Compro Casa---------------------------------------------"
      juego.edificarCasa(1)
      juego.edificarCasa(1)
      juego.edificarCasa(1)
      juego.edificarCasa(1)
      puts juego.jugadorActual
      puts "Compro hotel---------------------------------------------"
      juego.edificarHotel(1)
      puts juego.jugadorActual
      juego.siguienteJugador
      juego.mover(1)
      puts "Pum! Sablazo-----------------------------------------------"
      puts juego.jugadorActual.saldo
      puts "Im rich --------------------------------------------------"
      juego.siguienteJugador
      puts juego.jugadorActual.saldo
      
      puts juego.obtenerRanking
      
    
    end
        
    #main
    def self.main
      #pract1
      #pract2
      #pract3  
      
    end  
   
  end
  #llama a main del programa
  PruebaQytetet.main
end