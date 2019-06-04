require_relative 'tablero'
require_relative 'dado'
require_relative 'jugador'
require_relative 'estado_juego'
require_relative 'metodo_salir_carcel'
require_relative 'sorpresa'
require_relative 'tipo_sorpresa'

require "singleton"

module ModeloQytetet
  class Qytetet
    include Singleton
    #attr_accessor :cartaActual, :estadoJuego
    attr_reader :mazo, :tablero, :dado, :jugadorActual, :jugadores, :metodosalircarcel, :cartaActual, :estadoJuego
    
    @@MAX_JUGADORES = 4
    @@NUM_SORPRESAS = 12
    @@MAX_CASILLAS = 20
    @@PRECIO_LIBERTAD = 200
    @@SALDO_SALIDA = 1000
    
    def initialize 
         @mazo = Array.new
         @cartaActual = nil
         @jugadorActual = nil
         @jugadores = nil
         @dado = Dado.instance
         @estadoJuego = nil
    end
    
    #methods
    
    def inicializarCartasSorpresa
      
      #:salir_carcel
      @mazo<< Sorpresa.new(
                "Un fan anonimo ha pagado tu fianza. Sales de la carcel", 
                2, 
                TipoSorpresa::SALIRCARCEL)
      #ir_a_casilla 
      @mazo<< Sorpresa.new(
                "La liga antisupersticin te enva de viaje al nmero 13",
                13, 
                TipoSorpresa::IRACASILLA)
              
      @mazo<< Sorpresa.new(
                "Viaja a la casilla de salida",
                0, 
                TipoSorpresa::IRACASILLA)
      @mazo<< Sorpresa.new(
        
                "Te han pillado sin pagar tus impuesto de propiedades, vas a la carcel!",
                @tablero.carcel, 
                TipoSorpresa::IRACASILLA)
              
      #por_jugador
      @mazo<< Sorpresa.new(
                "Es tu cumpleanios!, recibes 20 de los demas jugadores",
                -20, 
                TipoSorpresa::PORJUGADOR)

      @mazo<< Sorpresa.new(
                "Tus companieros te han pillado mangando, dales 10 para callar su silencio",
                10, 
                TipoSorpresa::PORJUGADOR)
      #por_casa_hotel
      @mazo<< Sorpresa.new(
                "Ayuda a las reparaciones de tus propiedades",
                -50, 
                TipoSorpresa::PORCASAHOTEL)
      @mazo<< Sorpresa.new(
                "Impuesto de propiedades",
                50, 
                TipoSorpresa::PORCASAHOTEL)
      #pagar_cobrar
      @mazo<< Sorpresa.new(
                "Error de la banca, cobras 50",
                50, 
                TipoSorpresa::PAGARCOBRAR)
      @mazo<< Sorpresa.new(
                "Gastos minibar, -50",
                -50, 
                TipoSorpresa::PAGARCOBRAR)
      #especulador
      @mazo<< Sorpresa.new(
                "CONVERTIRME 1",
                3000, 
                TipoSorpresa::CONVERTIRME)
      @mazo<< Sorpresa.new(
                "CONVERTIRME 2",
                5000, 
                TipoSorpresa::CONVERTIRME)
      
      #random
      @mazo = @mazo.shuffle
      
    end
    
    def inicializarTablero
      @tablero = Tablero.new
    end
    
    def actuarSiEnCasillaEdificable
      #pract3
      #puts @jugadorActual.to_s
      deboPagar = @jugadorActual.deboPagarAlquiler
      
      if deboPagar
        @jugadorActual.pagarAlquiler
        
        if @jugadorActual.saldo <= 0
          @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCAROTA
        end
      end

      casilla = @jugadorActual.casillaActual
      
      tengoPropietario = casilla.tengoPropietario
      
      if @estadoJuego != EstadoJuego::ALGUNJUGADORENBANCARROTA
        if tengoPropietario
          @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
        else
          @estadoJuego = EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
        end
      end
    end
    
    def actuarSiEnCasillaNoEdificable
      #pract3
       @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      
      casillaActual = @jugadorActual.casillaActual
      
      if casillaActual.tipoCasilla == TipoCasilla::IMPUESTO
        @jugadorActual.pagarImpuesto
      
      elsif casillaActual.tipoCasilla == TipoCasilla::JUEZ
        encarcelarJugador
        
      elsif casillaActual.tipoCasilla == TipoCasilla::SORPRESA
        @cartaActual = @mazo[0]
        @mazo.delete_at(0)
        @mazo << @cartaActual
        @estadoJuego = EstadoJuego::JA_CONSORPRESA
      end
    end
    
    def aplicarSorpresa
      #pract3
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      
      if @cartaActual.tipo == TipoSorpresa::SALIRCARCEL
        @jugadorActual.cartaLibertad = @cartaActual
       
        
      elsif @cartaActual.tipo == TipoSorpresa::PAGARCOBRAR
        @jugadorActual.modificarSaldo(@cartaActual.valor)
        if @jugadorActual.saldo < 0
          @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCAROTA
        end
        
      elsif @cartaActual.tipo == TipoSorpresa::IRACASILLA
        valor = @cartaActual.valor
        casillaCarcel = @tablero.esCasillaCarcel(valor)
        if casillaCarcel
          encarcelarJugador
          
        else
          mover(valor)
        end
      
      elsif @cartaActual.tipo == TipoSorpresa::PORCASAHOTEL
        cantidad = @cartaActual.valor
        numeroTotal = @jugadorActual.cuantasCasasHotelesTengo
        @jugadorActual.modificarSaldo(cantidad*numeroTotal)
        
        if @jugadorActual.saldo < 0
          @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCAROTA
        end
        
      elsif @cartaActual.tipo == TipoSorpresa::PORJUGADOR
        for i in 0...@jugadores.size
          jugador = @jugadores[i]
          
          if jugador != @jugadorActual
            jugador.modificarSaldo(@cartaActual.valor)
            if jugador.saldo < 0
              @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCAROTA
            end
            
            @jugadorActual.modificarSaldo(-@cartaActual.valor)
            
            if @jugadorActual.saldo < 0
              @estadoJuego = EstadoJuego::ALGUNJUGADORENBANCAROTA
            end
          end
        end
      elsif @cartaActual.tipo == TipoSorpresa::CONVERTIRME
          espec = @jugadorActual.convertirme(@cartaActual.valor)
          @jugadores[@jugadores.index(@jugadorActual)] = espec
          @jugadorActual = espec        
      end
    end
    
    def cancelarHipoteca(numeroCasilla)
      #pract3

      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo;
      esEdificable = casilla.soyEdificable        
      hipotecada = titulo.hipotecada
      cancelar = false

      if (esEdificable && hipotecada)#condicion: casilla edificable que es propiedad del jugadorActual y que está hipotecada.
          cancelar = @jugadorActual.cancelarHipoteca(titulo)
      end
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR

      return cancelar
    end
    
    def comprarTituloPropiedad
      #pract3
      #puts @jugadorActual.comprarTituloPropiedad
      comprado = @jugadorActual.comprarTituloPropiedad
      if comprado
        @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
      
      comprado
    end
    
    def edificarCasa(numeroCasilla)
      #pract3
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      edificada = @jugadorActual.edificarCasa(titulo)
      
      if edificada
        @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
      
      edificada
    end
    
    
    def edificarHotel(numeroCasilla)
      #pract3
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      edificado = @jugadorActual.edificarHotel(titulo)
      
      if edificado
        @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end
      
      edificado
    end
    
    def encarcelarJugador
      unless @jugadorActual.tengoCartaLibertad #if(!@jugadorActual.tengoCartaLibertad)
        casillaCarcel = @tablero.carcel
        @jugadorActual.irACarcel(casillaCarcel)
        @estadoJuego = EstadoJuego::JA_ENCARCELADO
      else
        carta = @jugadorActual.devolverCartaLibertad
        @mazo << carta
        @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
      end  
    end
    
    def getValorDado
      #pract3
      dado.valor
    end
    
    def hipotecarPropiedad(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      @jugadorActual.hipotecarPropiedad(titulo)
      @estadoJuego = EstadoJuego::JA_PUEDEGESTIONAR
    end
    
    def inicializarJuego(nombres)
      #hacer pract 2
      if(nombres.size() >= 2 && nombres.size() <= @@MAX_JUGADORES && @mazo.size() <= @@NUM_SORPRESAS)
        inicializarJugadores(nombres)
        inicializarTablero
        inicializarCartasSorpresa
        salidaJugadores
      else
        puts "O el numero de jugadores es incorrecto (debe ser de 2 a " + @@MAX_JUGADORES + " jugadores)"
            + "o el numero de cartas es incorrecto (deben ser menor que " + @@NUM_SORPRESAS + ")"
      end
      
    end
    
    def inicializarJugadores(nombres)
      #hacer pract 2
      @jugadores = Array.new
      for i in 0..nombres.size()-1
        @jugadores << Jugador.nuevo(nombres.at(i))
      end
    end
    
    def intentarSalirCarcel(metodo)

      if metodo == MetodoSalirCarcel::TIRANDODADO
        resultado = tirarDado
        if resultado >= 5
          @jugadorActual.encarcelado = false
        end
        
      elsif metodo == MetodoSalirCarcel::PAGANDOLIBERTAD
        @jugadorActual.pagarLibertad(@@PRECIO_LIBERTAD)
        @jugadorActual.encarcelado = false
      end
      
      libre = @jugadorActual.encarcelado
      
      if libre
        @estadoJuego = EstadoJuego::JA_ENCARCELADO
      else
        @estadoJuego = EstadoJuego::JA_PREPARADO
      end
      
      libre
    end
    
    def jugar
      #pract3
      numdado = tirarDado    
      casillaaux = @tablero.obtenerCasillaFinal(@jugadorActual.casillaActual, numdado)
      #obtenerCasillaJugadorActual   
      mover(casillaaux.numeroCasilla);
    end
    
    def mover(numCasillaDestino)
      #puts @jugadorActual.casillaActual
      casillaInicial = self.obtenerCasillaJugadorActual
      casillaFinal = @tablero.obtenerCasillaNumero(numCasillaDestino)
      @jugadorActual.casillaActual = casillaFinal
      
      if numCasillaDestino < casillaInicial.numeroCasilla
        @jugadorActual.modificarSaldo(@@SALDO_SALIDA)        
      end
      
      if(casillaFinal.soyEdificable)
        self.actuarSiEnCasillaEdificable      
      else
        self.actuarSiEnCasillaNoEdificable
      end
    end
    
    def obtenerCasillaJugadorActual
      #pract3
      #puts @jugadorActual.casillaActual
      @jugadorActual.casillaActual
    end
    
    #def obtenerCasillasTablero
    #  raise NotImplementedError
    #end
    
    def obtenerPropiedadesJugador
      #pract3
      propiedadesJA = Array.new
      #casillas = Array.new
      ncasillas = Array.new
      propiedadesJA = @jugadorActual.propiedades
      casillas = @tablero.casillas
      for propiedad in propiedadesJA do
        for casilla in casillas do
          if (casilla.titulo == propiedad)
            ncasillas << casilla.numeroCasilla
          end
        end
      end
      return ncasillas
         
    end
    
    def obtenerPropiedadesJugadorSegunEstadoHipoteca(estadoHipoteca)
      #prac3
      propiedadesJA = Array.new
      casillas = Array.new
      casillasHip = Array.new
      propiedadesJA = @jugadorActual.propiedades
      casillas = @tablero.casillas
      for propiedad in propiedadesJA do
        for casilla in casillas do
          if (casilla.titulo == propiedad and propiedad.hipotecada == estadoHipoteca)
            casillasHip << casilla.numeroCasilla
          end
        end
      end
      return casillasHip
    end
    
    def obtenerRanking
      #pract3
      @jugadores=@jugadores.sort
    end
    
    def obtenerSaldoJugadorActual
      #pract3
      @jugadorActual.saldo
    end
    
    def salidaJugadores
      #prac3
#      for jug in @jugadores
#        jug.casillaActual = @tablero.obtenerCasillaNumero(0)
#      end       
#        
#      valor = Random.new
#      @jugadorActual = @jugadores.at(valor.rand(@jugadores.length)+1)     
#
#      @estadoJuego = EstadoJuego::JA_PREPARADO
for jugador in @jugadores do
        jugador.casillaActual = @tablero.obtenerCasillaNumero(0)
      end
      #turno = Random.new
      primero = rand(0...@jugadores.length)
      @iterador = primero
      @jugadorActual = @jugadores.at(primero)
      @estadoJuego = EstadoJuego::JA_PREPARADO

    
    end
    
    def siguienteJugador
      #prac3
#       posjugctual = @jugadores.index(@jugadorActual);       
#        
#        if(posjugctual == @jugadores.length-1)
#            @jugadorActual = @jugadores.at(0);
#        
#        else
#            @jugadorActual = @jugadores.at(posjugctual+1);
#        end
#      
#      if (@jugadorActual.encarcelado)
#        @estadoJuego = EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
#      else
#        @estadoJuego = EstadoJuego::JA_PREPARADO
#      end
      @iterador += 1
      @iterador = @iterador%@jugadores.length
      
      @jugadorActual = @jugadores.at(@iterador)
      if (@jugadorActual.encarcelado)
        @estadoJuego = EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
      else
        @estadoJuego = EstadoJuego::JA_PREPARADO
      end
    
    end
    
    def tirarDado
      #pract3
      dado.tirar
    end
    
    def venderPropiedad(numeroCasilla)
        #pract3
       casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
       @jugadorActual.venderPropiedad(casilla)
       @estado = EstadoJuego::JA_PUEDEGESTIONAR
    end
    
    def self.getMaxJugadores#p5
      @@MAX_JUGADORES
    end
    
    def jugadorActualEncarcelado
        #p5
        return @jugadorActual.encarcelado
    end
    
    def to_s
      textomazo = " "
      @mazo.each {|i| textomazo =  textomazo + "\n\n" + i.to_s }
      
      textojugadores = " "
      @jugadores.each {|k| textojugadores = textojugadores + "\n\n" + k.to_s}
      
      
      "El juego Qutetet se compone de :  
            \n********************************Mazo: ********************************\n "+
            textomazo +
            "\n********************************Tablero: ********************************\n "+
            @tablero.to_s +
            "\n********************************Jugadores********************************\n  "+
            #@jugadores.to_s 
             textojugadores
    end
    
    #descomentar porque es privado, cometar para hacerlo funcionar prac 1
    #private :tablero 
    private :encarcelarJugador, :inicializarCartasSorpresa, :inicializarJugadores, :inicializarTablero, :salidaJugadores

  end
end
